import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter_app/core/services/database_transaction_service.dart';

class FirestoreTransactionService implements DatabaseTransactionService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final Transaction _transaction;

  FirestoreTransactionService(this._transaction);

  @override
  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  }) async {
    if (documentId != null) {
      _transaction.set(
        firebaseFirestore.collection(path).doc(documentId),
        data,
      );
    } else {
      _transaction.set(
        firebaseFirestore.collection(path).doc(),
        data,
      );
    }
  }

  @override
  Future<void> updateData({
    required String path,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    _transaction.update(
      firebaseFirestore.collection(path).doc(documentId),
      data,
    );
  }

  @override
  Future<void> deleteData({
    required String path,
    required String documentId,
  }) async {
    _transaction.delete(
      firebaseFirestore.collection(path).doc(documentId),
    );
  }

  @override
  Future<void> incrementField({
    required String path,
    required String documentId,
    required String field,
    int amount = 1,
  }) async {
    _transaction.update(
      firebaseFirestore.collection(path).doc(documentId),
      {field: FieldValue.increment(amount)},
    );
  }
}
