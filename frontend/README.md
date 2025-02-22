# Hospitalzzz Mobile App

A Flutter-based mobile application for tracking nearby hospitals and user locations. This app is part of the Hospitalzzz project, providing the mobile frontend interface.

## Features

- User Authentication
  - Login with email and password
  - Register new account
  - View and edit profile information
  - Secure password handling
- Location Services
  - Real-time user location tracking
  - Display nearby hospitals (within 5km radius)
  - Interactive map view with hospital markers
  - Geocoding support for address display
- Map Features
  - Interactive Flutter Map implementation
  - Custom hospital markers
  - Distance calculation
  - Location history tracking

## Prerequisites

- Flutter SDK (3.24.3 or later)
- Dart SDK
- Android Studio / VS Code with Flutter plugins
- iOS development setup (for iOS deployment)
- Active internet connection

## Dependencies

Key packages used in this project:

```yaml
dependencies:
  flutter_map: ^4.0.0
  geolocator: ^13.0.2
  geocoding: ^3.0.0
  shared_preferences: ^2.3.5
  device_info_plus: ^9.1.2
  http: ^0.13.6
  carousel_slider: ^5.0.0
```

## Getting Started

1. Clone the repository
2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Configure environment:

   - Set up Google Places API key
   - Configure backend API endpoint

4. Run the application:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── models/         # Data models
├── screens/        # UI screens
├── services/       # API and location services
├── utils/          # Helper functions
└── widgets/        # Reusable widgets
```

## Platform Support

- Android
- iOS
- Web
- Linux
- macOS
- Windows

## Development Setup

1. Enable platform support:

   ```bash
   flutter config --enable-<platform>-desktop
   ```

2. Configure IDE:
   - Install Flutter and Dart plugins
   - Set up device/emulator
   - Configure code formatting

## Building for Production

Android:

```bash
flutter build apk --release
```

iOS:

```bash
flutter build ios --release
```

## Testing

Run tests using:

```bash
flutter test
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request
