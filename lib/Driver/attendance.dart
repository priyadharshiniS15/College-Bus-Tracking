
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import 'attendancestore.dart';



class AllocatedDetails extends StatefulWidget {
  final String? dname;
  final String? did;
  final String? mobile;
  final String? ukey;

  const AllocatedDetails({
    Key? key,
    this.dname,
    this.did,
    this.mobile,
    this.ukey,
  }) : super(key: key);

  @override
  State<AllocatedDetails> createState() => _DashboardState();
}
class _DashboardState extends State<AllocatedDetails> {
  var isLogoutLoading = false;
  String _scanBarcode = '';

  // QR Code Scanner
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController? controller;
  late String qrText = '';

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => debugPrint(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      debugPrint(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.DEFAULT);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }



  @override
  void initState() {
    super.initState();
    initFunction();
  }

  Future<void> initFunction() async {
    await requestCameraPermission();
    initController();
  }

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Permission Required'),
            content: Text(
                'Please enable camera permission to use QR code scanner.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void initController() {
    controller = null;
  }

  void startScan() {
    void startScan() {
      if (controller != null) {
        controller!.toggleFlash(); // Turn off torch
        controller!.resumeCamera();
      }
    }
  }

  void navigateToPaymentWidget() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttendanceHistory(


            ukey: widget.ukey,
            dname:widget.dname,
            did:widget.did,
            mobile:widget.mobile,
            scannedData: _scanBarcode





        ),
      ),
    );
  }

  Widget buildOverlay() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 250.0,
            width: 250.0,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 2.0,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            'Align QR code within the frame',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 16.0),
          Text(
            'Scanned Data: $qrText',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        Container(
          decoration: BoxDecoration(
            color: Colors.black45, // Set the transparent background color
          ),




          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    // Adjust the border radius as needed
                    color: Colors.blue, // Change this to your desired splash color
                  ),
                  child: InkWell(
                    onTap: () {
                      scanQR().then((_) {
                        if (_scanBarcode.isNotEmpty) {
                          navigateToPaymentWidget();
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Scan',
                        style: TextStyle(
                            color: Colors.white), // Adjust text color as needed
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}