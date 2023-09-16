import 'package:trading_edge/models/user_model/user_model.dart';

abstract class UserProfileRepo {
  Future<void> addGoogleDetailsToFirestore();
  Future<void> addUserProfileToFireStore({required UserModel userModel});
  Future<void> updateProfileImage(String imgUrl);
  Future<String> pickAndUploadImageToFirebaseStorage();
  Future<UserModel> getuserProfileDetails();
  Future<void> updateUserName(String name);
}
