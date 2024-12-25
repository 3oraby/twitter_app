
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TwitterApp extends StatelessWidget {
  const TwitterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('HelloWorld'.tr()),
        ),
      ),
    );
  }
}
