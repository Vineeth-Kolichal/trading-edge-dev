import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_tradebook/authentication/get_current_user_id.dart';
import 'package:my_tradebook/database/local_databse/models/user_model.dart';

Future<void> addName({required UserModel user}) async {
  final userDb = await Hive.openBox<UserModel>('user_db');
  String currentUserId = returnCurrentUserId();
  await userDb.put(currentUserId, user);
}

Future<UserModel?> getUserNameAndImage(String userId) async {
  final userDb = await Hive.openBox<UserModel>('user_db');
  UserModel? user = userDb.get(userId);
  return user;
}

Future<void> updateUserName(String name) async {
  final userDb = await Hive.openBox<UserModel>('user_db');
  UserModel? user = userDb.get(returnCurrentUserId());
  UserModel updatedUser = UserModel(name: name, imagePath: user?.imagePath);
  userDb.put(returnCurrentUserId(), updatedUser);
}
