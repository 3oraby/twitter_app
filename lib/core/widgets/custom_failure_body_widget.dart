import 'package:flutter/material.dart';

class CustomFailureBodyWidget extends StatelessWidget {
  const CustomFailureBodyWidget({
    super.key,
    required this.message,
  });

  final String message;
  @override
  Widget build(BuildContext context) {
    return Text(message);
  }
}
