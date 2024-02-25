import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

import 'dart:math';

import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:smartlamp1/pickers/utilities.dart';

class lampscreen extends StatefulWidget {
  const lampscreen({super.key});

  @override
  State<lampscreen> createState() => _lampscreenState();
}

class _lampscreenState extends State<lampscreen> {

  Color initialColor =const HSVColor.fromAHSV(1.0, 0.0,1.0, 1.0).toColor();
  List<Color> currentColors = [Colors.yellow, Colors.green];
  List<Color> colorHistory = [];
  double value = 50.0;
  bool ispressed=false;
  bool isPowerOn = false;
  bool isAutoOn=true;
  int intensityval=2;




  void turnDeviceOn() async {
    setColor(initialColor, context);
  }

  void turnDeviceOff() async {
    String data = "1,2,3";  // Replace with your data format

    try {
      final response = await http.post(
        Uri.http('192.168.242.252', '/colour'),
        headers: {
          'Content-Type': 'text/plain',  // Set content type to plain text
        },
        body: data,  // Send your data in the desired format
      );
      if (response.statusCode == 200) {
        print("Turned Off");
      } else if (response.statusCode == 400) {
        print("Device Error: ${response.reasonPhrase}");
      }
    } on SocketException catch (e) {
      print("Connection Error: $e");
    } catch (e) {
      print("Error: $e");
    }
  }


  Future<void> toggleAuto(bool isAutoOn) async {
    final action = isAutoOn ? "on" : "off";

    try {
      /*final response = await http.post(
        Uri.http('', '/auto'),
        body: {"action": action},
      );*/

      if (true/*response.statusCode == 200*/) {
        print("Turned $action");
      } else {
        //print("Device Error: ${response.reasonPhrase}");
      }
    } on http.ClientException catch (e) {
      print("HTTP Error: $e");
    } on Exception catch (e) {
      print("Error: $e");
    }
  }

