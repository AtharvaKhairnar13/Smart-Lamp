import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



void setColor(Color color, BuildContext context) async {
  final r = color.red.toString();
  final g = color.green.toString();
  final b = color.blue.toString();
  final body = {
    "r": r,
    "g": g,
    "b": b,
  };

  try {
    /*final response = await http.post(
      Uri.http('', '/colour'),
      body: body,
      // You can include headers here if needed
    );*/

    if (true/*response.statusCode != 200*/) {
      //print("Device Error setting color: /*${response.reasonPhrase}*/");
    }
  } catch (e) {
    print("Connection Error: $e");
  }

  print("Turned $r, $g, $b on");
}
