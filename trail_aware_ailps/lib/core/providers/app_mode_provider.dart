import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Toggles between the hiker-facing user view and the authority management view.
enum AppMode { user, authority }

final appModeProvider = StateProvider<AppMode>((ref) => AppMode.user);
