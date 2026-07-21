import 'dart:async';
import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BlueController extends GetxController {
  var isScanning = false.obs;

  // Instance allocation matching modern bluetooth_low_energy singleton guidelines
  final CentralManager _centralManager = CentralManager();

  // Dynamic reactive list capturing incoming hardware payload streams
  var devicesList = <DiscoveredEventArgs>[].obs;
  StreamSubscription? _discoverySubscription;

  @override
  void onInit() {
    print("onInit called");
    super.onInit();
    _initializeBluetoothEngine();
  }

  /// Explicitly sequences initialization to guarantee event channels align safely
  Future<void> _initializeBluetoothEngine() async {
    print("Initializing Bluetooth Low Energy sub-engine...");
    try {
      // Modern v6.x setup sequence targeting cross-platform engines
      // await CentralManager.setUp();

      // Listen to live radio events safely after native layers activate
      _discoverySubscription = _centralManager.discovered.listen((eventArgs) {
        final String currentUuid = eventArgs.peripheral.uuid.toString();

        // Block duplicates using unique peripheral hardware UUID keys
        bool matchExists = devicesList.any(
          (item) => item.peripheral.uuid.toString() == currentUuid,
        );
        if (!matchExists) {
          devicesList.add(eventArgs);
        }
      });
    } catch (e) {
      print("Failed to start Bluetooth Low Energy sub-engine: $e");
    }
  }

  Future<void> startScan() async {
    // 1. Evaluate runtime authorization requirements for Android 12, 13, and 14
    var scanStatus = await Permission.bluetoothScan.status;
    var connectStatus = await Permission.bluetoothConnect.status;

    if (!scanStatus.isGranted || !connectStatus.isGranted) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
      ].request();

      scanStatus =
          statuses[Permission.bluetoothScan] ?? PermissionStatus.denied;
      connectStatus =
          statuses[Permission.bluetoothConnect] ?? PermissionStatus.denied;
    }

    // 2. Request location fallbacks required by individual OEM chipsets
    var locationStatus = await Permission.location.status;
    if (!locationStatus.isGranted) {
      await Permission.location.request();
    }

    // 3. Trigger Discovery Routine if authorized
    if (scanStatus.isGranted && connectStatus.isGranted) {
      devicesList.clear();
      isScanning.value = true;

      await _centralManager.startDiscovery();

      // Auto-terminate scanning routine after 15 seconds to manage hardware resource consumption
      Future.delayed(const Duration(seconds: 15), () {
        if (isScanning.value) stopScan();
      });
    } else {
      print("Scan requested but blocked due to missing permissions.");
    }
  }

  Future<void> stopScan() async {
    await _centralManager.stopDiscovery();
    isScanning.value = false;
  }

  @override
  void onClose() {
    // Clean up streams to block async memory allocation leaks
    _discoverySubscription?.cancel();
    super.onClose();
  }
}
