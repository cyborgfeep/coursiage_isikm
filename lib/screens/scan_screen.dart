import 'package:camera/camera.dart';
import 'package:coursiage_isikm/main.dart';
import 'package:coursiage_isikm/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  late CameraController controller;
  late PageController pageController;
  bool isFlash = false;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
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
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              cameraWidget(),
              Stack(
                children: [
                  Container(
                    color: Colors.white,
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: CardWidget(
                        height: 250,
                        width: 400,
                        showText: false,
                      ),
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
                          icon: Icon(Icons.clear, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: ToggleSwitch(
                minWidth: 150.0,
                cornerRadius: 20.0,
                activeBgColors: [
                  [Colors.grey[500]!],
                  [Colors.white],
                ],
                activeFgColor: selectedIndex == 0 ? Colors.white : Colors.black,
                inactiveBgColor: selectedIndex == 0
                    ? Colors.black
                    : Colors.grey,
                inactiveFgColor: selectedIndex == 0
                    ? Colors.white
                    : Colors.black,
                initialLabelIndex: selectedIndex,
                totalSwitches: 2,
                labels: ['Scanner un code', 'Ma carte'],
                radiusStyle: true,
                onToggle: (index) {
                  setState(() {
                    selectedIndex = index!;
                  });
                  //pageController.jumpToPage(selectedIndex);
                  pageController.animateToPage(
                    selectedIndex,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cameraWidget() {
    return Stack(
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
          bottom: 220,
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
    );
  }
}
