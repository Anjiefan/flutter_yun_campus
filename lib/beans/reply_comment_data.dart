import 'package:finerit_app_flutter/beans/userinfo_brief_bean.dart';

class ReplyCommentData {
  int id;
  UserInfoBrief user;
  String replyedUser;
  String text;
  var likeCount;
  String date;
  bool like;
  ReplyCommentData(
      {this.id,
        this.user,
        this.replyedUser,
        this.text,
        this.likeCount,
        this.date});

  ReplyCommentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new UserInfoBrief.fromJson(json['user']) : null;
    replyedUser = json['replyed_user'];
    text = json['text'];
    likeCount = json['like_count'];
    date = json['date'];
    like = json['like'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['replyed_user'] = this.replyedUser;
    data['text'] = this.text;
    data['like_count'] = this.likeCount;
    data['date'] = this.date;
    data['like'] = this.like;
    return data;
  }
}