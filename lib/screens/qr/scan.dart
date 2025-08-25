import 'dart:io';
import 'package:flutter/material.dart';
import 'package:palm_ecommerce_mobile_app_2/providers/auth/auth_provider.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/qr/scan_success.dart';
import 'package:palm_ecommerce_mobile_app_2/screens/auth_screen/signup_signin/sign_in/sign_in_screen.dart';
import 'package:palm_ecommerce_mobile_app_2/utils/data.dart';
import 'package:palm_ecommerce_mobile_app_2/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class ScanQRCode extends StatefulWidget {
  final int typeId;

  const ScanQRCode({super.key, required this.typeId});
  @override
  ScanQRCodeState createState() => ScanQRCodeState();
}

class ScanQRCodeState extends State<ScanQRCode> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool _isPermissionGranted = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: PalmColors.primary,
              borderRadius: PalmSpacings.radius,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 275,
            ),
            onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
          ),
          // Custom frame overlay
          Center(
            child: SizedBox(
              width: 275,
              height: 275,
              child: CustomPaint(
                painter: FramePainter(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: PalmSpacings.m + 4, left: PalmSpacings.s - 2),
              child: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, color: PalmColors.white, size: PalmIcons.size)
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: PalmSpacings.xl + 3),
              child: Text(
                'Scan QR Code',
                textAlign: TextAlign.center,
                style: PalmTextStyles.title.copyWith(
                  color: PalmColors.white, 
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          // Instruction Text
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: PalmSpacings.xl + 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    result != null
                        ? 'Align QR Code within\nframe to scan'
                        : 'Align QR Code within\nframe to scan',
                    textAlign: TextAlign.center,
                    style: PalmTextStyles.body.copyWith(color: PalmColors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    setState(() {
      _isPermissionGranted = p;
    });
    
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Camera permission is required to scan QR codes',
            style: PalmTextStyles.label,
          ),
          backgroundColor: PalmColors.danger,
        ),
      );
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    this.controller = controller;
    
    // For iOS, we need to resume camera after creation
    if (Platform.isIOS) {
      this.controller?.resumeCamera();
    }
    
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });

      if (result != null) {
        controller.pauseCamera();

        // Check token from storage
        token = await authProvider.getToken();
        bool hasToken = token != 'null';

        if (!hasToken) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Message', style: PalmTextStyles.title),
              content: Text('You have not logged in yet!', style: PalmTextStyles.body),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(PalmSpacings.radius),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel', style: PalmTextStyles.button.copyWith(color: PalmColors.neutralLight)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    controller.resumeCamera();
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PalmColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(PalmSpacings.radius / 2),
                    ),
                  ),
                  child: Text('Login', style: PalmTextStyles.button.copyWith(color: PalmColors.white)),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const SignInScreen()));
                  },
                ),
              ],
            ),
          );
        } else if (result!.code == "PALM_Technology-Attendance-Code-001") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => ScanSuccess(typeId: widget.typeId),
            )
          );
        } else {
          _showResultDialog(result!.code);
        }
      }
    });
  }

  void _showResultDialog(String? code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Scan Failed', style: PalmTextStyles.title.copyWith(color: PalmColors.danger)),
        content: Text('QR Code is not valid.', style: PalmTextStyles.body),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PalmSpacings.radius),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: PalmColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(PalmSpacings.radius / 2),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              controller?.resumeCamera(); // Resume scanning
            },
            child: Text('Scan Again', style: PalmTextStyles.button.copyWith(color: PalmColors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

// Custom Painter for the scanner frame's corner design
class FramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = PalmColors.primary
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    // Draw corners
    const cornerSize = 20.0;
    // Top-left
    canvas.drawLine(const Offset(0, 0), const Offset(cornerSize, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(0, cornerSize), paint);
    // Top-right
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - cornerSize, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerSize), paint);
    // Bottom-left
    canvas.drawLine(Offset(0, size.height), Offset(cornerSize, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - cornerSize), paint);
    // Bottom-right
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - cornerSize, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - cornerSize), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
