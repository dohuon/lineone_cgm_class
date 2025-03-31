import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as Fluttertoast;

class Toast {
  static show(text) {
    Fluttertoast.Fluttertoast.showToast(
        msg: text,
        toastLength: Fluttertoast.Toast.LENGTH_LONG,
        gravity: Fluttertoast.ToastGravity.CENTER,
        timeInSecForIosWeb: 4,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        webPosition: 'center',
        webBgColor: "linear-gradient(to right, #3B6939, #4CAF50)",
        fontSize: 16.0);
  }
}
