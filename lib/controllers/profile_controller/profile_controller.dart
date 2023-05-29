import 'package:get/get.dart';
import 'package:my_tradebook/models/user_profile_model/user_profile_model.dart';
import 'package:my_tradebook/services/user_profile/user_profile_services.dart';

class ProfileController extends GetxController {
  UserProfileServices userProfileServices = UserProfileServices();
  RxBool isLoading = true.obs;
  RxBool hasError = false.obs;
  RxBool isImageSelected = false.obs;
  RxString name = ''.obs;
  RxString contact = ''.obs;
  RxString imgurl =
      'https://firebasestorage.googleapis.com/v0/b/my-tradebook.appspot.com/o/user_profile_images%2Fuser_image_drawer.png?alt=media&token=259f68a2-dfcb-4be3-9028-781154c58fe6'
          .obs;
  void setImageFromPickedImage(String imgPath) {
    imgurl.value = imgPath;
  }

  void changeLoading(bool setLoading) {
    isLoading.value = setLoading;
  }

  void setUserProfile(UserProfileModel userProfile) {
    userProfileServices.addUserProfileToFireStore(user: userProfile);
  }

  Future<void> getUserProfile() async {
    final data = await userProfileServices.getUserProfile();
    final user = data.fold((l) {
      return null;
    }, (r) {
      return r;
    });
    if (user != null) {
      name.value = user.name;
      imgurl.value = user.imagePath;
      contact.value = user.mailOrPhone;
      changeLoading(false);
    } else {
      hasError.value = true;
    }
  }

  Future<void> updateImage() async {
    final resultFromImageGetFuction =
        await userProfileServices.updateProfilePic();
    final result = resultFromImageGetFuction.fold((l) {
      return l;
    }, (r) => null);
    if (result != null) {
      await userProfileServices.updateImageUrl(result);
    }
    await getUserProfile();
  }

  @override
  void onInit() {
    getUserProfile();
    super.onInit();
  }

  Future<void> changeName(String name) async {
    userProfileServices.updateUserName(name);
    await getUserProfile();
  }
}
