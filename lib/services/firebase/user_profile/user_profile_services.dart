import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_tradebook/models/user_profile_model/user_profile_model.dart';
import 'package:my_tradebook/repositories/user_profile_repositories/user_profile_repositories.dart';
import 'package:my_tradebook/services/authentication/get_current_user_id.dart';
import 'package:path_provider/path_provider.dart';

class UserProfileServices extends UserProfileRepositories {
  @override
  Future<void> addUserProfileToFireStore(
      {required UserProfileModel user}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(returnCurrentUserId())
        .set({
      'name': user.name,
      'photUrl': user.imagePath,
      'contact': user.mailOrPhone,
    }).catchError((error) {});
  }

  @override
  Future<Either<String, UserProfileModel>> getUserProfile() async {
    try {
      final documentRef = FirebaseFirestore.instance
          .collection('users')
          .doc(returnCurrentUserId());

      final documentSnapshot = await documentRef.get();

      final user = UserProfileModel(
          name: documentSnapshot['name'],
          imagePath: documentSnapshot['photUrl'],
          mailOrPhone: documentSnapshot['contact']);
      return Right(user);
    } catch (e) {
      return const Left('error');
    }
  }

  @override
  Future<Either<String, int>> updateProfilePic() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage == null) {
        return const Right(400);
      }
      final tempDir = await getTemporaryDirectory();
      final pickedImagePath = pickedImage.path;
      final path = tempDir.path;
      final compressedImage = await FlutterImageCompress.compressAndGetFile(
          pickedImagePath, '$path/${DateTime.now().millisecondsSinceEpoch}.jpg',
          quality: 25);

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_profile_images')
          .child(returnCurrentUserId());
      final uploadTask = storageRef.putFile(compressedImage!);
      final taskSnapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return Left(downloadUrl);
    } catch (e) {
      return const Right(400);
    }
  }

  @override
  Future<void> updateImageUrl(String imgUrl) async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(returnCurrentUserId());
    docRef.update({
      'photUrl': imgUrl,
    }).catchError((error) {
    });
  }
@override
  Future<void> updateUserName(String name) async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(returnCurrentUserId());
    docRef.update({
      'name': name,
    }).catchError((error) {
     
    });
  }
}
