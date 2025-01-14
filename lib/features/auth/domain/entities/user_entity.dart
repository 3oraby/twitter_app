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

  UserEntity copyWith({
    String? userId,
    String? email,
    String? firstName,
    String? lastName,
    int? age,
    Gender? gender,
    String? profilePicUrl,
    String? coverPicUrl,
    String? bio,
    String? pinnedTweetId,
    String? phoneNumber,
    int? nFollowing,
    int? nFollowers,
    Timestamp? joinedAt,
  }) {
    return UserEntity(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      coverPicUrl: coverPicUrl ?? this.coverPicUrl,
      bio: bio ?? this.bio,
      pinnedTweetId: pinnedTweetId ?? this.pinnedTweetId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      nFollowing: nFollowing ?? this.nFollowing,
      nFollowers: nFollowers ?? this.nFollowers,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
