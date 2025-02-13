import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

String getTimeAgo(
  Timestamp timestamp, {
  required BuildContext context,
}) {
  final now = DateTime.now();
  final dateTime = timestamp.toDate();

  final difference = now.difference(dateTime);

  if (difference.isNegative) return 'Just now';
  final locale = EasyLocalization.of(context)?.locale.languageCode ?? 'en';
  final isArabic = locale == 'ar';

  if (difference.inDays > 365) {
    final years = now.year - dateTime.year;
    return isArabic ? '$years سنة' : '${years}y';
  } else if (difference.inDays > 30) {
    final months = now.month - dateTime.month + (now.year - dateTime.year) * 12;
    return isArabic ? '$months شهر' : '${months}m';
  } else if (difference.inDays > 7) {
    final weeks = (difference.inDays / 7).floor();
    return isArabic ? '$weeks أسبوع' : '${weeks}w';
  } else if (difference.inDays > 0) {
    return isArabic ? '${difference.inDays} يوم' : '${difference.inDays}d';
  } else if (difference.inHours > 0) {
    return isArabic ? '${difference.inHours} ساعة' : '${difference.inHours}h';
  } else if (difference.inMinutes > 0) {
    return isArabic
        ? '${difference.inMinutes} دقيقة'
        : '${difference.inMinutes}min';
  } else {
    return isArabic ? 'الآن' : 'Just now';
  }
}
