abstract class AuthenticationRepo {
  Future<void> sendOtp({required String mobileNumber});
  Future<bool> verifyOtp({required String otp});
  Future<bool> googleLogin();
  Future<void> googleSignOut();
  Future<bool> checkUserDataExist(String userId);
}
