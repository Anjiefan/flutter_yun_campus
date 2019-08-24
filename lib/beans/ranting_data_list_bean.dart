import 'package:finerit_app_flutter/beans/ranting_data_bean.dart';

class RantingDataList {
  List<RantingData> data;

  RantingDataList({this.data});

  RantingDataList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<RantingData>();
      json['data'].forEach((v) {
        data.add(new RantingData.fromJson(v));
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
