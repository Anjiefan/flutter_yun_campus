import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/router/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
Future main() async {
//  设置ios的keys
//  AMapLocationClient.setApiKey("cb5d6f11166a33b13c22ffe8ee2065d6");
  SharedPreferences _prefs=await SharedPreferences.getInstance();
  MainStateModel model = MainStateModel(_prefs);
//  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//    systemNavigationBarColor: Colors.white,
//    statusBarColor: Colors.white
//  ));
  runApp(
      ScopedModel<MainStateModel>(
        model: model,
        child:  MaterialApp(

          title: "云智校",
          theme: ThemeData(
          ),

          initialRoute: '/',
          //route configuration
          routes: getRoutes(),
        ),
      )
  );
}

