
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
}
