import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_app/core/constants/app_constants.dart';

class UserEntity {
  final String userId;
  // final String userName;
  final String email;
  String? firstName;
  String? lastName;
  int? age;
  Gender? gender;
  String? profilePicUrl;
  String? coverPicUrl;
  String? bio;
  String? pinnedTweetId;
  String? phoneNumber;
  int nFollowing;
  int nFollowers;
  final Timestamp joinedAt;

  UserEntity({
    required this.userId,
    // required this.userName,
    required this.email,
    this.firstName,
    this.lastName,
    this.age,
    this.gender,
    this.profilePicUrl,
    this.coverPicUrl,
    this.bio,
    this.pinnedTweetId,
    this.phoneNumber,
    this.nFollowing = 0,
    this.nFollowers = 0,
    required this.joinedAt,
  });
}
