import 'package:cloud_firestore/cloud_firestore.dart';

String getTimeAgo(Timestamp timestamp) {
  final now = DateTime.now();
  final dateTime = timestamp.toDate();

  final difference = now.difference(dateTime);

  if (difference.inDays > 365) {
    final years = (difference.inDays / 365).floor();
    return '${years}y';
  } else if (difference.inDays > 30) {
    final months = (difference.inDays / 30).floor();
    return '${months}m';
  } else if (difference.inDays > 7) {
    final weeks = (difference.inDays / 7).floor();
    return '${weeks}w';
  } else if (difference.inDays > 0) {
    return '${difference.inDays}d';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}h';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes}min';
  } else {
    return 'Just now';
  }
}
