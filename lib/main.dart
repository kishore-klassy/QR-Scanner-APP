import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Scanner',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'QR SCANNER'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _showScanSuccessfulMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Scan Successful'),
        duration: Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_scanner_outlined,size: 150,),
            Container(height: 20,),
            Text(
              'Points Earned',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              _counter.toString(),
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                bool? result = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ScanPage()),
                );

                if (result ?? false) {
                  _incrementCounter();
                  _showScanSuccessfulMessage();
                }
              },
              child: Text(
                'Scan QR Code',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 34, vertical: 15),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  late MobileScannerController controller;

  bool detected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan QR code"),
      ),
      body: Center(
        child: Container(
          height: 300,
          width: 300,
          child: MobileScanner(
            controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.noDuplicates,
              returnImage: true,
              detectionTimeoutMs: 500,
              
            ),
            onDetect: (capture) async {
              if (!detected) {
                final Uint8List? image = capture.image;
                final res = capture.raw;
                debugPrint("$res");
                for (final barcode in capture.barcodes) {
                  debugPrint('Barcode found! ${barcode.rawValue}');
                }
                detected = true;
                if (image != null) {
                  showDialog(
                    context: context,
                   
                    builder: (context) => Container(
                       
                      margin: EdgeInsets.all(5),
                      color: Colors.white,
                      padding: EdgeInsets.all(24),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Image(
                          image: MemoryImage(image),
                          fit: BoxFit.fitHeight,
                          height: 200,
                          width: 200,
                        ),
                      ),
                      
                    ),
                  );
                  await Future.delayed(Duration(milliseconds: 2000));

                  Navigator.pop(context);
                }
                if (mounted) Navigator.pop(context, true);

                print("POPPEDDD ----");
              }
            },
          ),
        ),
      ),
    );
  }
}
