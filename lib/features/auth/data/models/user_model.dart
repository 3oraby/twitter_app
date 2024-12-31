import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.userId,
    // required super.userName,
    required super.firstName,
    required super.lastName,
    required super.email,
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
      // userName: data['userName'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      email: data['email'],
      age: data['age'],
      gender: Gender.values[data['gender']],
      profilePicUrl: data['profilePicUrl'],
      coverPicUrl: data['coverPicUrl'],
      bio: data['bio'],
      pinnedTweetId: data['pinnedTweetId'],
      phoneNumber: data['phoneNumber'],
      nFollowing: data['nFollowing'] ?? 0,
      nFollowers: data['nFollowers'] ?? 0,
      joinedAt: data['joinedAt'] is Timestamp
          ? data['joinedAt'] as Timestamp
          : Timestamp.fromDate(DateTime.parse(data[
              'joinedAt'])), 
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'userId': userId,
      // 'userName': userName,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'age': age,
      'gender': gender.index,
      'profilePicUrl': profilePicUrl,
      'coverPicUrl': coverPicUrl,
      'bio': bio,
      'pinnedTweetId': pinnedTweetId,
      'phoneNumber': phoneNumber,
      'nFollowing': nFollowing,
      'nFollowers': nFollowers,
      'joinedAt': joinedAt.toDate().toIso8601String()
    };
  }

  Map<String, dynamic> toJson() {
    return toDocument();
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      // userName: json['userName'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      age: json['age'],
      gender: Gender.values[json['gender']],
      profilePicUrl: json['profilePicUrl'],
      coverPicUrl: json['coverPicUrl'],
      bio: json['bio'],
      pinnedTweetId: json['pinnedTweetId'],
      phoneNumber: json['phoneNumber'],
      nFollowing: json['nFollowing'] ?? 0,
      nFollowers: json['nFollowers'] ?? 0,
      joinedAt: json['joinedAt'] is Timestamp
          ? json['joinedAt'] as Timestamp
          : Timestamp.fromDate(
              DateTime.parse(json['joinedAt'])), 
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      userId: entity.userId,
      // userName: entity.userName,
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      age: entity.age,
      gender: entity.gender,
      profilePicUrl: entity.profilePicUrl,
      coverPicUrl: entity.coverPicUrl,
      bio: entity.bio,
      pinnedTweetId: entity.pinnedTweetId,
      phoneNumber: entity.phoneNumber,
      nFollowing: entity.nFollowing,
      nFollowers: entity.nFollowers,
      joinedAt: entity.joinedAt,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      // userName: userName,
      firstName: firstName,
      lastName: lastName,
      email: email,
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
