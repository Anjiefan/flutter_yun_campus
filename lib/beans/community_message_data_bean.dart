import 'package:finerit_app_flutter/beans/comment_data_bean.dart';
import 'package:finerit_app_flutter/beans/reply_comment_data.dart';
import 'package:finerit_app_flutter/beans/status_data_bean.dart';
import 'package:finerit_app_flutter/beans/userinfo_brief_bean.dart';

class CommunityMessageData {
  int id;
  UserInfoBrief relateUser;
  String date;
  String type;
  String relateId;
  String replyId;
  String relateContent;
  String myContent;
  String user;

  CommunityMessageData(
      {this.id,
        this.relateUser,
        this.date,
        this.type,
        this.relateId,
        this.replyId,
        this.relateContent,
        this.myContent,
        this.user});

  CommunityMessageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    relateUser = json['relate_user'] != null
        ? new UserInfoBrief.fromJson(json['relate_user'])
        : null;
    date = json['date'];
    type = json['type'];
    relateId = json['relate_id'];
    replyId = json['reply_id'];
    relateContent = json['relate_content'];
    myContent = json['my_content'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.relateUser != null) {
      data['relate_user'] = this.relateUser.toJson();
    }
    data['date'] = this.date;
    data['type'] = this.type;
    data['relate_id'] = this.relateId;
    data['reply_id'] = this.replyId;
    data['relate_content'] = this.relateContent;
    data['my_content'] = this.myContent;
    data['user'] = this.user;
    return data;
  }
}
