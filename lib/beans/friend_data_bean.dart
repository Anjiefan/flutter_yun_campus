import 'package:finerit_app_flutter/apps/contact/components/suspension_listview.dart';
import 'package:finerit_app_flutter/beans/userinfo_brief_bean.dart';
import 'package:lpinyin/lpinyin.dart';
class FriendData extends ISuspensionBean{
  int id;
  UserInfoBrief friendUser;
  String date;
  String tagIndex;
  String namePinyin;
  FriendData({this.id, this.friendUser, this.date});

  FriendData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    friendUser = json['friend_user'] != null
        ? new UserInfoBrief.fromJson(json['friend_user'])
        : null;
    date = json['date'];
    setTagIndex();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.friendUser != null) {
      data['friend_user'] = this.friendUser.toJson();
    }
    data['date'] = this.date;
    return data;
  }
  void setTagIndex(){
    String pinyin = PinyinHelper.convertToPinyinStringWithoutException(this.friendUser.nickName);
    String tag = pinyin.substring(0, 1).toUpperCase();
    this.namePinyin = pinyin;
    if (RegExp("[A-Z]").hasMatch(tag)) {
      this.tagIndex = tag;
    } else {
      this.tagIndex = "#";
    }
  }

  @override
  String getSuspensionTag() {
    // TODO: implement getSuspensionTag
    return tagIndex;
  }
}
