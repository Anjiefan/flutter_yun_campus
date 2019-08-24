import 'package:finerit_app_flutter/beans/earn_code_data_bean.dart';
class EarnCodeList {
  double income;
  List<EarnCodeData> data;
  EarnCodeList({this.income, this.data});

  EarnCodeList.fromJson(Map<String, dynamic> json) {
    income = json['income'];
    if (json['data'] != null) {
      data = new List<EarnCodeData>();
      json['data'].forEach((v) {
        data.add(new EarnCodeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['income'] = this.income;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}