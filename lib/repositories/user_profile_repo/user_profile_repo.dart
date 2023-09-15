abstract class UserProfileRepo {
  Future<void> addGoogleDetailsToFirestore();
  Future<void> addUserProfileToFireStore(
      {required String name, String? imgUrl, String? contact});
}
