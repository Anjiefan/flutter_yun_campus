import 'package:finerit_app_flutter/beans/message_data_bean.dart';

class MessageDataList {
  List<MessageData> data;

  MessageDataList({this.data});

  MessageDataList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<MessageData>();
      json['data'].forEach((v) {
        data.add(new MessageData.fromJson(v));
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
