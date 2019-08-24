import 'package:finerit_app_flutter/apps/components/web.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/commons/ui.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/state/page_state.dart';
import 'package:finerit_app_flutter/style/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
class JobWebApp extends StatefulWidget {
  final String url;
  const JobWebApp({
    Key key,
    @required this.url,
  }):
        assert(url != null),
        super(key:key);
  @override
  State<StatefulWidget> createState() =>JobWebAppState(this.url);
}

class JobWebAppState extends PageState<JobWebApp> {
  final String url;
  MainStateModel model;
  JobWebAppState(this.url);
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    model = ScopedModel.of<MainStateModel>(context, rebuildOnChange: true);
    // TODO: implement build
    return WebviewScaffold(
        url: url,
        withZoom: true,
        withLocalStorage: true,
        hidden: true,
        withJavascript: true,
        appBar: new AppBar(
        title: Text(
          '兼职中心',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
          leading:IconButton(
              icon:Icon(
                Icons.language,
                color: Colors.black,
              ),
              color: FineritColor.color1_normal,
              onPressed: () async {
                if (await canLaunch(url)) {
                await launch(url);
                } else {
                throw 'Could not launch ${url}';
                }
              }

          ),
        actions: <Widget>[
          Container(
            child: FlatButton.icon(
              onPressed: () async {
                if (await canLaunch('https://www.huayingrc.com/?uid=375311')) {
                  await launch('https://www.huayingrc.com/?uid=375311');
                } else {
                  throw 'Could not launch https://www.huayingrc.com/?uid=375311';
                }
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                    builder: (context) => WebApp(
//                        url: 'https://www.huayingrc.com/?uid=375311',
//                        appBar: new AppBar(
//                          title: Text(
//                            '私有兼职',
//                            style: TextStyle(color: Colors.black),
//                          ),
//                          centerTitle: true,
//                          leading: BackButton(
//                            color: Colors.grey[800],
//                          ),
//                          backgroundColor: Colors.white,
//                          actions: <Widget>[
//                            Container(
//                              child: FlatButton.icon(
//                                onPressed: () async {
//                                  if (await canLaunch('https://www.huayingrc.com/?uid=375311')) {
//                                    await launch('https://www.huayingrc.com/?uid=375311');
//                                  } else {
//                                    throw 'Could not launch https://www.huayingrc.com/?uid=375311';
//                                  }
//                                },
//                                icon: Icon(
//                                  Icons.language,
//                                  color: Colors.black,
//                                ),
//                                label: Text(
//                                  '浏览器打开',
//                                  style: TextStyle(color: Colors.black),
//                                ),
//                              ),
//                            ),
//                          ],
//                        )),
//                  ),
//                );
              },
              icon: Icon(
                Icons.person,
                color: Colors.black,
              ),
              label: Text(
                '私有兼职',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
        initialChild: Container(
          alignment: Alignment.topCenter,
          child: new EasyRefresh(
            autoLoad: true,
            firstRefresh:true,
            key: easyRefreshKey,
            refreshHeader: MaterialHeader(
              key: headerKey,
            ),
            refreshFooter: MaterialFooter(
              key: footerKey,
            ),
            child: new ListView.builder(
              //ListView的Item
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(

                      children: <Widget>[

                        GestureDetector(
                          child: Stack(children: <Widget>[
                            Container(
                                width: MediaQuery.of(context).size.width,
                                child:
                                Image.network(
                                  'https://www.finerit.com/media/jz.png',height: MediaQuery.of(context).size.height,))
                          ]),
                          onTap: (){
//                            _handle_guide_detail('feng_mian','活动公告');
                          },
                        ),
                      ],
                    ),
                  );
                }),
            onRefresh: ()  {
            },
            loadMore: ()  {
            },
          ),
        )


    );
  }

  @override
  Future load_more_data() {
    // TODO: implement load_more_data
    return null;
  }

  @override
  Future refresh_data() {
    // TODO: implement refresh_data
    return null;
  }
  void _handle_guide_detail(String type, String title) {
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
