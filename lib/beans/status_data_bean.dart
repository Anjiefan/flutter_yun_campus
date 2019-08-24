import 'package:finerit_app_flutter/beans/userinfo_brief_bean.dart';

class StatusData {
  int id;
  String date;
  List<String> images;
  List<String> video;
  UserInfoBrief user;
  String text;
  String type;
  String infoType;
  var finerCode;
  var commentCount;
  var browseCount;
  var collectCount;
  bool collect;

  StatusData(
      {this.id,
        this.date,
        this.images,
        this.video,
        this.user,
        this.text,
        this.type,
        this.infoType,
        this.finerCode,
        this.commentCount,
        this.browseCount,
        this.collectCount,
        this.collect});

  StatusData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    images = json['images'].cast<String>();
    video = json['video'].cast<String>();
    user = json['user'] != null ? new UserInfoBrief.fromJson(json['user']) : null;
    text = json['text'];
    type = json['type'];
    infoType = json['info_type'];
    finerCode = json['finer_code'];
    commentCount = json['comment_count'];
    browseCount = json['browse_count'];
    collectCount = json['collect_count'];
    collect = json['collect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['images'] = this.images;
    data['video'] = this.video;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['text'] = this.text;
    data['type'] = this.type;
    data['info_type'] = this.infoType;
    data['finer_code'] = this.finerCode;
    data['comment_count'] = this.commentCount;
    data['browse_count'] = this.browseCount;
    data['collect_count'] = this.collectCount;
    data['collect'] = this.collect;
    return data;
  }
}