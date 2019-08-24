
import 'package:finerit_app_flutter/beans/userinfo_brief_bean.dart';

class InviteData {
  UserInfoBrief invite;

  InviteData({this.invite});

  InviteData.fromJson(Map<String, dynamic> json) {
    invite =
    json['invite'] != null ? new UserInfoBrief.fromJson(json['invite']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.invite != null) {
      data['invite'] = this.invite.toJson();
    }
    return data;
  }
}