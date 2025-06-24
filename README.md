# Flutter Flavorizer Skeleton

![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-blue)
![Dart](https://img.shields.io/badge/Dart-2.17%2B-blue)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A production-ready Flutter boilerplate with multi-environment flavor support.

---

## 🚀 Features

- ✅ **Multi-flavor architecture** (dev/staging/prod)  
- 🔐 **Environment variables** management  
- 📱 **Platform-specific** configurations  
- 🧩 **Modular structure** for scalability  
- ⚡ **Optimized build system**  

---

## 📦 Installation

### Prerequisites

- Flutter SDK 3.0+
- Dart 2.17+
- Android Studio or Xcode
- Git

### Quick Start

```bash
# 1. Clone repository
git clone https://github.com/sonuprasad010/flutter-flavorizer-skeleton.git
cd flutter-flavorizer-skeleton

# 2. Install dependencies
flutter pub get

# 3. Set up environment files
cp .env.example .env
cp .env.example env.staging

# 4. Run Different flavor
flutter run --flavor staging -t lib/flavours/main_staging.dart
flutter run --flavor production -t lib/flavours/main_production.dart
```

---

## ⚙️ Android Flavor Configuration

Add this to your `android` block in `android/app/build.gradle`:

```gradle
flavorDimensions += "environment"

productFlavors {
    create("dev") {
        dimension = "environment"
        applicationIdSuffix ".dev"
        resValue("string", "app_name", "App Dev")
    }
    create("staging") {
        dimension = "environment"
        applicationIdSuffix ".staging"
        resValue("string", "app_name", "App Staging")
    }
    create("production") {
        dimension = "environment"
        resValue("string", "app_name", "App")
        manifestPlaceholders = [
            appIcon: "@mipmap/ic_launcher",
            appIconRound: "@mipmap/ic_launcher_round"
        ]
    }
}
```

---

## 📝 AndroidManifest.xml Configuration

### Flavor-Specific App Name Setup

Ensure your `android/app/src/main/AndroidManifest.xml` contains:

```xml
<application
    android:label="@string/app_name"
    ...>
    ...
</application>
```

---

## 🧱 Flavor Configuration System

### Core Architecture

#### `main_common.dart` - Shared Entry Point

```dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_flavorizer_skeleton/flavours/config/flavour_config.dart';
import '../main.dart';

void mainCommon({
  required FlutterFavour flavour,
}) {
  // Initialize flavor configuration
  FlavourConfig(
    flavour: flavour,
    environment: dotenv.env['ENVIRONMENT']!,
    baseUrl: dotenv.env['BASE_URL']!,
    assetUrl: dotenv.env['ASSET_URL']!,
  );
  
  // Start the app
  runApp(MyApp());
}
```

---

## 🧪 Flavor Entrypoints

### `lib/flavours/main_production.dart`

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_flavorizer_skeleton/flavours/config/flavour_config.dart';
import 'package:flutter_flavorizer_skeleton/flavours/main_common.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  mainCommon(
    flavour: FlutterFavour.production,
  );
}
```

### `lib/flavours/main_staging.dart`

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_flavorizer_skeleton/flavours/config/flavour_config.dart';
import 'package:flutter_flavorizer_skeleton/flavours/main_common.dart';

void main() async {
  await dotenv.load(fileName: ".env.staging");
  mainCommon(flavour: FlutterFavour.staging);
}
```
