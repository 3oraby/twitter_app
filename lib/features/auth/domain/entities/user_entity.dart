import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_app/core/constants/app_constants.dart';

class UserEntity {
  final String userId;
  final String userName;
  final String firstName;
  final String lastName;
  final int age;
  final Gender gender;
  final String? profilePicUrl;
  final String? coverPicUrl;
  final String? bio;
  final String? pinnedTweetId;
  final String phoneNumber;
  int nFollowing;
  int nFollowers;
  final Timestamp joinedAt;

  UserEntity({
    required this.userId,
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.gender,
    this.profilePicUrl,
    this.coverPicUrl,
    this.bio,
    this.pinnedTweetId,
    required this.phoneNumber,
    this.nFollowing = 0,
    this.nFollowers = 0,
    required this.joinedAt,
  });
}
