import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Validators {
  static String? validateNormalText(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return "Field is required".tr();
    }
    return null;
  }

  static String? validateEmail(BuildContext context, String? value) {
    const String emailPattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    final RegExp regex = RegExp(emailPattern);
    if (value == null || value.isEmpty) {
      return "Email is required".tr();
    } else if (!regex.hasMatch(value)) {
      return "Please enter a valid email address".tr();
    }
    return null;
  }

  static String? validatePassword(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required".tr();
    } else if (value.length < 8) {
      return "Password must be at least 8 characters long".tr();
    }
    return null;
  }

  static String? validatePhoneNumber(BuildContext context, String? value) {
    const String phonePattern = r'^\+?[0-9]{10,15}$';
    final RegExp regex = RegExp(phonePattern);
    if (value == null || value.isEmpty) {
      return "Phone number is required".tr();
    } else if (!regex.hasMatch(value)) {
      return "Please enter a valid phone number".tr();
    }
    return null;
  }

  static String? validateAge(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }
    final age = int.tryParse(value);
    if (age == null || age <= 0) {
      return 'Please enter a valid age';
    }
    if (age < 14) {
      return 'Age must be 14 or older';
    }
    if (age > 150) {
      return 'Please enter a realistic age';
    }
    return null;
  }
}
