import 'package:finerit_app_flutter/beans/userinfo_brief_bean.dart';

class TeamMessageData {
  int id;
  List<String> images;
  List<String> video;
  UserInfoBrief user;
  String date;
  String text;
  String dateDay;

  TeamMessageData(
      {this.id,
        this.images,
        this.video,
        this.user,
        this.date,
        this.text,
        this.dateDay});

  TeamMessageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    images = json['images'].cast<String>();
    video = json['video'].cast<String>();
    user = json['user'] != null ? new UserInfoBrief.fromJson(json['user']) : null;
    date = json['date'];
    text = json['text'];
    dateDay = json['date_day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['images'] = this.images;
    data['video'] = this.video;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['date'] = this.date;
    data['text'] = this.text;
    data['date_day'] = this.dateDay;
    return data;
  }
}