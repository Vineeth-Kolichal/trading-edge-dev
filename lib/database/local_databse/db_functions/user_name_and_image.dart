import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_tradebook/authentication/get_current_user_id.dart';
import 'package:my_tradebook/database/local_databse/models/user_model.dart';

// ValueNotifier<String> nameNotifier = ValueNotifier('');
// ValueNotifier<String> imgPathNotifier = ValueNotifier('');
Future<void> addName({required UserModel user}) async {
  final userDb = await Hive.openBox<UserModel>('user_db');
  String currentUserId = returnCurrentUserId();
  await userDb.put(currentUserId, user);
  getUserNameAndImage(currentUserId);
}

Future<UserModel?> getUserNameAndImage(String userId) async {
  final userDb = await Hive.openBox<UserModel>('user_db');
  UserModel? user = userDb.get(userId);
  return user;
}

Future<void> updateUserName(String name) async {
  final userDb = await Hive.openBox<UserModel>('user_db');
  UserModel? user = userDb.get(returnCurrentUserId());
  UserModel updatedUser = UserModel(name: name, image: user?.image);
  userDb.put(returnCurrentUserId(), updatedUser);
}

Future<void> updateUserImage(Uint8List image) async {
  final userDb = await Hive.openBox<UserModel>('user_db');
  UserModel? user = userDb.get(returnCurrentUserId());
  final name = user?.name;
  UserModel updatedUser = UserModel(name: name!, image: image);
  userDb.put(returnCurrentUserId(), updatedUser);
}
