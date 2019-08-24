import 'package:finerit_app_flutter/apps/components/web.dart';
import 'package:finerit_app_flutter/apps/profile/components/profile_column_widget.dart';
import 'package:finerit_app_flutter/apps/profile/profile_edit_info_page.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/icons/FineritIcons.dart';
import 'package:finerit_app_flutter/icons/icons_route3.dart';
import 'package:finerit_app_flutter/icons/icons_route4.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseGuide extends StatelessWidget {
  MainStateModel model;

  @override
  Widget build(BuildContext context) {
    model = ScopedModel.of<MainStateModel>(context, rebuildOnChange: true);
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "使用教程",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: <Widget>[
          ProfileCommenWidget(
            icon: FineritIcons.playnext,
            text: '普通代课教程',
            callback: () {
              _handle_guide_detail(context, 'zizhu_daike', '普通代课教程');
            },
          ),
          ProfileCommenWidget(
            icon: FineritIcons.playnext,
            text: 'VIP代课教程',
            callback: () {
              _handle_guide_detail(context, 'zizhu_daike_vip', 'VIP代课教程');
            },
          ),
          ProfileCommenWidget(
            icon: FineritIcons.playnext,
            text: '人工代课教程',
            callback: () {
              _handle_guide_detail(context, 'rengong_daike', '人工代课教程');
            },
          ),
          ProfileCommenWidget(
            icon: FineritIcons.playnext,
            text: '赚钱教程',
            callback: () {
              _handle_guide_detail(context, 'zhuan_qian', '赚钱教程');
            },
          ),
          ProfileCommenWidget(
            icon: FineritIcons.playnext,
            text: '引流教程',
            callback: () {
              _handle_guide_detail(context, 'yin_liu', '引流教程');
            },
          ),
        ],
      ),
    );
  }

  void _handle_guide_detail(BuildContext context, String type, String title) {
    print(type);
    NetUtil.get(Api.GUIDE_GATHER, (data) async {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebApp(
              url: data['url'],
              appBar: new AppBar(
                title: Text(
                  title,
                  style: TextStyle(color: Colors.black),
                ),
                centerTitle: true,
                leading: BackButton(
                  color: Colors.grey[800],
                ),
                backgroundColor: Colors.white,
                actions: <Widget>[
                  Container(
                    child: FlatButton.icon(
                      onPressed: () async {
                        if (await canLaunch(data['url'])) {
                          await launch(data['url']);
                        } else {
                          throw 'Could not launch ${data['url']}';
                        }
                      },
                      icon: Icon(
                        Icons.language,
                        color: Colors.black,
                      ),
                      label: Text(
                        '浏览器打开',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      );
    },
        params: {'type': type},
        headers: {"Authorization": "Token ${model.session_token}"});
  }
}
