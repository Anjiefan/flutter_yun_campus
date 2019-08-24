import 'package:finerit_app_flutter/beans/user_level_bean.dart';
import 'package:finerit_app_flutter/beans/vip_info_bean.dart';

class UserInfoBrief {
  String id;
  String headImg;
  String nickName;
  Level level;
  VipInfo vipInfo;
  bool isSystem;
  UserInfoBrief({this.id, this.headImg, this.nickName, this.level, this.vipInfo,this.isSystem});

  UserInfoBrief.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    headImg = json['head_img'];
    nickName = json['nick_name'];
    isSystem = json['is_system'];
    level = json['level'] != null ? new Level.fromJson(json['level']) : null;
    vipInfo = json['vip_info'] != null
        ? new VipInfo.fromJson(json['vip_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['head_img'] = this.headImg;
    data['nick_name'] = this.nickName;
    data['is_system']=this.isSystem;
    if (this.level != null) {
      data['level'] = this.level.toJson();
    }
    if (this.vipInfo != null) {
      data['vip_info'] = this.vipInfo.toJson();
    }
    return data;
  }
}