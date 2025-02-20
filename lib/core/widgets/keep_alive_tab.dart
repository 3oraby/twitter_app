import 'package:flutter/material.dart';

class KeepAliveTab extends StatefulWidget {
  final Widget child;

  const KeepAliveTab({super.key, required this.child});

  @override
  KeepAliveTabState createState() => KeepAliveTabState();
}

class KeepAliveTabState extends State<KeepAliveTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
