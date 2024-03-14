import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:toastification/toastification.dart';

void showToast(BuildContext context, String message, Color color) {
  toastification.show(context: context, title: Text(message), autoCloseDuration: 3.seconds);
}
