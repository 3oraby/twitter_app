
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguageSelectionSwitch extends StatefulWidget {
  const LanguageSelectionSwitch({super.key});

  @override
  State<LanguageSelectionSwitch> createState() =>
      _LanguageSelectionSwitchState();
}

class _LanguageSelectionSwitchState extends State<LanguageSelectionSwitch> {
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
    return Switch(
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
    );
  }
}
