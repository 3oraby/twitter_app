import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_app/core/constants/app_constants.dart';

class CompleteProfileUserModel {
  final String firstName;
  final String lastName;
  final String email;
  final int age;
  final Gender gender;
  final String role;
  final String phoneNumber;
  final Timestamp createdAt;
  final double rating;
  final int totalRides;

  CompleteProfileUserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.age,
    required this.gender,
    required this.phoneNumber,
    required this.createdAt,
    this.role = "user",
    this.rating = 5,
    this.totalRides = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'age': age,
      'gender': gender.name,
      'phoneNumber': phoneNumber,
      'rating': rating,
      'role': role,
      'totalRides': totalRides,
      'createdAt': createdAt,
    };
  }

  factory CompleteProfileUserModel.fromJson(Map<String, dynamic> json) {
    return CompleteProfileUserModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      age: json['age'],
      gender: Gender.values.firstWhere((e) => e.name == json['gender']),
      phoneNumber: json['phoneNumber'],
      createdAt: json['createdAt'],
    );
  }
}
