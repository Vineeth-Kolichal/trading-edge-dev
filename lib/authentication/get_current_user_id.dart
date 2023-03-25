import 'package:my_tradebook/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

dynamic returnCurrentUserId() async {
  SharedPreferences shared = await SharedPreferences.getInstance();
  final String? userid = shared.getString(currentUserId);
  print(userid);
  return;
}
