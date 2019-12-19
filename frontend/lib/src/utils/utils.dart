import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

bool isEmpty(String s) {
  return (s.isEmpty) ? true : false;
}

Future<bool> showErrorToast(message) {
  return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
