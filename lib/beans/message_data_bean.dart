import 'package:finerit_app_flutter/beans/userinfo_brief_bean.dart';


class MessageData {
  int id;
  UserInfoBrief relateUser;
  String showDate;
  String info;
  bool isShow;
  bool isTop;
  String type;
  String date;
  String updateDate;
  int infoNum;
  String user;

  MessageData(
      {this.id,
        this.relateUser,
        this.showDate,
        this.info,
        this.isShow,
        this.isTop,
        this.type,
        this.date,
        this.updateDate,
        this.infoNum,
        this.user});

  MessageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    relateUser = json['relate_user'] != null
        ? new UserInfoBrief.fromJson(json['relate_user'])
        : null;
    showDate = json['show_date'];
    info = json['info'];
    isShow = json['is_show'];
    isTop = json['is_top'];
    type = json['type'];
    date = json['date'];
    updateDate = json['update_date'];
    infoNum = json['info_num'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.relateUser != null) {
      data['relate_user'] = this.relateUser.toJson();
    }
    data['show_date'] = this.showDate;
    data['info'] = this.info;
    data['is_show'] = this.isShow;
    data['is_top'] = this.isTop;
    data['type'] = this.type;
    data['date'] = this.date;
    data['update_date'] = this.updateDate;
    data['info_num'] = this.infoNum;
    data['user'] = this.user;
    return data;
  }
}

