import 'package:finerit_app_flutter/beans/invite_data_bean.dart';

class InviteDataList {
  List<InviteData> data;

  InviteDataList({this.data});

  InviteDataList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<InviteData>();
      json['data'].forEach((v) {
        data.add(new InviteData.fromJson(v));
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