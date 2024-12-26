class FirebaseAuthUserModel {
  final String email;
  final String uid;

  const FirebaseAuthUserModel({required this.email, required this.uid});

  factory FirebaseAuthUserModel.fromJson({required Map<String, dynamic> json}) {
    return FirebaseAuthUserModel(
      email: json["email"],
      uid: json["uid"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "uid": uid,
    };
  }
}
