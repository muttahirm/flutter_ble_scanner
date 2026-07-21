# Flutter BLE Scanner

A Flutter application for scanning nearby Bluetooth Low Energy (BLE) devices. The app uses the Bluetooth Low Energy package and permission handling to discover devices and display them in a simple list.

## Features

- Scan for nearby BLE devices
- Display discovered devices in a list
- Start and stop scanning manually
- Request the required Bluetooth and location permissions

## Important Note

This app is designed to run on physical devices only. BLE scanning and device discovery do not work reliably on Android emulators or iOS simulators, so you should test it on a real phone or tablet.

## Requirements

- Flutter SDK installed and configured
- A physical Android or iOS device
- Bluetooth enabled on the device
- Developer mode and USB debugging enabled on Android (if using Android)

## Setup

1. Clone the repository:

   ```bash
   git clone <repository-url>
   cd flutter_ble_scanner
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Connect a physical device to your computer.

4. Run the app:

   ```bash
   flutter run
   ```

## Platform Notes

### Android

- Make sure Bluetooth is enabled on the device.
- Grant all requested permissions when prompted.
- If the app does not discover devices, ensure the device is not in airplane mode and that nearby BLE peripherals are advertising.

### iOS

- BLE scanning requires a physical iPhone or iPad.
- Grant Bluetooth and location permissions when prompted.
- Some BLE features may require the app to be run while the device is unlocked.

## Troubleshooting

- If no devices appear, confirm that the BLE device is advertising and within range.
- If permissions are denied, the app will not scan properly. Reinstall the app or re-enable permissions from the device settings.
- If the app does not build, run:

- ```bash
  flutter clean
  flutter pub get
  ```

## Build for Release

To build a release APK for Android:

```bash
flutter build apk --release
```

To build an iOS archive (requires Xcode and signing setup):

```bash
flutter build ios --release
```
