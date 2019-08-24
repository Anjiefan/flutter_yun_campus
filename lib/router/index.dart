import 'dart:io';

import 'package:finerit_app_flutter/apps/bbs/bbs_replay.dart';
import 'package:finerit_app_flutter/apps/home/home_base.dart';
import 'package:finerit_app_flutter/apps/im/im_base.dart';

import 'package:finerit_app_flutter/apps/profile/profile_base_page.dart';
import 'package:finerit_app_flutter/apps/settings/settings_base.dart';
import 'package:finerit_app_flutter/apps/welcome/welcome_base_page.dart';
import 'package:finerit_app_flutter/apps/welcome/welcome_change_password_page.dart';
import 'package:finerit_app_flutter/apps/welcome/welcome_nickname_avatar_page.dart';
import 'package:finerit_app_flutter/apps/welcome/welcome_splash_page.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:flutter/material.dart';
// 安卓
import 'package:finerit_app_flutter/apps/money/money_base.dart';
// ios
import 'package:finerit_app_flutter/apps/money/money_base_ios.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
Map<String, WidgetBuilder> getRoutes() {
  Widget appWidget;
  if(Platform.isIOS){
    appWidget=MoneyAppIOS();
  }else if(Platform.isAndroid){
    appWidget=MoneyApp();
  }
  return {
    '/': (context){
      MainStateModel model = ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
      if(model.isFirst==null||model.isFirst==true){
        model.isFirst=false;
        return SplashApp();
      }
      if (model.objectId != null &&
          model.password != null &&
          model.userInfo == null) {
        return WelcomeNicknameAvatarApp();
      }
      if (model.isLogin &&
          model.objectId != null &&
          model.password == null &&
          model.userInfo == null) {
        //未设置密码
        return WelcomeBaseApp();
      }
      if (model.isLogin) {
        if (model.state == CommonPageStatus.RUNNING &&
            model.userInfo != null) {
          return HomeApp();
        } else if (model.state == CommonPageStatus.RUNNING && !model.isLogin) {
          return WelcomeBaseApp();
        }
      } else {
        return WelcomeBaseApp();
      }
    },
    '/welcome': (context) => WelcomeBaseApp(),
    '/changepassword': (context) => WelcomeChangePasswordApp(),
    '/home': (context) =>HomeApp(),
    '/settings': (context) => SettingsApp(),
    '/profile': (context) => ProfileApp(),
    '/money': (context) => appWidget,
//    '/chat': (context) => ChatWebViewApp(),
    '/replay': (context) => ReplyPage(),
    '/welcomenicknaneavator': (context) => WelcomeNicknameAvatarApp(),
//    '/replay2': (context) => Reply2Page(),
//    '/replay3': (context) => Reply3Page(),
  };
}
