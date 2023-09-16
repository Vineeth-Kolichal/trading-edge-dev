import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trading_edge/services/current_user_data.dart';
import 'package:trading_edge/views/widgets/widget_error_snackbar.dart';
import 'package:path_provider/path_provider.dart';

Future<String> pickAndUploadImageToFirebaseStorage() async {
  final pickedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);
  final tempDir = await getTemporaryDirectory();
  final pickedImagePath = pickedImage?.path;
  final path = tempDir.path;
  final compressedImage = await FlutterImageCompress.compressAndGetFile(
      pickedImagePath!, '$path/${DateTime.now().millisecondsSinceEpoch}.jpg',
      quality: 25);

  final storageRef = FirebaseStorage.instance
      .ref()
      .child('user_profile_images')
      .child(CurrentUserData.returnCurrentUserId());
  final uploadTask = storageRef.putFile(compressedImage!);
  final taskSnapshot = await uploadTask.whenComplete(() {});
  final downloadUrl = await taskSnapshot.ref.getDownloadURL();
  return downloadUrl;
}

Future<void> addUserProfileToFireStore(
    {required String name, String? imgUrl, String? contact}) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(CurrentUserData.returnCurrentUserId())
      .set({
    'name': name,
    'photUrl': imgUrl,
    'contact': contact,
  }).catchError((error) {
    // Handle the error
    String errorMessage = "Error writing data to database: $error";

    Get.snackbar('Oops..:', errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        margin: const EdgeInsets.all(10),
        animationDuration: const Duration(milliseconds: 700),
        colorText: Colors.white);
  });
}

Future<void> updateImageUrl(String imgUrl) async {
  final docRef =
      FirebaseFirestore.instance.collection('users').doc(CurrentUserData.returnCurrentUserId());
  docRef.update({
    'photUrl': imgUrl,
  }).catchError((error) {
    // Handle the error
    String errorMessage = "Error writing data to database: $error";

    Get.snackbar('Oops..:', errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        margin: const EdgeInsets.all(10),
        animationDuration: const Duration(milliseconds: 700),
        colorText: Colors.white);
  });
}

Future<void> updateUserName(String name) async {
  final docRef =
      FirebaseFirestore.instance.collection('users').doc(CurrentUserData.returnCurrentUserId());
  docRef.update({
    'name': name,
  }).catchError((error) {
    // Handle the error
    String errorMessage = "Error writing data to database: $error";
    errorSnack(errorMessage);
  });
}

Future<bool> checkUserDataExist(String userId) async {
  final DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

  if (snapshot.exists) {
    return true;
  } else {
    return false;
  }
}
