import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.userId,
    required super.userName,
    required super.firstName,
    required super.lastName,
    required super.age,
    required super.gender,
    required super.phoneNumber,
    super.profilePicUrl,
    super.coverPicUrl,
    super.bio,
    super.pinnedTweetId,
    super.nFollowing,
    super.nFollowers,
    required super.joinedAt,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      userId: doc.id,
      userName: data['userName'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      age: data['age'],
      gender: Gender.values[data['gender']],
      profilePicUrl: data['profilePicUrl'],
      coverPicUrl: data['coverPicUrl'],
      bio: data['bio'],
      pinnedTweetId: data['pinnedTweetId'],
      phoneNumber: data['phoneNumber'],
      nFollowing: data['nFollowing'] ?? 0,
      nFollowers: data['nFollowers'] ?? 0,
      joinedAt: data['joinedAt'],
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'userId': userId,
      'userName': userName,
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'gender': gender.index,
      'profilePicUrl': profilePicUrl,
      'coverPicUrl': coverPicUrl,
      'bio': bio,
      'pinnedTweetId': pinnedTweetId,
      'phoneNumber': phoneNumber,
      'nFollowing': nFollowing,
      'nFollowers': nFollowers,
      'joinedAt': joinedAt,
    };
  }

  Map<String, dynamic> toJson() {
    return toDocument();
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      userName: json['userName'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      age: json['age'],
      gender: Gender.values[json['gender']],
      profilePicUrl: json['profilePicUrl'],
      coverPicUrl: json['coverPicUrl'],
      bio: json['bio'],
      pinnedTweetId: json['pinnedTweetId'],
      phoneNumber: json['phoneNumber'],
      nFollowing: json['nFollowing'] ?? 0,
      nFollowers: json['nFollowers'] ?? 0,
      joinedAt: json['joinedAt'],
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      userName: userName,
      firstName: firstName,
      lastName: lastName,
      age: age,
      gender: gender,
      profilePicUrl: profilePicUrl,
      coverPicUrl: coverPicUrl,
      bio: bio,
      pinnedTweetId: pinnedTweetId,
      phoneNumber: phoneNumber,
      nFollowing: nFollowing,
      nFollowers: nFollowers,
      joinedAt: joinedAt,
    );
  }
}
