import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatDateFromTimestamp(Timestamp? timestamp) {
  if (timestamp == null) {
    return '';
  }
  try {
    final date = timestamp.toDate();
    return DateFormat('hh:mm a - yyyy-MM-dd').format(date);
  } catch (e) {
    return '';
  }
}
