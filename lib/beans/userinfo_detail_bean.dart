import 'package:finerit_app_flutter/beans/user_level_bean.dart';
import 'package:finerit_app_flutter/beans/vip_info_bean.dart';

class UserInfoDetail {
  String id;
  var money;
  String phone;
  var voucher;
  String headImg;
  String nickName;
  int experience;
  Level level;
  VipInfo vipInfo;
  bool isSystem;
  UserInfoDetail(
      {this.id,
        this.money,
        this.phone,
        this.voucher,
        this.headImg,
        this.nickName,
        this.experience,
        this.isSystem,
        this.level,
        this.vipInfo});

  UserInfoDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    money = json['money'];
    phone = json['phone'];
    voucher = json['voucher'];
    headImg = json['head_img'];
    isSystem = json['is_system'];
    nickName = json['nick_name'];
    experience = json['experience'];
    level = json['level'] != null ? new Level.fromJson(json['level']) : null;
    vipInfo = json['vip_info'] != null
        ? new VipInfo.fromJson(json['vip_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['money'] = this.money;
    data['phone'] = this.phone;
    data['voucher'] = this.voucher;
    data['is_system']=this.isSystem;
    data['head_img'] = this.headImg;
    data['nick_name'] = this.nickName;
    data['experience'] = this.experience;
    if (this.level != null) {
      data['level'] = this.level.toJson();
    }
    if (this.vipInfo != null) {
      data['vip_info'] = this.vipInfo.toJson();
    }
    return data;
  }
}