import 'package:finerit_app_flutter/beans/userinfo_brief_bean.dart';

class EarnCodeData {
  int id;
  UserInfoBrief childUser;
  String date;
  String incident;
  double finerCode;

  EarnCodeData({this.id, this.childUser, this.date, this.incident, this.finerCode});

  EarnCodeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    childUser = json['child_user'] != null
        ? new UserInfoBrief.fromJson(json['child_user'])
        : null;
    date = json['date'];
    incident = json['incident'];
    finerCode = json['finer_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.childUser != null) {
      data['child_user'] = this.childUser.toJson();
    }
    data['date'] = this.date;
    data['incident'] = this.incident;
    data['finer_code'] = this.finerCode;
    return data;
  }
}
