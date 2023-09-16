import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trading_edge/services/current_user_data.dart';
import 'package:trading_edge/repositories/user_profile_repo/user_profile_repo.dart';

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
  Future<void> addUserProfileToFireStore(
      {required String name, String? imgUrl, String? contact}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(CurrentUserData.returnCurrentUserId())
        .set({
      'name': name,
      'photUrl': imgUrl,
      'contact': contact,
    }).catchError((error) {});
  }

  @override
  Future<void> addGoogleDetailsToFirestore() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    String? name = currentUser?.displayName;
    String? imagePath = currentUser?.photoURL;
    bool isUserExist = await checkUserDataExist(CurrentUserData.returnCurrentUserId());
    if (!isUserExist) {
      await addUserProfileToFireStore(
          name: name!, imgUrl: imagePath, contact: currentUser?.email);
    }
  }
}
