import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:twitter_app/core/errors/custom_exception.dart';
import 'package:twitter_app/core/models/query_condition_model.dart';
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
      _handleFirebaseException(e);
    } catch (e) {
      log('Error adding data to Firestore: $e');
      throw CustomException(
          message:
              "Cannot add your data right now, please try again later.".tr());
    }
  }

  @override
  Future<dynamic> getData({
    required String path,
    List<QueryCondition>? queryConditions,
    String? orderByField,
    bool descending = false,
    int? limit,
    String? documentId,
  }) async {
    try {
      if (documentId != null) {
        final docSnapshot =
            await firebaseFirestore.collection(path).doc(documentId).get();
        if (docSnapshot.exists) {
          return docSnapshot.data() as Map<String, dynamic>;
        } else {
          throw const CustomException(message: "No item found.");
        }
      }

      Query query = firebaseFirestore.collection(path);
      log('Base Query: firebaseFirestore.collection($path)');
      if (queryConditions != null && queryConditions.isNotEmpty) {
        for (var condition in queryConditions) {
          switch (condition.operator) {
            case QueryOperator.equalTo:
              query = query.where(condition.field, isEqualTo: condition.value);
              log('Adding WHERE: ${condition.field} == ${condition.value}');
              break;
            case QueryOperator.isNotEqualTo:
              query =
                  query.where(condition.field, isNotEqualTo: condition.value);
              log('Adding WHERE: ${condition.field} != ${condition.value}');
              break;
            case QueryOperator.lessThan:
              query = query.where(condition.field, isLessThan: condition.value);
              log('Adding WHERE: ${condition.field} < ${condition.value}');
              break;
            case QueryOperator.greaterThan:
              query =
                  query.where(condition.field, isGreaterThan: condition.value);
              log('Adding WHERE: ${condition.field} > ${condition.value}');
              break;
            case QueryOperator.lessThanOrEqualTo:
              query = query.where(condition.field,
                  isLessThanOrEqualTo: condition.value);
              log('Adding WHERE: ${condition.field} <= ${condition.value}');
              break;
            case QueryOperator.greaterThanOrEqualTo:
              query = query.where(condition.field,
                  isGreaterThanOrEqualTo: condition.value);
              log('Adding WHERE: ${condition.field} >= ${condition.value}');
              break;
          }
        }
      }

      if (orderByField != null) {
        query = query.orderBy(orderByField, descending: descending);
        log('Adding ORDER BY: $orderByField ${descending ? 'desc' : 'asc'}');
      }

      if (limit != null) {
        query = query.limit(limit);
        log('Adding LIMIT: $limit');
      }

      log('Final Query: ${query.parameters}');

      final querySnapshot = await query.get();
      if (querySnapshot.docs.isEmpty) {
        log("No items found matching your search.");
        return [];
        // throw CustomException(
        //     message: "No items found matching your search.".tr());
      }

      return querySnapshot.docs.toList();
    } on FirebaseException catch (e) {
      _handleFirebaseException(e);
    } catch (e) {
      log('Error getting data from Firestore: $e');
      throw CustomException(
          message:
              "Cannot fetch your data right now, please try again later.".tr());
    }
  }

  @override
  Future<void> updateData({
    required String path,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      log("Updating document at collection: $path with docId: $documentId");
      await firebaseFirestore.collection(path).doc(documentId).update(data);
      log("Document updated successfully at $path/$documentId");
    } on FirebaseException catch (e) {
      _handleFirebaseException(e);
    } catch (e) {
      log('Error updating data in Firestore: $e');
      throw CustomException(
          message: "Cannot update your data right now, please try again later."
              .tr());
    }
  }

  @override
  Future<void> deleteData({
    required String path,
    required String documentId,
  }) async {
    try {
      log("Deleting document at collection: $path with docId: $documentId");
      await firebaseFirestore.collection(path).doc(documentId).delete();
      log("Document deleted successfully at $path/$documentId");
    } on FirebaseException catch (e) {
      _handleFirebaseException(e);
    } catch (e) {
      log('Error deleting data from Firestore: $e');
      throw CustomException(
          message: "Cannot delete your data right now, please try again later."
              .tr());
    }
  }

  @override
  Future<void> incrementField({
    required String path,
    required String documentId,
    required String field,
    int incrementAmount = 1,
  }) async {
    try {
      await firebaseFirestore.collection(path).doc(documentId).update({
        field: FieldValue.increment(incrementAmount),
      });
    } catch (e) {
      throw Exception("Failed to increment field: $e");
    }
  }

  @override
  Future<void> decrementField({
    required String path,
    required String documentId,
    required String field,
    int decrementAmount = -1,
  }) async {
    try {
      await firebaseFirestore.collection(path).doc(documentId).update({
        field: FieldValue.increment(decrementAmount),
      });
    } catch (e) {
      throw Exception("Failed to decrement field: $e");
    }
  }

  void _handleFirebaseException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        throw CustomException(
            message: "You do not have permission to perform this action.".tr());
      case 'not-found':
        throw CustomException(message: "Requested data not found.".tr());
      case 'unavailable':
        throw CustomException(
            message:
                "Service is temporarily unavailable. Please try again later."
                    .tr());
      case 'deadline-exceeded':
        throw CustomException(
            message: "Operation timed out. Please try again.".tr());
      default:
        log("there is an error in firestore service ${e.toString()}");
        throw CustomException(message: "An unknown error occurred".tr());
    }
  }
}
