import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
class networkCode {
  static Future<String> sendHTTPreq(String inputJson, String urlEnd) async{
    final url = Uri.parse("http://86.28.248.238:8080/" + urlEnd);
    final headers = ({"Content-type": "application/json"});
    //final reqJson =json.encode({"userid":username, "useremail":email});
    final response = await http.post(url, headers: headers, body: inputJson);
    print ("statusasdasdasdasdasdshjtyhjthyhrteyhertyhtyh:${response.statusCode}" );
    print ("body: ${response.body}");
    return response.body;
    //myCallback(response.body, callBack2);
  }
  
  static Future<dynamic> grabImage(String urlEnd) async{
    return Image.network('http://86.28.248.238:8080/fileDownload?filename=' + urlEnd);
  }
}