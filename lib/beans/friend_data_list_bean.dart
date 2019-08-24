import 'package:finerit_app_flutter/beans/friend_data_bean.dart';

class FriendDataList {
  List<FriendData> data;
  FriendDataList({this.data});
  FriendDataList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<FriendData>();
      json['data'].forEach((v) {
        data.add(new FriendData.fromJson(v));
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