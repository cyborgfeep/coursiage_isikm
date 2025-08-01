import 'package:camera/camera.dart';
import 'package:coursiage_isikm/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key});

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late CameraController controller;
  bool isFlash = false;
  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller
        .initialize()
        .then((_) {
          if (!mounted) {
            return;
          }
          setState(() {});
        })
        .catchError((Object e) {
          if (e is CameraException) {
            switch (e.code) {
              case 'CameraAccessDenied':
                // Handle access errors here.
                break;
              default:
                // Handle other errors here.
                break;
            }
          }
        });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: MediaQuery.of(context).size.aspectRatio,
              child: CameraPreview(controller),
            ),
          ),
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: .6),
              BlendMode.srcOut,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                  ), // This one will handle background + difference out
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: const EdgeInsets.only(left: 30, right: 30, top: 0),
                    height: 300,
                    width: 400,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 200,
            left: 30,
            right: 30,
            child: Row(
              children: [
                Text(
                  "Scannez un Code Qr pour payer ou envoyer",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(color: Colors.white),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 30, left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.clear, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isFlash = !isFlash;
                      controller.setFlashMode(
                        isFlash ? FlashMode.torch : FlashMode.off,
                      );
                    });
                  },
                  icon: Icon(
                    isFlash ? Icons.flashlight_on : Icons.flashlight_off,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
