# UNO Chat App

This is a cross-platform chat application built using Flutter and Firebase as a part of a workshop hosted by [UNO ACM](https://unoacm.org/) in Fall 2024.

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Running the Application](#running-the-application)
- [Building the Application](#building-the-application)

## Features

- Real-time chat functionality using Firebase Firestore.
- Cross-platform support for Android, iOS, macOS, Windows, Linux, and Web.
- Firebase authentication and storage integration.

## Getting Started

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Firebase account: [Create a Firebase project](https://firebase.google.com/)
- Dart SDK (included with Flutter)

### Installation

1. Clone the repository:

```sh
git clone https://github.com/uno-acm/flutter-workshop.git
cd flutter-workshop
```

2. Install dependencies:

```sh
flutter pub get
```

3. Set up Firebase for each platform by following the instructions in the Configuration section.

## Configuration

1. Generate Firebase configuration files using the FlutterFire CLI:

```sh
flutterfire configure
```

2. Update the `firebase_options.dart` file with the generated Firebase options for each platform.

## Running the Application

To run the application on a specific platform, use the following commands:

- Android:

```sh
flutter run -d android
```

- iOS:

```sh
flutter run -d ios
```

- macOS:

```sh
flutter run -d macos
```

- Windows:

```sh
flutter run -d windows
```

- Linux:

```sh
flutter run -d linux
```

- Web:

```sh
flutter run -d web
```

## Building the Application

To build the application for a specific platform, use the following commands:

- Android:

```sh
flutter build apk
```

- iOS:

```sh
flutter build ios
```

- macOS:

```sh
flutter build macos
```

- Windows:

```sh
flutter build windows
```

- Linux:

```sh
flutter build linux
```

- Web:

```sh
flutter build web
```