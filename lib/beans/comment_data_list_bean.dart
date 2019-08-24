
import 'package:finerit_app_flutter/beans/comment_data_bean.dart';

class CommentList {
  List<CommentData> data;

  CommentList({this.data});

  CommentList.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<CommentData>();
      json['data'].forEach((v) {
        data.add(new CommentData.fromJson(v));
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