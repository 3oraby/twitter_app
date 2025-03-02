import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_app/core/errors/custom_exception.dart';
import 'package:twitter_app/core/models/query_condition_model.dart';
import 'package:twitter_app/core/services/database_service.dart';
import 'package:twitter_app/core/services/database_transaction_service.dart';
import 'package:twitter_app/core/services/firestore_transaction_service.dart';

class FirestoreService implements DatabaseService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<String?> addData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  }) async {
    try {
      if (documentId != null) {
        log("set new data to collection: $path and docId: $documentId");
        await firebaseFirestore.collection(path).doc(documentId).set(data);
        return null;
      } else {
        log("add new data to collection $path");
        DocumentReference<Map<String, dynamic>> docs =
            await firebaseFirestore.collection(path).add(data);
        return docs.id;
      }
    } on FirebaseException catch (e) {
      _handleFirebaseException(e);
      return null;
    } catch (e) {
      log('Error adding data to Firestore: $e');
      throw const CustomException(
          message: "Cannot add your data right now, please try again later.");
    }
  }

  @override
  Future<dynamic> getData({
    required String path,
    List<QueryCondition>? queryConditions,
    List<String>? orderByFields,
    List<bool>? descending,
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
            case QueryOperator.whereIn:
              query = query.where(condition.field, whereIn: condition.value);
              log('Adding WHERE: ${condition.field} whereIn ${condition.value}');
              break;
            case QueryOperator.whereNotIn:
              query = query.where(condition.field, whereNotIn: condition.value);
              log('Adding WHERE: ${condition.field} whereNotIn ${condition.value}');
              break;
          }
        }
      }

      if (orderByFields != null) {
        for (int i = 0; i < orderByFields.length; i++) {
          log("query$i");
          query = query.orderBy(orderByFields[i], descending: descending![i]);
        }
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
        //     message: "No items found matching your search.");
      }
      log("--------- query end ---------");
      return querySnapshot.docs.toList();
    } on FirebaseException catch (e) {
      _handleFirebaseException(e);
    } catch (e) {
      log('Error getting data from Firestore: $e');
      throw const CustomException(
          message: "Cannot fetch your data right now, please try again later.");
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
      throw const CustomException(
          message:
              "Cannot update your data right now, please try again later.");
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
      throw const CustomException(
          message:
              "Cannot delete your data right now, please try again later.");
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
      default:
        log("there is an error in firestore service ${e.toString()}");
        throw const CustomException(message: "An unknown error occurred");
    }
  }

  @override
  Future<void> runTransaction(
    Future<void> Function(DatabaseTransactionService transaction)
        transactionHandler,
  ) async {
    try {
      await firebaseFirestore.runTransaction((firestoreTransaction) async {
        final transaction = FirestoreTransactionService(firestoreTransaction);
        await transactionHandler(transaction);
      });
    } on FirebaseException catch (e) {
      _handleFirebaseException(e);
    } catch (e) {
      log('Error running Firestore transaction: $e');
      throw const CustomException(
          message: "Cannot complete the transaction, please try again later.");
    }
  }

  @override
  Future<void> addToList({
    required String path,
    required String documentId,
    required String field,
    required dynamic value,
  }) async {
    try {
      log("Adding $value to $field in $path/$documentId");
      await firebaseFirestore.collection(path).doc(documentId).update({
        field: FieldValue.arrayUnion([value]),
      });
      log("Added $value to $field successfully");
    } on FirebaseException catch (e) {
      _handleFirebaseException(e);
    } catch (e) {
      log('Error adding to list in Firestore: $e');
      throw const CustomException(
          message:
              "Cannot update your data right now, please try again later.");
    }
  }

  @override
  Future<void> removeFromList({
    required String path,
    required String documentId,
    required String field,
    required dynamic value,
  }) async {
    try {
      log("Removing $value from $field in $path/$documentId");
      await firebaseFirestore.collection(path).doc(documentId).update({
        field: FieldValue.arrayRemove([value]),
      });
      log("Removed $value from $field successfully");
    } on FirebaseException catch (e) {
      _handleFirebaseException(e);
    } catch (e) {
      log('Error removing from list in Firestore: $e');
      throw const CustomException(
          message:
              "Cannot update your data right now, please try again later.");
    }
  }
}
