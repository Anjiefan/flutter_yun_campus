import 'package:finerit_app_flutter/beans/team_info_data_bean.dart';

class TeamInfo {
  List<TeamData> data;
  int firstNum;
  int secondNum;

  TeamInfo({this.data, this.firstNum, this.secondNum});

  TeamInfo.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<TeamData>();
      json['data'].forEach((v) {
        data.add(new TeamData.fromJson(v));
      });
    }
    firstNum = json['first_num'];
    secondNum = json['second_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['first_num'] = this.firstNum;
    data['second_num'] = this.secondNum;
    return data;
  }
}
