import 'dart:convert';
import 'package:smartcityapp/constants.dart';
import 'package:http/http.dart' as http;
Future<http.Response> booklot(String adminPhone, String latitude, String longitude,String totalSlots,String emptySlots) async {
  //Defining paramters
  final Map<String, dynamic> params = {
    "adminPhone": adminPhone,
    "latitude": latitude,
    "longitude": longitude,
    "totalSlots": totalSlots,
    "emptySlots":emptySlots
  };
  //Calling the specific API and receiving response
  Uri myUri = Uri.parse("$urlPrefix/parking/register/lot/");
  final response = await http.post(
    myUri,
    headers: {'Content-type': 'application/json', 'Accept': 'application/json'},
    body: jsonEncode(params),
  );
  return response;
}
