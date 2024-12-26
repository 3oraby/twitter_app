import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_app/core/errors/custom_exception.dart';
import 'package:twitter_app/core/services/database_service.dart';

class FirestoreService implements DatabaseService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<void> addData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  }) async {
    try {
      if (documentId != null) {
        log("set new data to collection: $path and docId: $documentId");
        await firebaseFirestore.collection(path).doc(documentId).set(data);
      } else {
        log("add new data to collection $path");
        await firebaseFirestore.collection(path).add(data);
      }
    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'permission-denied':
          throw const CustomException(
              message: "You do not have permission to perform this action.");
        case 'not-found':
          throw const CustomException(message: "Requested data not found.");
        case 'unavailable':
          throw const CustomException(
              message:
                  "Service is temporarily unavailable. Please try again later.");
        case 'deadline-exceeded':
          throw const CustomException(
              message: "Operation timed out. Please try again.");
        case 'already-exists':
          throw const CustomException(
              message: "Document with the same ID already exists.");
        case 'aborted':
          throw const CustomException(
              message:
                  "Operation aborted due to a conflict. Please try again.");
        case 'invalid-argument':
          throw const CustomException(
              message: "Invalid input. Please check your data.");
        default:
          throw CustomException(
              message: "An unknown error occurred: ${e.message}");
      }
    } catch (e) {
      log('Error adding data to Firestore: $e');
      throw const CustomException(
          message: "Can not add your data right now , please try again later");
    }
  }

  @override
  Future<bool> isIdInCollection(
      {required String collectionName, required String id}) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(id)
          .get();

      if (doc.exists) {
        log("Document exists!");
        return true;
      } else {
        log("Document does not exist!");
        throw const CustomException(
            message: "User not found. Please register or contact support.");
      }
    } catch (e) {
      log("Error occurred: $e");
      return false;
    }
  }
}
