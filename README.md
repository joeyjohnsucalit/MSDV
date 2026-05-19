# msdv_system

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Manual Web Deploy
This project is configured to deploy prebuilt Flutter web output from `build/web`.
Before pushing changes, run:

    flutter build web

Then commit the generated `build/web` folder so Vercel can serve the static build.
If you change Dart code or assets, rebuild before pushing again.
