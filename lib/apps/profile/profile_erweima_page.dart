import 'dart:io';
import 'dart:typed_data';
import 'package:finerit_app_flutter/apps/welcome/components/welcome_base_button_widget.dart';
import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:finerit_app_flutter/style/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
class ErweimaPage extends StatefulWidget{
  String url;
  ErweimaPage({Key key,@required this.url}):super(key:key);
  @override
  State<StatefulWidget> createState() =>ErweimaPageState(url: url);
}

class ErweimaPageState extends State<ErweimaPage>{
  String url;
  ErweimaPageState({this.url}):super();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
//      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.grey[800],
        ),
        title: Text("下载邀请二维码", style: TextStyle(color: Colors.grey[800]),),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body:Center(
        child: Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                Container(
                  child: Image.network(url),
                ),
                Container(
                  child: Text('分享二维码，新用户通过扫码完成注册直接成为一级队员',style: TextStyle(
                    color: Colors.black,fontSize: 20
                  ),),
                  padding: EdgeInsets.only(left: 20,right: 20,top: 20),
                ),
                WelcomeBaseButtonWidget(
                    text: '保存图片',
                    callback:(){
                      handle_save_image();
                    },
                    bottonColor:FineritColor.login_button
                )
            ],
          ),
        ),
      )
    );
  }
  Future handle_save_image() async {
    final res = await http.get(url);
    final image = img.decodeImage(res.bodyBytes);

    Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path; // 临时文件夹
    String appDocPath = appDocDir.path; // 应用文件夹

    final imageFile = File(path.join(appDocPath, 'dart.png')); // 保存在应用文件夹内
    await imageFile.writeAsBytes(img.encodePng(image)); // 需要使用与图片格式对应的encode方法
    ByteData bytes = await rootBundle.load(path.join(appDocPath, 'dart.png'));
    final result = await ImageGallerySaver.saveImage(bytes.buffer.asUint8List());
    requestToast('保存成功，请前往手机相册查看');
  }
}