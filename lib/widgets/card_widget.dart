import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class CardWidget extends StatefulWidget {
  final double? height;
  final double? width;
  final bool? showText;
  final VoidCallback? onPressed;

  const CardWidget({
    super.key,
    this.height,
    this.width,
    this.showText = true,
    this.onPressed,
  });

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Center(
        child: Container(
          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
          height: widget.height ?? 220,
          width: widget.width ?? MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: AssetImage("assets/images/motif.png"),
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: .2),
                BlendMode.srcIn,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Image.asset("assets/images/wave_logo.png", width: 50),
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: 175,
                  width: 170,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 150,
                        padding: EdgeInsets.all(8),
                        child: PrettyQrView.data(data: 'google.com'),
                      ),
                      widget.showText!
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt_rounded, size: 16),
                                SizedBox(width: 5),
                                Text(
                                  "Scanner",
                                  style: GoogleFonts.dmSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
