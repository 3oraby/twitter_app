import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

String formatDateFromTimestamp({
  required Timestamp? timestamp,
  required BuildContext context,
  bool includeHour = true,
  bool monthYearOnly = false,
}) {
  if (timestamp == null) return '';

  try {
    final date = timestamp.toDate();

    String formatPattern;
    if (monthYearOnly) {
      formatPattern = 'MMMM yyyy';
    } else if (includeHour) {
      formatPattern = 'hh:mm a - yyyy-MM-dd';
    } else {
      formatPattern = 'yyyy-MM-dd';
    }
    final currentLocale =
        EasyLocalization.of(context)?.locale.languageCode ?? 'en';

    return DateFormat(formatPattern, currentLocale).format(date);
  } catch (e) {
    return '';
  }
}
