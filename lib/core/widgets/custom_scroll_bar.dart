import 'package:flutter/material.dart';

class CustomScrollBar extends StatelessWidget {
  const CustomScrollBar({
    super.key,
    required this.child,
    this.controller,
  });

  final Widget child;
  final ScrollController? controller;
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: controller,
      thumbVisibility: true,
      thickness: 8.0,
      trackVisibility: true,
      interactive: true,
      radius: const Radius.circular(10),
      child: child,
    );
  }
}
