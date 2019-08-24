import 'package:finerit_app_flutter/beans/experience_data_bean.dart';

class ExperienceDataList {
  int sum;
  List<ExperienceData> data;

  ExperienceDataList({this.sum, this.data});

  ExperienceDataList.fromJson(Map<String, dynamic> json) {
    sum = json['sum'];
    if (json['data'] != null) {
      data = new List<ExperienceData>();
      json['data'].forEach((v) {
        data.add(new ExperienceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sum'] = this.sum;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}