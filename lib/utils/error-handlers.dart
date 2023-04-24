import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

toasterSuccessMsg(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.green,
  );
}

toasterFailureMsg(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.redAccent,
  );
}

toasterUnknownFailure() {
  Fluttertoast.showToast(
    msg: 'Something went wrong',
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.redAccent,
  );
}

Future<bool> toasterHandler(Map map_res) async {
  if (map_res['status_code'] == 200 || map_res['success'] == true) {
    Fluttertoast.showToast(
      msg: map_res['message'],
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
    );

    return true;
  } else {
    Fluttertoast.showToast(
      msg: map_res['message'] + " (Server)",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.redAccent,
    );
    return false;
  }
}

Future<bool> boolHandler(Map map_res) async {
  if (map_res['status_code'] == 200 || map_res['success'] == true) {
    return true;
  } else {
    return false;
  }
}
