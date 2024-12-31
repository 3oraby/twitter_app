import 'dart:convert';

import 'package:twitter_app/core/constants/local_storage_data_names.dart';
import 'package:twitter_app/core/services/shared_preferences_singleton.dart';
import 'package:twitter_app/features/auth/data/models/user_model.dart';
import 'package:twitter_app/features/auth/domain/entities/user_entity.dart';

UserEntity getCurrentUserEntity() {
  var jsonString =
      SharedPreferencesSingleton.getString(LocalStorageDataNames.kUserData);
  UserEntity userEntity = UserModel.fromJson(jsonDecode(jsonString));
  return userEntity;
}
