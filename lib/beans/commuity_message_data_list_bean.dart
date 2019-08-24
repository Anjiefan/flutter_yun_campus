import 'package:finerit_app_flutter/beans/community_message_data_bean.dart';

class CommunityMessageDataList {
  List<CommunityMessageData> data;

  CommunityMessageDataList({this.data});

  CommunityMessageDataList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<CommunityMessageData>();
      json['data'].forEach((v) {
        data.add(new CommunityMessageData.fromJson(v));
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
