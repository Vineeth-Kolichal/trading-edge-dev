
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trading_edge/models/user_model/user_model.dart';
import 'package:trading_edge/data/services/current_user_data.dart';
import 'package:trading_edge/data/repositories/user_profile_repo/user_profile_repo.dart';

class UserProfileServices implements UserProfileRepo {
  Future<bool> checkUserDataExist(String userId) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (snapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> addUserProfileToFireStore({required UserModel userModel}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(CurrentUserData.returnCurrentUserId())
        .set({
      'name': userModel.name,
      'photUrl': userModel.imagePath,
      'contact': userModel.contact,
    }).catchError((error) {});
  }

  @override
  Future<void> addGoogleDetailsToFirestore() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    String? name = currentUser?.displayName;
    String? imagePath = currentUser?.photoURL;
    bool isUserExist =
        await checkUserDataExist(CurrentUserData.returnCurrentUserId());
    if (!isUserExist) {
      UserModel userModel = UserModel(
          name: name ?? '', imagePath: imagePath, contact: currentUser?.email);
      await addUserProfileToFireStore(userModel: userModel);
    }
  }

  @override
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

  @override
  Future<void> updateProfileImage(String imgUrl) async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(CurrentUserData.returnCurrentUserId());
    docRef.update({
      'photUrl': imgUrl,
    }).catchError((error) {});
  }
@override
Future<void> updateUserName(String name) async {
  final docRef =
      FirebaseFirestore.instance.collection('users').doc(CurrentUserData.returnCurrentUserId());
  docRef.update({
    'name': name,
  }).catchError((_) {
  
   
  });
}

  @override
  Future<UserModel> getuserProfileDetails() async {
    DocumentSnapshot<Map<String, dynamic>> currentUserDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(CurrentUserData.returnCurrentUserId())
            .get();
    Map<String, dynamic> userData =
        currentUserDoc.data() as Map<String, dynamic>;
    return UserModel(
        name: userData['name'],
        imagePath: userData['photUrl'],
        contact: userData['contact']);
  }
}
