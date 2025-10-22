# Secure Privacy Flutter SDK – Example App

## Overview

This repository demonstrates how to integrate the **Secure Privacy Consent Management SDK** into a **Flutter application**.  
It provides a working implementation of the SDK showcasing core features such as **consent collection**, **status retrieval**, and **event handling** across **Android** and **iOS** platforms.

For full SDK documentation, visit:  
[Secure Privacy Flutter SDK Documentation](https://docs.secureprivacy.ai/guides/mobile/flutter-sdk/01-setup-and-initialisation/)  
[Secure Privacy Website](https://secureprivacy.ai)

---

## Getting Started

### Obtain Your Application ID

To use the Secure Privacy SDK, you need an **Application ID**.  
Sign up for a **free trial** at [Secure Privacy](https://secureprivacy.ai) to get your **Application ID**.

---

### Installation

1. Add the Secure Privacy Flutter SDK dependency in your `pubspec.yaml`:

   ```yaml
   dependencies:
     secureprivacy_flutter_sdk: ^0.2.2-beta
   ```

2. Run the following command:

   ```sh
   flutter pub get
   ```

---

## Running the Example App

1. Clone this repository:

   ```sh
   git clone https://github.com/secureprivacy/flutter-sdk-example.git
   cd flutter-sdk-example
   ```

2. Open the project in your preferred IDE (VS Code or Android Studio).
3. Run the app on an emulator or physical device.

---

## Features

- Cross-platform consent collection (Android & iOS)
- Consent status retrieval and management
- Package-specific consent validation
- Event listening for consent updates
- Session and preference management

---

## Usage

### Initialize the SDK

Initialize the SDK inside your app’s main widget or startup logic:

```dart
import 'package:secureprivacy_flutter_sdk/secureprivacy_flutter_sdk.dart';

final spConsentEngine = await SPConsentEngine.initialise(
  applicationId: 'YOUR_APPLICATION_ID',
);
```

If you have a **secondary application ID**, you can include it as well:

```dart
final _spMobileConsent = SecurePrivacyMobileConsent();

final spConsentEngine = await _spMobileConsent.initialise(
  applicationId: 'YOUR_APPLICATION_ID',
  secondaryApplicationId: 'YOUR_SECONDARY_APPLICATION_ID', // Optional
);
```

---

### Display the Consent Banner

To show the **primary consent banner**:

```dart
await _spMobileConsent.showConsentBanner('YOUR_APPLICATION_ID');
```

To show the **secondary consent banner** (if applicable):

```dart
await _spMobileConsent.showSecondaryBanner('YOUR_APPLICATION_ID');
```

---

### Retrieve Consent Status

```dart
await _spMobileConsent.getConsentStatus('YOUR_APPLICATION_ID');
```

Possible states:
- **Collected** – Consent has been obtained.
- **Pending** – Consent is required.
- **UpdateRequired** – Consent needs to be refreshed.

---

### Check Package Consent

```dart
final result = await _spMobileConsent.getPackage('YOUR_APPLICATION_ID', packageId);
if (result.data?.isEnabled == true) {
  // Enable feature
}
```

---

### Listen to Consent Events

You can register a listener to handle consent changes:

```dart
_spMobileConsent.addListener(kEventCode);
```

Or remove the listener when no longer needed:

```dart
_spMobileConsent.removeListener(kEventCode);
```

Subscribe to event stream:
```dart
_spMobileConsent.consentEventStream.listen((event) {
  //Custom Logic
});
```

---

### Clear the Consent Session

To clear all local consent data (e.g., on logout):

```dart
await _spMobileConsent.clearSession();
```

---

### Get Unique Client ID

Retrieve a unique client ID for tracking consent:

```dart
final result = await _spMobileConsent.getClientId('YOUR_APPLICATION_ID');
if (result.code == 200 && result.data !=null ){
  final clientId = result.data;
} else {
  print(result.msg);
}
```

---

### Get Country Code

Retrieve the detected country code:

```dart
final result = await _spMobileConsent.getLocale('YOUR_APPLICATION_ID');
if (result.code == 200 && result.data !=null){
  final countryCode = result.data;
} else {
  print(result.msg);
}
```

Returns values like `US-CA` or `IN` based on the user’s locale.

---
## Customization

You can open the **Preference Center** directly to allow users to manage their consent preferences:

```dart
await _spMobileConsent.showPreferenceCenter('YOUR_APPLICATION_ID');
```

---

## Support

For detailed documentation and troubleshooting, visit:  
[Secure Privacy Flutter SDK Documentation](https://docs.secureprivacy.ai/guides/mobile/flutter-sdk/01-setup-and-initialisation/)

If you encounter any issues, contact us via our website:  
[Secure Privacy](https://secureprivacy.ai)

---

## License

This project is licensed under the **MIT License**.