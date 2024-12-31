import 'package:twitter_app/core/constants/local_storage_data_names.dart';
import 'package:twitter_app/core/services/shared_preferences_singleton.dart';

Future<void> deleteUserDataFromPrefs() async {
  await SharedPreferencesSingleton.deleteKey(LocalStorageDataNames.kUserData);
}
