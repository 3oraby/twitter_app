import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_app/core/models/query_condition_model.dart';
import 'package:twitter_app/core/services/database_transaction_service.dart';

abstract class DatabaseService {
  Future<String?> addData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  });

  Future<dynamic> getData({
    required String path,
    List<QueryCondition>? queryConditions,
    List<String>? orderByFields,
    List<bool>? descending,
    int? limit,
    String? documentId,
    DocumentSnapshot? lastDocument,
    dynamic startAfterValue,
    String? startAfterField,
    dynamic startAt,
    dynamic startAfter,
  });

  Future<void> updateData({
    required String path,
    required String documentId,
    required Map<String, dynamic> data,
  });

  Future<void> deleteData({
    required String path,
    required String documentId,
  });

  Future<void> incrementField({
    required String path,
    required String documentId,
    required String field,
    int incrementAmount = 1,
  });

  Future<void> decrementField({
    required String path,
    required String documentId,
    required String field,
    int decrementAmount = -1,
  });

  Future<void> runTransaction(
    Future<void> Function(DatabaseTransactionService transaction)
        transactionHandler,
  );
  Future<void> addToList({
    required String path,
    required String documentId,
    required String field,
    required dynamic value,
  });

  Future<void> removeFromList({
    required String path,
    required String documentId,
    required String field,
    required dynamic value,
  });
}
