import 'package:finerit_app_flutter/beans/team_message_data_bean.dart';

class TeamMessageDataList {
  List<TeamMessageData> data;

  TeamMessageDataList({this.data});

  TeamMessageDataList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<TeamMessageData>();
      json['data'].forEach((v) {
        data.add(new TeamMessageData.fromJson(v));
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