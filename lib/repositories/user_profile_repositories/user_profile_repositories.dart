import 'package:dartz/dartz.dart';
import 'package:my_tradebook/models/user_profile_model/user_profile_model.dart';

abstract class UserProfileRepositories {
  Future<void> addUserProfileToFireStore({required UserProfileModel user});
  Future<Either<String, UserProfileModel>> getUserProfile();
  Future<Either<String, int>> updateProfilePic();
  Future<void> updateImageUrl(String imgUrl);
  Future<void> updateUserName(String name);
}
