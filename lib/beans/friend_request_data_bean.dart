import 'package:finerit_app_flutter/beans/userinfo_brief_bean.dart';

class FriendRequestData {
  int id;
  UserInfoBrief requestToUser;
  String type;
  String date;

  FriendRequestData({this.id, this.requestToUser, this.type, this.date});

  FriendRequestData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    requestToUser = json['request_to_user'] != null
        ? new UserInfoBrief.fromJson(json['request_to_user'])
        : new UserInfoBrief.fromJson(json['user']);
    type = json['type'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.requestToUser != null) {
      data['request_to_user'] = this.requestToUser.toJson();
    }
    data['type'] = this.type;
    data['date'] = this.date;
    return data;
  }
}