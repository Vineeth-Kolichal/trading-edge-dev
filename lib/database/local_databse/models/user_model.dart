import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';
part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  Uint8List? image;
  UserModel({required this.name, this.image});
}
