abstract class DatabaseTransactionService {
  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
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
    int amount = 1,
  });
}