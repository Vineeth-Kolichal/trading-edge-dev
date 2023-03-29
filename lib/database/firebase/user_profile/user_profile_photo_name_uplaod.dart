import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_tradebook/authentication/get_current_user_id.dart';
import 'package:path_provider/path_provider.dart';

Future<String> pickAndUploadImageToFirebaseStorage() async {
  final pickedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);
  final tempDir = await getTemporaryDirectory();
  final pickedImagePath = pickedImage?.path;
  final path = tempDir.path;
  final compressedImage = await FlutterImageCompress.compressAndGetFile(
      pickedImagePath!, '$path/${DateTime.now().millisecondsSinceEpoch}.jpg',
      quality: 50);

  final storageRef = FirebaseStorage.instance
      .ref()
      .child('user_profile_images')
      .child(returnCurrentUserId());
  final uploadTask = storageRef.putFile(compressedImage!);
  final taskSnapshot = await uploadTask.whenComplete(() {});
  final downloadUrl = await taskSnapshot.ref.getDownloadURL();
  return downloadUrl;
}

Future<void> addUserProfileToFireStore(String name, String? imgUrl) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(returnCurrentUserId())
      .set({
    'name': name,
    'photUrl': imgUrl,
  });
}

Future<void> updateImageUrl(String imgUrl) async {
  final docRef =
      FirebaseFirestore.instance.collection('users').doc(returnCurrentUserId());
  docRef.update({
    'photUrl': imgUrl,
  });
}

Future<String> getNameFromFirebase() async {
  final documentRef =
      FirebaseFirestore.instance.collection('users').doc(returnCurrentUserId());

  final documentSnapshot = await documentRef.get();
  final fieldValue = documentSnapshot['name'];

  return fieldValue;
}

Future<dynamic> getImageUrlFromFirebase() async {
  final documentRef =
      FirebaseFirestore.instance.collection('users').doc(returnCurrentUserId());

  final documentSnapshot = await documentRef.get();
  final fieldValue = documentSnapshot['photUrl'];

  return fieldValue;
}
