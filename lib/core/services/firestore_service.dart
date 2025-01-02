import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
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
      // if (querySnapshot.docs.isEmpty) {
      //   throw const CustomException(
      //       message: "No items found matching your search.");
      // }

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
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
        default:
          throw CustomException(
              message: "An unknown error occurred: ${e.message}");
      }
    } catch (e) {
      log('Error getting data from Firestore: $e');
      throw const CustomException(
          message: "Cannot fetch your data right now, please try again later.");
    }
  }
}
