import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_tradebook/database/local_databse/models/user_model.dart';

void checkAdapterRegistered()  {
  if (!Hive.isAdapterRegistered(UserModelAdapter().typeId)) {
    Hive.registerAdapter(UserModelAdapter());
  }
}
