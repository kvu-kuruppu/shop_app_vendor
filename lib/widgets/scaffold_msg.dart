import 'package:flutter/material.dart';

class SCF {
  scaffoldMsg({context, msg}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).clearSnackBars();
        },
      ),
    ));
  }
}