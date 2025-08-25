import 'package:palm_ecommerce_mobile_app_2/models/profile/profile.dart';

abstract class ProfileRepository {
  Future<ProfileInfo> getUserInfo();
  Future<ProfileInfo> getFullUserInfo();
}

