import 'package:finerit_app_flutter/beans/friend_request_data_bean.dart';

class FriendRequestDataList {
  List<FriendRequestData> data;
  FriendRequestDataList({this.data});
  FriendRequestDataList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<FriendRequestData>();
      json['data'].forEach((v) {
        data.add(new FriendRequestData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}