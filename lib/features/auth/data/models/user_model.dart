import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitter_app/core/constants/app_constants.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.userId,
    required super.email,
    super.firstName,
    super.lastName,
    super.phone,
    super.age,
    super.gender,
    super.totalRides,
    super.rating,
    super.location,
    super.currentRideId,
    super.createdAt,
  });

  factory UserModel.fromFirebaseUser({required User user}) {
    return UserModel(
      userId: user.uid,
      email: user.email!,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      age: json['age'],
      gender: Gender.values.firstWhere(
        (e) => e.toString() == 'Gender.${json['gender']}',
        orElse: () => Gender.other,
      ),
      totalRides: json['totalRides'],
      rating: (json['rating']).toDouble(),
      location: json['location'],
      currentRideId: json['currentRideId'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'age': age,
      'gender': gender.toString().split('.').last,
      'totalRides': totalRides,
      'rating': rating,
      'location': location,
      'currentRideId': currentRideId,
      'createdAt': createdAt,
    };
  }
}
