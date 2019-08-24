import 'package:finerit_app_flutter/beans/user_level_bean.dart';
import 'package:finerit_app_flutter/beans/userinfo_brief_bean.dart';
import 'package:finerit_app_flutter/beans/vip_info_bean.dart';

class ShieldUserData {

  UserInfoBrief shieldUser;
  bool isShield;
  int id;

  ShieldUserData({this.shieldUser, this.isShield, this.id});

  ShieldUserData.fromJson(Map<String, dynamic> json) {
    shieldUser = json['shield_user'] != null
        ? new UserInfoBrief.fromJson(json['shield_user'])
        : null;
    isShield = json['is_shield'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.shieldUser != null) {
      data['shield_user'] = this.shieldUser.toJson();
    }
    data['is_shield'] = this.isShield;
    data['id'] = this.id;
    return data;
  }
}