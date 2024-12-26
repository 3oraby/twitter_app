import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_app/core/constants/app_constants.dart';

class UserEntity {
  final String userId;
  String? firstName;
  String? lastName;
  final String email;
  String? phone;
  int? age;
  Gender? gender;
  int? totalRides;
  double? rating;
  GeoPoint? location;
  String? currentRideId;
  Timestamp? createdAt;

  UserEntity({
    required this.userId,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.age,
    this.gender,
    this.totalRides,
    this.rating,
    this.location,
    this.currentRideId,
    this.createdAt,
  });
}
