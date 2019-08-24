import 'package:finerit_app_flutter/commons/toast.dart';
import 'package:flutter/material.dart';


class BBSBottonCommentWidget extends StatefulWidget{
  VoidCallback commentCallBack;
  TextEditingController controller;
  bool comment=false;
  BBSBottonCommentWidget({Key key
    ,this.commentCallBack
    ,this.controller
    ,this.comment=false
  }):super(key:key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return BBSBottonCommentState(commentCallBack: this.commentCallBack
      ,comment: this.comment
      ,controller: this.controller);
  }

}


class BBSBottonCommentState extends State<BBSBottonCommentWidget>{
  VoidCallback commentCallBack;
  BBSBottonCommentState({this.commentCallBack
    ,this.controller
    ,this.comment}):super();
  TextEditingController controller ;
  bool comment=false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return new Positioned(
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
          child:Column(
            children: <Widget>[
              new Offstage(
                  offstage: comment,
                  child: Container(
                    height: 30,
                    margin: EdgeInsets.all(2),
                    decoration: new BoxDecoration(
                      border: new Border.all(width: 2.0, color: Colors.black12),
                      color: Colors.white,
                      borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                    ),
                    child: FlatButton(
                        onPressed: (){
                          if(!this.mounted){
                            return;
                          }
                          setState(() {
                            comment=true;
                          });
                        },
                        child:Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text('开始评论',style: TextStyle(color: Colors.black12),textAlign: TextAlign.left,),
                        )
                    ),
                  )
              ),
              new Offstage(
                  offstage: !comment,
                  child:
                  new Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          new Theme(
                            data: ThemeData(
                              hintColor: Colors.black12,
                            ),
                            child:
                            new Container(
                              margin: EdgeInsets.all(8),
                              decoration: new BoxDecoration(
                                border: new Border.all(width: 2.0, color: Colors.black12),
                                color: Colors.white,
                                borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                              ),
                              height: 80,
                              width: MediaQuery.of(context).size.width*0.8,
                              child:TextField(
                                controller: controller,
                                autofocus: false,
                                decoration: new InputDecoration.collapsed(
                                  hintText: '开始评论...',
                                ),
                                cursorColor:Colors.black54,
                                style:TextStyle(color: Colors.black54),
                              ),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                child: IconButton(icon: Icon(Icons.crop_free,color: Colors.black12,), onPressed: (){
                                  requestToast("图片评论，语音评论，更多功能，2.0版本带给大家哦～");
                                }),
                              ),
                              Container(
                                child: IconButton(icon: Icon(Icons.arrow_forward,color: Colors.black12,)
                                    , onPressed: (){
                                  if(widget.commentCallBack!=null){
                                    widget.commentCallBack();
                                  }
                                }),
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[],
                      )
                    ],
                  )
              ),

            ],
          )
      ),
    );
  }

}