  Future<void> adjustIntensity() async {
    try {
      /*final response = await http.post(
        Uri.http('', '/intensity'),
        body: {"$intensityval"},
      );*/

      if (true/*response.statusCode == 200*/) {
        print("Intensity updated to $intensityval %");
      } else {
        //print("Device Error: ${response.reasonPhrase}");
      }
    } on http.ClientException catch (e) {
      print("HTTP Error: $e");
    } on Exception catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.black87,
             child: Padding(
               padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 30),
               child: Column(
                 children: [
                   const SizedBox(
                     height: 70,
                   ),
                   Row(
                     children: [
                       RotatedBox(
                         quarterTurns: 0,
                         child: IgnorePointer(
                           ignoring: ispressed? false:true,
                           child: Container(
                             foregroundDecoration: BoxDecoration(
                               color: ispressed ?  null:Colors.grey ,
                               backgroundBlendMode: ispressed ?  null:BlendMode.saturation ,
                             ),


                             child: Row(
                               children: [
                                 const Text(
                                   'Auto',
                                   style: TextStyle(
                                     color: Colors.orangeAccent,
                                     fontSize: 24,
                                     fontFamily: 'avenir'
                                   ),
                                 ),
                                 Switch(
                                   value: isAutoOn,
                                   onChanged: (bool newValue) async {
                                     setState(() {
                                       isAutoOn = newValue;
                                     });

                                     // Call the toggleAuto function and await it
                                     await toggleAuto(isAutoOn);
                                   },

                                 ),
                               ],
                             ),

                           ),
                         ),
                       ),
                     ],
                   ),
                   const SizedBox(
                     height: 20,
                     width: 30,
                   ),
                   Row(
                     children: [
                       const SizedBox(
                         width: 10,
                       ),
                       Stack(

                         children: [
                            IgnorePointer(
                              ignoring: ispressed? false:true,
                              child:const SizedBox(
                               width: 300, // Set a fixed width
                               height: 300, // Set a fixed height
                               child:CustomHueRingPicker()
                           ),
                            ),
                           Padding(
                             padding: const EdgeInsets.all(50.0),
                             child: Container(
                               width: 200,
                               height: 200,
                               decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 gradient: LinearGradient(
                                   colors: [
                                     const Color(0xFFD3D3D3), // Light gray for metallic effect
                                     Colors.grey[500]!, // Medium gray for metallic effect
                                     Colors.grey[700]!, // Dark gray for metallic effect
                                   ],
                                   stops:const [0.0, 0.30, 0.75],
                                   begin: Alignment.topLeft,
                                   end: Alignment.bottomRight,
                                 ),
                                 boxShadow: [
                                   BoxShadow(
                                     color: ispressed? Colors.redAccent:Colors.white, // Adjust shadow color and opacity
                                     spreadRadius: 2,
                                     blurRadius: 5,
                                     offset:const Offset(0, 0),
                                   ),
                                 ],
                               ),
                               child: Ink(
                                 decoration: const BoxDecoration(
                                   shape: BoxShape.circle,
                                   color: Colors.transparent, // Set background color to transparent
                                 ),
                                 child: InkWell(
                                   onTap: () {
                                     setState(() {
                                       if (ispressed) {
                                          turnDeviceOff();
                                         setState(() {
                                           ispressed = false;
                                         });
                                       } else {
                                         turnDeviceOn();
                                         setState(() {
                                           ispressed = true;
                                         });
                                       }
                                       final lampAppProvider = context.read<LampAppProvider>();
                                       lampAppProvider.togglePower();
                                     });
                                   },
                                   child: Icon(

                                     Icons.power_settings_new,
                                     size: 100,
                                     color: ispressed? Colors.redAccent:Colors.white,
                                     shadows: [Shadow(
                                       color: ispressed? Colors.redAccent:Colors.white,
                                       blurRadius: 20,
                                       offset:const Offset(0,0),

                                     )],// Icon color
                                   ),
                                 ),
                               ),
                             ),
                           ),
                         ],
        ),
                     ],
                   ),
                      const  SizedBox(
                          height: 60,
                        ),
               IgnorePointer(
                 ignoring: ispressed? false:true,
                 child: Container(
                   width: 400,
                  
                   decoration:const BoxDecoration(
                     borderRadius: BorderRadius.all(Radius.circular(20)),
                   ),
                   child: Row(
                     children: [
                       Container(
                         foregroundDecoration: BoxDecoration(
                           color: ispressed ?  null:Colors.grey ,
                           backgroundBlendMode: ispressed ?  null:BlendMode.saturation ,
                         ),
                         child:const Icon(
                           Icons.lightbulb_outline,
                           color: Colors.white,
                           size: 33,
                           shadows: [
                             Shadow(
                                 color: Colors.white,
                                 blurRadius: 20
                             )
                           ],
                         ),
                       ),
                       Container(
                         foregroundDecoration: BoxDecoration(
                           color: ispressed ?  null:Colors.grey ,
                           backgroundBlendMode: ispressed ?  null:BlendMode.saturation ,
                         ),
                         width: 254,
                         child: SliderTheme(
                           data:  SliderThemeData(
                             trackHeight: 26,
                             tickMarkShape:const RoundSliderTickMarkShape(
                             ),
                             thumbColor: Colors.orangeAccent,
                             disabledActiveTickMarkColor: Colors.transparent,
                             activeTickMarkColor: Colors.transparent,
                             inactiveTickMarkColor: Colors.orangeAccent.withOpacity(0.2),
                              activeTrackColor: Colors.white,
                             inactiveTrackColor: Colors.white.withOpacity(0.2),
                             // Adjust track height
                             thumbShape:const RoundSliderThumbShape(
                               enabledThumbRadius: 20, // Adjust thumb size
                             ),
                             overlayColor: Colors.transparent, // Remove overlay
                           ),
                           child: RotatedBox(
                             quarterTurns: 0,
                             child: Slider(
                               value: value,
                               min: 0,
                               max: 100,
                               divisions: 4,
                               onChanged: (newValue) {
                                   setState(() {
                                     value = newValue;
                                     intensityval = value ~/ 25.0;
                                     adjustIntensity();
                                     print(value);
                                 });
                               },
                             ),
                           ),
                         ),
                       ),
                       Container(
                           foregroundDecoration: BoxDecoration(
                             color: ispressed ?  null:Colors.grey ,
                             backgroundBlendMode: ispressed ?  null:BlendMode.saturation ,
                           ),
                           height:45,
                           width: 45,
                           child: Image.asset('assets/images/lightbulb_on.png')),
                     ],
                   ),
                 ),
               ),
                 ],
               ),
             ),

        ),
      ),
    );
  }
}
class LampAppProvider extends ChangeNotifier {
  final _lampscreenState _appState = _lampscreenState();

