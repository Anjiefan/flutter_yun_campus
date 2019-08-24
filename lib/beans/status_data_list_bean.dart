import 'package:finerit_app_flutter/beans/status_data_bean.dart';

class StatusDataList {
  List<StatusData> data;

  StatusDataList({this.data});

  StatusDataList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<StatusData>();
      json['data'].forEach((v) {
        data.add(new StatusData.fromJson(v));
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