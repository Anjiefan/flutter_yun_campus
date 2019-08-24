import 'package:finerit_app_flutter/beans/userinfo_brief_bean.dart';

class TeamData {
  UserInfoBrief user;

  TeamData({this.user});

  TeamData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new UserInfoBrief.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

