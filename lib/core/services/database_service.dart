import 'package:twitter_app/core/models/query_condition_model.dart';

abstract class DatabaseService {
  Future<void> addData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  });

  Future<dynamic> getData({
    required String path,
    List<QueryCondition>? queryConditions,
    String? orderByField,
    bool descending = false,
    int? limit,
    String? documentId,
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
}
