import 'package:finerit_app_flutter/beans/shied_user_data_bean.dart';

class ShieldUserDataList {
  List<ShieldUserData> data;

  ShieldUserDataList({this.data});

  ShieldUserDataList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<ShieldUserData>();
      json['data'].forEach((v) {
        data.add(new ShieldUserData.fromJson(v));
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