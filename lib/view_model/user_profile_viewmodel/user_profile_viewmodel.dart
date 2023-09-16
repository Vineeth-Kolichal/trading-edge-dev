import 'package:flutter/material.dart';
import 'package:trading_edge/models/user_model/user_model.dart';
import 'package:trading_edge/data/repositories/user_profile_repo/user_profile_repo.dart';
import 'package:trading_edge/data/services/user_profile_services/userprofile_services.dart';
import 'package:trading_edge/utils/constants/const_values.dart';

class UserProfileViewModel extends ChangeNotifier {
  UserProfileRepo userProfileRepo = UserProfileServices();
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  String imageUrl = defaultUserImage;
  String? name;
  String? contact;

  Future<void> updateImage() async {
    String imgPath =
        await userProfileRepo.pickAndUploadImageToFirebaseStorage();
    await userProfileRepo.updateProfileImage(imgPath);
    imageUrl = imgPath;
    notifyListeners();
  }

  Future<void> updateName() async {
    await userProfileRepo.updateUserName(nameController.text.trim());
    getProfileDetails();
  }

  Future<void> getProfileDetails() async {
    final user = await userProfileRepo.getuserProfileDetails();
    imageUrl = user.imagePath ?? defaultUserImage;
    name = user.name;
    contact = user.contact;

    notifyListeners();
  }

  Future<void> addImage() async {
    imageUrl = await userProfileRepo.pickAndUploadImageToFirebaseStorage();
    notifyListeners();
  }

  Future<void> addUserProfileToFireStore(UserModel userModel) async {
    await userProfileRepo.addUserProfileToFireStore(userModel: userModel);
  }
}
