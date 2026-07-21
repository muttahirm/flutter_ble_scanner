import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_ble_scanner/controllers/bluetooth_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const BlueScannerPage(title: 'Bluetooth LE Device Scanner'),
    );
  }
}

class BlueScannerPage extends StatefulWidget {
  const BlueScannerPage({super.key, required this.title});
  final String title;

  @override
  State<BlueScannerPage> createState() => _BlueScannerPageState();
}

class _BlueScannerPageState extends State<BlueScannerPage> {
  final BlueController controller = Get.put(BlueController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Obx(() {
              if (controller.devicesList.isEmpty) {
                return const Center(
                  child: Text('No devices discovered. Start scanning!'),
                );
              }
              return ListView.builder(
                itemCount: controller.devicesList.length,
                itemBuilder: (context, index) {
                  final deviceArgs = controller.devicesList[index];

                  // FIXED: Get the name solely from the advertisement payload object
                  final advertisedName = deviceArgs.advertisement.name;
                  final displayName =
                      (advertisedName != null && advertisedName.isNotEmpty)
                      ? advertisedName
                      : 'Raw Beacon Address'; // Fallback text so you know a signal was caught

                  return ListTile(
                    leading: const Icon(Icons.bluetooth, color: Colors.blue),
                    title: Text(displayName),
                    subtitle: Text(
                      deviceArgs.peripheral.uuid.toString(),
                    ), // Displays raw MAC/UUID address
                    trailing: Text('${deviceArgs.rssi} dBm'),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(
              () => ElevatedButton(
                onPressed: controller.isScanning.value
                    ? controller.stopScan
                    : controller.startScan,
                child: Text(
                  controller.isScanning.value ? 'Stop Scanning' : 'Start Scan',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
