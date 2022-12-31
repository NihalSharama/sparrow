import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '';

var uuid = Uuid();

loadUserId() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  var userId;

  if (preferences.containsKey('userId')) {
    userId = preferences.getString('userId');
  } else {
    userId = uuid.v4();

    preferences.setString('userId', userId);
  }

  return userId;
}
