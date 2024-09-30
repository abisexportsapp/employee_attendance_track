import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SAPGetData {
  String url;
  String userName;
  String password;
  String result;
  String remarks;
  Map<String, String>? headers;
  void Function(dynamic data)? onDataRecieved;
  void Function(dynamic data)? onErrorRecieved;
  BuildContext context;
  bool showSnackBar;
  SAPGetData(
      {required this.remarks,
      required this.result,
      required this.url,
      required this.userName,
      required this.password,
      this.headers,
      required this.showSnackBar,
      this.onDataRecieved,
      this.onErrorRecieved,
      required this.context}) {
    _getdatafromApi().then((value) {
      if (onDataRecieved != null) onDataRecieved!(value);
    }).catchError((e) {
      if (showSnackBar) SnackBar(content: Text(e.toString()));

      // if(showSnackBar) SAPSnackBar.alert(context: context, message: e.toString(),icon: Icons.error_outline);
      if (onErrorRecieved != null) onErrorRecieved!(e);
    });
  }

  Future _getdatafromApi() async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'authorization':
              'Basic ${base64.encode(utf8.encode('$userName:$password'))}',
          'accept': "application/json",
          if (headers != null) ...headers!
        },
      );
      debugPrint('${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        var apiData = jsonDecode(response.body);
        if (!apiData['d']['results'][0]['$result']) {
          throw apiData['d']['results'][0]['$remarks'];
        } else {
          return apiData['d'];
        }
      } else if (response.statusCode == 500) {
        var apiData = jsonDecode(response.body);
        throw apiData;
      } else {
        throw response.body;
      }
    } on SocketException {
      throw 'Check your Internet Connection !';
    } on TimeoutException {
      throw 'Internet connection is too Slow .';
    } catch (e) {
      rethrow;
    }
  }
}
