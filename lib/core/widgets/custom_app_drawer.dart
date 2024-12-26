import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CustomAppDrawer extends StatefulWidget {
  const CustomAppDrawer({
    super.key,
  });

  @override
  State<CustomAppDrawer> createState() => _CustomAppDrawerState();
}


class _CustomAppDrawerState extends State<CustomAppDrawer> {
  late bool switchValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.locale.languageCode == 'ar') {
      switchValue = true;
    } else {
      switchValue = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Switch(
              value: switchValue,
              onChanged: (value) async {
                if (value) {
                  await context.setLocale(const Locale('ar'));
                } else {
                  await context.setLocale(const Locale('en'));
                }
                setState(() {
                  switchValue = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}