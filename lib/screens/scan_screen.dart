import 'package:camera/camera.dart';
import 'package:coursiage_isikm/main.dart';
import 'package:coursiage_isikm/widgets/camera_widget.dart';
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
  late PageController pageController;

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
  }

  @override
  void dispose() {
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
              CameraWidget(),
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
}