  _lampscreenState get appState => _appState;

  void togglePower() {
    _appState.isPowerOn = !_appState.isPowerOn;
    notifyListeners();
  }
}

class MyRectClipper extends CustomClipper<Rect>{
  @override
  Rect getClip(Size size) =>const Rect.fromLTRB(0, 0, 0, 0);

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return false;
  }
  
}

class CustomHueRingPicker extends StatefulWidget {
  const CustomHueRingPicker({super.key});


  @override
  State<StatefulWidget> createState() =>_CustomHueRingPicker();

}

class _CustomHueRingPicker extends State<CustomHueRingPicker> {
  bool ispressed=false;
  double selectedHue = 0.0;

  Color hueToColor(double hue) {
    return HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
            alignment: Alignment.center,
            children:[
              GestureDetector(
                onPanUpdate: (details) {
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  final localPosition = renderBox.globalToLocal(details.globalPosition);
                  final centerX = renderBox.size.width / 2;
                  final centerY = renderBox.size.height / 2;
                  final angle = atan2(
                      localPosition.dy - centerY, localPosition.dx - centerX);
                  final degrees = (angle * 180 / pi) % 360;

                  setState(() {
                    selectedHue = degrees;
                    if (selectedHue < 0) selectedHue += 360;
                    setColor(hueToColor(selectedHue), context);
                  });

                },
                onTapUp: (details) {
                  RenderBox renderBox = context.findRenderObject() as RenderBox;
                  final localPosition = renderBox.globalToLocal(details.globalPosition);
                  final centerX = renderBox.size.width / 2;
                  final centerY = renderBox.size.height / 2;
                  final angle = atan2(
                      localPosition.dy - centerY, localPosition.dx - centerX);
                  final degrees = (angle * 180 / pi) % 360;

                  setState(() {
                    selectedHue = degrees;
                    if (selectedHue < 0) selectedHue += 360;
                    setColor(hueToColor(selectedHue), context);
                  });
                },
                child: Container(

                  color: Colors.black87,
                  child: CustomPaint(

                    size:const Size(300, 300),
                    painter: HueRingPainter(selectedHue),
                  ),
                ),
              ),

            ]
        ),
      ),
    );
  }
}

class HueRingPainter extends CustomPainter {
  final double selectedHue;
  final double thumbSize; // Size of the thumb
  final List<Color> hueColors;

  HueRingPainter(this.selectedHue, {this.thumbSize = 38.0})
      : hueColors = List.generate(360, (i) {
    final hue = i.toDouble();
    return HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor();
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40;

    for (var i = 0; i < 360; i++) {
      paint.color = hueColors[i];

      canvas.drawArc(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
        radians(i.toDouble()),
        radians(1),
        false,
        paint,
      );
    }

    // Draw the thumb selector at the selected hue position
    final selectedAngle = radians(selectedHue);
    final selectedX = centerX + radius * cos(selectedAngle);
    final selectedY = centerY + radius * sin(selectedAngle);
    final thumbPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white; // You can customize the thumb color
    canvas.drawCircle(
      Offset(selectedX, selectedY),
      thumbSize / 2,
      thumbPaint,
    );
  }

  double radians(double degrees) {
    return degrees * pi / 180.0;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
