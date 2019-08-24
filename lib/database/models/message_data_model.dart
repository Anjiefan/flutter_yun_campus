import 'dart:convert';

import 'package:finerit_app_flutter/database/base_model.dart';

MessageDataModel pushDataModelFromJson(String str){
  final jsonData = json.decode(str);
  return MessageDataModel.fromMap(jsonData);
}

String pushDataModelToJson(MessageDataModel pushData){
  final dyn = pushData.toMap();
  return json.encode(dyn);
}

class MessageDataModel extends BaseDatabaseModel{
  int id;
  String relatedUser;
  String info;
  String userId;
  int isShow;
  int isTop;
  String type;
  String pushDate;
  String updateDate;
  String showDate;
  int infoNum;
  MessageDataModel({
    this.id,
    this.relatedUser,
    this.info,
    this.isShow,
    this.isTop,
    this.type,
    this.pushDate,
    this.updateDate,
    this.infoNum,
    this.userId,
    this.showDate
  });

  factory MessageDataModel.fromMap(Map<String, dynamic> json) => MessageDataModel(
    id: json["id"],
    relatedUser: json["relate_user"],
    info: json["info"],
    isShow: json["is_show"],
    isTop: json["is_top"],
    type: json["type"],
    pushDate: json["push_date"],
    updateDate: json["update_date"],
    infoNum: json["info_num"],
      userId:json['user_id'],
      showDate: json['show_date']
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "relate_user": relatedUser,
    "info": info,
    "is_show": isShow,
    "is_top": isTop,
    "type": type,
    "push_date": pushDate,
    "update_date": updateDate,
    'info_num':infoNum,
    'user_id':userId,
    'show_date':showDate
  };

}