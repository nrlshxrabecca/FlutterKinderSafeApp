import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController controller = MobileScannerController();
  bool isProcessing = false; // Prevent multiple scans

  @override
  void dispose() {
    controller.dispose(); // Stop the camera when exiting
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan QR Code')),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: MobileScanner(
              controller: controller,
              onDetect: (barcodeCapture) {
                final barcode = barcodeCapture.barcodes.first;
                if (!isProcessing && barcode.rawValue != null) {
                  isProcessing = true; // Prevent multiple detections
                  String scannedData = barcode.rawValue!;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Scanned: $scannedData")),
                  );

                  // Delay and close scanner to avoid multiple triggers
                  Future.delayed(Duration(milliseconds: 500), () {
                    Navigator.pop(context, scannedData);
                  });
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                "Scan a QR code",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
