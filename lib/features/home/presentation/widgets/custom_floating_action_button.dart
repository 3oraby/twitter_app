import 'package:flutter/material.dart';
import 'package:twitter_app/core/widgets/custom_container_button.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    super.key,
    required this.iconData,
    required this.onPressed,
  });

  final VoidCallback onPressed;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return CustomContainerButton(
      onPressed: onPressed,
      borderRadius: 40,
      child: Icon(
        iconData,
        color: Colors.white,
        size: 32,
      ),
    );
  }
}
