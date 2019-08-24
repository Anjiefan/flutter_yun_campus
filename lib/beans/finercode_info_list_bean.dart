import 'package:finerit_app_flutter/beans/finercode_info_data_bean.dart';

class FinerCodeInfoList {
  double outcome;
  double income;
  List<FinerCodeInfoData> data;

  FinerCodeInfoList({this.outcome, this.income, this.data});

  FinerCodeInfoList.fromJson(Map<String, dynamic> json) {
    outcome = json['outcome'];
    income = json['income'];
    if (json['data'] != null) {
      data = new List<FinerCodeInfoData>();
      json['data'].forEach((v) {
        data.add(new FinerCodeInfoData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['outcome'] = this.outcome;
    data['income'] = this.income;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}