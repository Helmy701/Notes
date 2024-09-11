import 'package:flutter/material.dart';

showLoading(BuildContext context) {
     showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.75),
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Center(child: CircularProgressIndicator(color: Color(0xFF6034A6), strokeWidth: 6,))
        );
      },
    );
  }