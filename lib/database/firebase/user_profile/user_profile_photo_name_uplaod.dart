import 'package:cloud_firestore/cloud_firestore.dart';
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
      quality: 25);

  final storageRef = FirebaseStorage.instance
      .ref()
      .child('user_profile_images')
      .child(returnCurrentUserId());
  final uploadTask = storageRef.putFile(compressedImage!);
  final taskSnapshot = await uploadTask.whenComplete(() {});
  final downloadUrl = await taskSnapshot.ref.getDownloadURL();
  return downloadUrl;
}

Future<void> addUserProfileToFireStore(
    {required String name, String? imgUrl, String? contact}) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(returnCurrentUserId())
      .set({
    'name': name,
    'photUrl': imgUrl,
    'contact': contact,
  });
}

Future<void> updateImageUrl(String imgUrl) async {
  final docRef =
      FirebaseFirestore.instance.collection('users').doc(returnCurrentUserId());
  docRef.update({
    'photUrl': imgUrl,
  });
}

Future<void> updateUserName(String name) async {
  final docRef =
      FirebaseFirestore.instance.collection('users').doc(returnCurrentUserId());
  docRef.update({
    'name': name,
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
