# TrailAware AIlps — Initial Prompt

## App Brief

Build a Flutter app targeting iOS and Android as primary platforms. It must run on a real iPhone — focus on the iOS version. The project is called **TrailAware AIlps** and is being developed in the context of a hackathon.

Develop the app in English. Aim for outstanding UI and UX — I trust your expertise to get the best possible result. Follow the latest design standards: polished animations, gradients, and a refined visual theme. Adhere to Apple's Human Interface Guidelines for design language. Avoid visual overload — keep the interface clean, focused, and self-explanatory. Take the time to do it right, apply coding best practices, and include helpful code comments.

---

## Hackathon Challenge

**EUSALP Alpine AI-Hackathon 2026**

### Challenge: Destination Resilience

> How might we strengthen the resilience of Alpine destinations in the face of changing tourism, environmental, and economic conditions?

Alpine destinations face growing challenges linked to climate change, changing visitor behaviour, seasonality, natural hazards, and economic uncertainty. Building resilience is essential to ensure destinations remain attractive, sustainable, and prosperous over the long term.

Participants are invited to explore how innovation and AI could help destinations anticipate risks, adapt to change, and create new opportunities.

**Example Questions**

- How can destinations adapt to shorter winter seasons?
- How can tourism businesses become more resilient to climate change?
- How can destinations prepare for extreme weather events?
- How can tourism be diversified throughout the year?

**Suggested Resources**

- BeyondSnow project
- Climate adaptation initiatives
- Natural hazard monitoring systems
- Destination resilience case studies

---

## The App / Solution

**TrailAware AIlps** enables users to report hazards on hiking trails. Examples include rockfalls, landslides, fallen trees, and much more — with a particular focus on hazards that will increase in frequency due to extreme weather events.

Think of the reporting flow as similar to roadwork reports in Google Maps. Reporting is camera-based: an AI analyses the live camera feed and automatically generates a hazard description (classification) and a priority rating indicating how urgently it should be addressed (high / medium / low).

The report is geo-routed — based on the user's location at the time of reporting — to the responsible authority or organisation (e.g. the relevant national park, alpine club, or whoever is responsible for trail maintenance in that area). The authority receives a well-structured overview (e.g. a dashboard) and an email notification whenever a new report is submitted within their area of responsibility. Each report is informative: it describes the problem and proposes a solution.

In addition, data about affected or closed trails is made available to hiking apps via an open API, so that apps like Komoot can factor closures into their routing and redirect users accordingly. Navigation itself is out of scope for the TrailAware AIlps app — the focus is on publishing the data for others to consume.

After submitting a report, thank the user in a way that feels genuinely rewarding — make them feel good about having contributed to the safety of the Alpine community and saved time for other hikers and mountain bikers through smarter trail routing.
