import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image/image.dart' as img;

import '../models/claude_analysis_result.dart';

/// Sends captured images to Claude Vision API for trail hazard classification.
class ClaudeService {
  ClaudeService() : _dio = Dio() {
    _dio.options = BaseOptions(
      baseUrl: 'https://api.anthropic.com/v1',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
    );
  }

  final Dio _dio;

  static const _systemPrompt = '''
You are an expert alpine trail safety analyst. Analyze this image and respond ONLY with a valid JSON object matching this exact schema — no markdown, no explanation, just JSON:
{
  "hazard_type": "rockfall|landslide|fallen_tree|flooding|erosion|bridge_damage|other",
  "priority": "critical|high|medium|low",
  "title": "Short headline under 50 characters",
  "description": "2-3 sentence factual description of the hazard visible in the image",
  "proposed_solution": "1-2 sentence actionable recommendation for the trail maintenance team",
  "confidence": 0.0
}
If no clear trail hazard is visible, use hazard_type "other", priority "low", and describe what you see.
''';

  /// Analyse a JPEG image byte array and return structured hazard classification.
  Future<ClaudeAnalysisResult> analyzeImage(Uint8List imageBytes) async {
    final apiKey = dotenv.maybeGet('CLAUDE_API_KEY') ?? '';

    // Use mock result when no real key is configured — guarantees demo works offline.
    if (apiKey.isEmpty || apiKey == 'your-key-here') {
      await Future.delayed(const Duration(milliseconds: 2500));
      return ClaudeAnalysisResult.mock();
    }

    try {
      // Compress image to max 1280×960 @ 85% JPEG quality to reduce API cost/latency.
      final compressed = _compressImage(imageBytes);
      final base64Image = base64Encode(compressed);

      final response = await _dio.post(
        '/messages',
        options: Options(headers: {
          'x-api-key': apiKey,
          'anthropic-version': '2023-06-01',
          'content-type': 'application/json',
        }),
        data: {
          'model': 'claude-opus-4-5',
          'max_tokens': 512,
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'image',
                  'source': {
                    'type': 'base64',
                    'media_type': 'image/jpeg',
                    'data': base64Image,
                  },
                },
                {
                  'type': 'text',
                  'text': _systemPrompt,
                },
              ],
            },
          ],
        },
      );

      final content = response.data['content'] as List;
      final text = content.first['text'] as String;

      // Strip any markdown code fences the model might add despite instructions.
      final cleaned = text.replaceAll(RegExp(r'```json?\n?|```'), '').trim();
      final json = jsonDecode(cleaned) as Map<String, dynamic>;

      return ClaudeAnalysisResult.fromJson(json);
    } catch (e) {
      // Never let an API failure crash the demo flow.
      return ClaudeAnalysisResult.fallback();
    }
  }

  /// Resize to max 1280×960 and re-encode at 85% JPEG quality.
  Uint8List _compressImage(Uint8List bytes) {
    try {
      final decoded = img.decodeImage(bytes);
      if (decoded == null) return bytes;

      final resized = img.copyResize(
        decoded,
        width: decoded.width > 1280 ? 1280 : decoded.width,
        height: decoded.height > 960 ? 960 : decoded.height,
        maintainAspect: true,
      );

      return Uint8List.fromList(img.encodeJpg(resized, quality: 85));
    } catch (_) {
      return bytes; // If compression fails, send original
    }
  }
}
