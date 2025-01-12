import 'package:cloud_firestore/cloud_firestore.dart';

class FollowingRelationshipEntity {
  final String followedId;
  final String followingId;
  final Timestamp followedAt;

  FollowingRelationshipEntity({
    required this.followedId,
    required this.followingId,
    required this.followedAt,
  });
}
