import 'dart:convert';
import 'package:smartcityapp/constants.dart';
import 'package:http/http.dart' as http;

Future<http.Response> signup(String name, String email, String password) async {
  //Defining paramters
  final Map<String, dynamic> params = {
    "username": name,
    "email": email,
    "password": password,
    "password2": password,
  };
  //Calling the specific API and receiving response
  Uri myUri = Uri.parse("$urlPrefix/auth/register/");
  final response = await http.post(
    myUri,
    headers: {'Content-type': 'application/json', 'Accept': 'application/json'},
    body: jsonEncode(params),
  );
  return response;
}

Future<http.Response> signin(String username, String password) async {
  //Defining paramters
  final Map<String, dynamic> params = {"username": username, "password": password};
  //Calling the specific API and receiving response
  Uri myUri = Uri.parse("$urlPrefix/auth/token/");
  final response = await http.post(
    myUri,
    headers: {'Content-type': 'application/json', 'Accept': 'application/json'},
    body: jsonEncode(params),
  );
  print(response);
  return response;
}
