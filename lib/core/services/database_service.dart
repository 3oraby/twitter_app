abstract class DatabaseService {
  Future<void> addData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  });

  Future<bool> isIdInCollection(
      {required String collectionName, required String id});
}
