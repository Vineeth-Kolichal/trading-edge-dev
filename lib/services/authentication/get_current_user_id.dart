import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

String returnCurrentUserId() {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  String? userId = user?.uid;
  return userId!;
}

Future<bool> checkDocumentExists({required String collectionPath,required String documentId}) async {
  final documentRef = FirebaseFirestore.instance.collection(collectionPath).doc(documentId);
  final documentSnapshot = await documentRef.get();
  return documentSnapshot.exists;
}