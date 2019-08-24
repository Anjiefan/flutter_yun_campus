import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:finerit_app_flutter/beans/status_data_bean.dart';
import 'package:finerit_app_flutter/commons/experience_constant.dart';
import 'package:finerit_app_flutter/extra_apps/chewie/lib/chewie.dart';
import 'package:finerit_app_flutter/commons/http_error.dart';
import 'package:finerit_app_flutter/commons/net_load.dart';
import 'package:finerit_app_flutter/commons/permissions.dart';
import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:finerit_app_flutter/icons/icons_route2.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:finerit_app_flutter/apps/components/flare_widget.dart';
import 'package:finerit_app_flutter/apps/components/image_grid_view.dart';
import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/commons/load_locale_imgs.dart';
import 'package:finerit_app_flutter/style/themes.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/asset.dart';
import 'package:multi_image_picker/cupertino_options.dart';
import 'package:multi_image_picker/picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
class ProfileSend extends StatefulWidget{
  BaseStatusModel statusModel;
  ProfileSend({Key key,this.statusModel}) : super(key: key);
  @override
  _ProfileSendState createState() => new _ProfileSendState(statusModel: statusModel);
}

class _ProfileSendState extends State<ProfileSend> with SingleTickerProviderStateMixin{
  BaseStatusModel statusModel;
  var _textController = new TextEditingController();
  var _scrollController = new ScrollController();
  bool talkFOT = false;
  bool otherFOT = false;
  FocusNode _focusNode;
  bool ifFocus=true;
  Animation animationTalk;
  AnimationController controller;
  VideoPlayerController _videoPlayerController;
  List<VideoPlayerController> _videoPlayerControllers=[];
  var cameras;
  List<Asset> images = List<Asset>();
  File _image;
  String _error;
  double finerCode=1;
  List<Asset> resultList;
  String error;
  Future<Null> init_cameras() async{
    cameras = await availableCameras();
  }
  double low=1.0;
  double high=150.0;
  String money='100';
  String _vedioPath;
  String _voiceName;
  File _vedio;
  String _voicePath;
  bool change=false;
  _ProfileSendState({this.statusModel}):super();
  bool loading=false;
  @override
  void initState() {
    init_cameras();
    _textController.addListener((){
      if(change){
        change=false;
        return ;
      }
      if(talkFOT&&_focusNode.hasFocus==false){
        if(!this.mounted){
          return;
        }
        setState(() {
          talkFOT=false;
        });
      }
    });
    controller = new AnimationController(duration: new Duration(seconds: 1), vsync: this);
    animationTalk = new Tween(begin: 1.0, end: 1.5).animate(controller)
      ..addStatusListener((state){
        if(state == AnimationStatus.completed) {
          controller.reverse();
        } else if (state == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    _focusNode=FocusNode();
    super.initState();

  }
  @override
  void dispose() {
    if(controller!=null){
      controller.dispose();
    }
    if(_textController!=null){
      _textController.dispose();
    }
    for(var _videoPlayerController in _videoPlayerControllers){
      if(_videoPlayerController!=null){
        _videoPlayerController.dispose();
      }
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context){
    final model = ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    return new Scaffold(
        appBar: AppBar(
          leading:IconButton(
              icon:Text('取消',style: TextStyle(color: FineritColor.color2_normal),),
              color: FineritColor.color1_normal,
              onPressed: (){
                Navigator.of(context).pop();
              }

          ),
          backgroundColor:Colors.white ,
          centerTitle: true,
          title:Text('发送团队通知',style: TextStyle(color: Colors.black87,fontSize: 18,fontWeight: FontWeight.w500)),
          actions: <Widget>[
            IconButton(
              icon:Text('发送',style: TextStyle(color: FineritColor.color2_normal),),
              color: FineritColor.color1_normal,
              onPressed: (){
                showGeneralDialog(
                  context: context,
                  pageBuilder: (context, a, b) => AlertDialog(
                    title: Text('提示',style: TextStyle(fontSize: 16),),
                    content: Container(
                      child:Text("每天可免费发送一次团队通告，所有一级队员都可以收到，多次发送每次扣除10个凡尔币"),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('取消'),
                        onPressed: () {
                          Navigator.pop(context);

                        },
                      ),
                      FlatButton(
                        child: Text('确认'),
                        onPressed: ()  {
                          _handle_send_message(model);
                        },
                      ),
                    ],
                  ),
                  barrierDismissible: false,
                  barrierLabel: '团队通知',
                  transitionDuration: Duration(milliseconds: 400),
                );
              },
            ),
          ],
        ),
        body:  GestureDetector(
          onTap: (){
            if(!this.mounted){
              return;
            }
            setState(() {
              FocusScope.of(context).requestFocus(FocusNode());
              talkFOT=false;
            });
          },
          child: new Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              child:
              new Stack(
                children: <Widget>[
                  Theme(
                      data: ThemeData(
                          primaryColor: Colors.white,
                          accentColor: Colors.white,
                          hintColor: Colors.white),
                      child: Container(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            TextField(
                              focusNode: _focusNode,
                              controller: _textController,
                              maxLines:8,
                              autofocus:true,
                              cursorColor:Colors.lightBlue,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                              ),
                            ),
                          ],
                        ),

                      )
                  ),
                  new Container(
                    padding: new EdgeInsets.only(bottom: 50.0,top: 100),
                    alignment: Alignment.center,
                    // width: MediaQuery.of(context).size.width - 40.0,
                    child: ListView(
                      controller: _scrollController,
                      children: <Widget>[ new FlatButton(
                          onPressed: null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              images.length!=0?AssertGridView(imageList: images,):Container(),
                              _image != null
                                  ? new Container(
                                alignment: Alignment.center,
                                width: 180.0,
                                height: 180.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(_image),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ):Container(),
                              _vedio!=null?Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(top: 5),
                                height: MediaQuery.of(context).size.height/1.6,
                                width: MediaQuery.of(context).size.width/1.3,
                                child: _get_vedio_wighet(),
                              ):Container(),
                            ],
                          )
                      ),],
                    ),
                  ),
                  new Positioned(
                    bottom: 0,
                    left:0,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                        decoration: new BoxDecoration(
                            boxShadow:[new BoxShadow(
                              color: Colors.black,
                              blurRadius: 5.0,
                            ),],
                            color: Colors.white,
                            border: Border(top: BorderSide(width: 0.3, color: Colors.black))
                        ),
                        child: new Column(
                          children: <Widget>[
                            new Offstage(
                              offstage: talkFOT,
                              child:  new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  IconButton(
                                    icon: new Icon(MyFlutterApp2.image, color: Color(0xFF707072)),
                                    onPressed: loadAssets,
                                  ),
                                  IconButton(
                                      icon: new Icon(MyFlutterApp2.camera, color: Color(0xFF707072)),
                                      onPressed: () {
                                        getImageByCamera();
                                      }
                                  ),

                                  new IconButton(
                                    icon: Icon(MyFlutterApp2.video, color: Color(0xFF707072)),
                                    onPressed: (){
                                      getVedio();
                                    },
                                  ),
                                  new IconButton(
                                    icon: Icon(MyFlutterApp2.jianpan, color: Color(0xFF707072)),
                                    onPressed: (){
                                      if(!this.mounted){
                                        return;
                                      }
                                      setState(() {
                                        if(ifFocus){
                                          FocusScope.of(context).requestFocus(FocusNode());
                                          ifFocus=!ifFocus;
                                        }
                                        else{
                                          FocusScope.of(context).requestFocus(_focusNode);
                                          ifFocus=!ifFocus;
                                        }
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                    ),
                  ),
                ],
              )
          ),
        )


    );
  }

  Widget _get_vedio_wighet(){
    if(Platform.isIOS){
      return  Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(top: 5),
        height: MediaQuery.of(context).size.height/1.6,
        width: MediaQuery.of(context).size.width/1.6 ,
        child: Chewie(
          _videoPlayerController,
          aspectRatio: MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,
          autoPlay: false,
          autoInitialize:true,
          looping: false,
        ),
      );
    }else if(Platform.isAndroid){
      return  Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(top: 5),
        height: MediaQuery.of(context).size.height/1.6,
        width: MediaQuery.of(context).size.width/1.3 ,
        child: Chewie(
          _videoPlayerController,
          aspectRatio: MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,
          autoPlay: false,
          autoInitialize:true,
          looping: false,

        ),
      );
    }
    else{
      return  Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(top: 5),
        height: MediaQuery.of(context).size.height/1.6,
        width: MediaQuery.of(context).size.width/1.3 ,
        child: Chewie(
          _videoPlayerController,
          aspectRatio: MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,
          autoPlay: false,
          autoInitialize:true,
          looping: false,

        ),
      );

    }


  }
  Future<List<String>> _get_image_paths() async {
    List<String> filesPath=[];
    for(Asset image in images){
      File file=await writeToFile(image.imageData,image.name);
      await NetUtil.putFile(file, (value){
        Map uploadInfo = json.decode(value);
        filesPath.add(uploadInfo["url"]);
      });
    }
    return filesPath;
  }
  Future<List<String>> _get_image_path() async{
    List<String> filesPath=[];
    if(_image!=null){
      await NetUtil.putFile(_image, (value){
        Map uploadInfo = json.decode(value);
        filesPath.add(uploadInfo["url"]);

      });
    }
    return filesPath;
  }
  Future<String> _get_vedio_path() async{
    if(_vedio!=null){
      await NetUtil.putFile(_vedio, (value){
        Map uploadInfo = json.decode(value);

        _vedioPath=uploadInfo["url"];
      });
    }
    return _vedioPath;
  }
  Future _handle_send_message(MainStateModel model) async {
    UserInfoModel userInfoModel=ScopedModel.of<MainStateModel>(context,rebuildOnChange: true);
    List<String> imagesPath=await _get_image_paths();
    if(_image!=null){
      imagesPath=await _get_image_path();
    }
    String vedio=await _get_vedio_path();
    NetUtil.post(Api.TEAM_MESSAGES, (data) async{
      requestToast("发布信息成功");
      Navigator.pop(context);
    },
        params: {
          "images": imagesPath,
          "text": _textController.text,
          "video": _vedioPath==null?[]:[_vedioPath],
        },
        headers: {"Authorization": "Token ${model.session_token}"},
        errorCallBack: (data){
          requestToast(HttpError.getErrorData(data).toString());
        }
    );
    Navigator.pop(context);

  }
  Future<File> writeToFile(ByteData data, String path) async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    final buffer = data.buffer;
    return new File(appDocDirectory.path+"/"+path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
  void  getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
  }
  void getVedio() async{
    _vedio =  await ImagePicker.pickVideo(source: ImageSource.gallery);
    _videoPlayerController=VideoPlayerController.file(_vedio);
    _videoPlayerControllers.add(_videoPlayerController);
    if(!this.mounted){
      return;
    }
    setState(() {
      _vedio=_vedio;
      _image=null;
      images=[];
    });
  }
  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        return AssetView(index, images[index]);
      }),
    );
  }

  Future<void> loadAssets() async {
    if(!this.mounted){
      return;
    }
    setState(() {
      images = List<Asset>();
    });
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 9,
        enableCamera: true,
        options: CupertinoOptions(takePhotoIcon: "chat"),
      );
    } on PlatformException catch (e) {
      error = e.message;
    }
    if (!mounted) return;
    setState(() {
      images = resultList;
      _image=null;
      _vedio=null;
      if (error == null) _error = 'No Error Dectected';
    });

  }
  void getImageByCamera() async{
    _image = await ImagePicker.pickImage(source: ImageSource.camera);
    if(_image!=null){
      if(!this.mounted){
        return;
      }
      setState(() {
        _image=_image;
        images=[];
        _vedio=null;
      });
    }
  }
}