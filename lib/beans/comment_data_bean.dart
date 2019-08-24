import 'package:finerit_app_flutter/beans/reply_comment_data.dart';
import 'package:finerit_app_flutter/beans/userinfo_brief_bean.dart';

class CommentData {
  int id;
  UserInfoBrief user;
  String text;
  var likeCount;
  var commentCount;
  int reply_num;
  String date;
  String commentUser;
  List<ReplyCommentData> replyCommentCommentRelate;
  bool like;

  CommentData(
      {this.id,
        this.user,
        this.text,
        this.likeCount,
        this.commentCount,
        this.date,
        this.commentUser,
        this.replyCommentCommentRelate});

  CommentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? new UserInfoBrief.fromJson(json['user']) : null;
    text = json['text'];
    likeCount = json['like_count'];
    commentCount = json['comment_count'];
    reply_num = json['reply_num'];
    date = json['date'];
    commentUser = json['comment_user'];
    if (json['reply_comment_comment_relate'] != null) {
      replyCommentCommentRelate = new List<ReplyCommentData>();
      json['reply_comment_comment_relate'].forEach((v) {
        replyCommentCommentRelate
            .add(new ReplyCommentData.fromJson(v));
      });
    }
    like = json['like'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['text'] = this.text;
    data['reply_num'] = this.reply_num;
    data['like_count'] = this.likeCount;
    data['comment_count'] = this.commentCount;
    data['date'] = this.date;
    data['comment_user'] = this.commentUser;
    if (this.replyCommentCommentRelate != null) {
      data['reply_comment_comment_relate'] =
          this.replyCommentCommentRelate.map((v) => v.toJson()).toList();
    }
    data['like'] = this.like;
    return data;
  }
}