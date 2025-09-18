import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppValidations {
  static String? validateEmailInput(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    bool emailValid = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(email.trim());

    if (!emailValid) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? validatePasswordInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    return null;
  }

  static String? normalInputValidate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    return null;
  }

  static void showSnackBar(BuildContext? context, String? value) {
    final snackBar = SnackBar(content: Text(value!));
    ScaffoldMessenger.of(context!).showSnackBar(snackBar);
  }

  static void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg.trim(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
