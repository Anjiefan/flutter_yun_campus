
import 'package:finerit_app_flutter/apps/profile/components/profile_horizontal_divider_widget.dart';
import 'package:finerit_app_flutter/icons/icons_route4.dart';
import 'package:flutter/material.dart';
import 'components/message_headitems.dart';
import 'components/message_replayitems.dart';

class SystemMessage extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: Text("社区消息"),
          centerTitle: true,
        ),
        body:new Column(
          children: <Widget>[
            ReplayItems(),
            ReplayItems(),
            new Row(
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(left: 7,right: 7,bottom: 4,top: 4),
                  padding: EdgeInsets.only(top: 5,bottom: 7,left: 5,right: 5),
                  decoration: new BoxDecoration(
                    border: new Border.all(width: 1.0, color: Colors.black12),
                    color: Colors.white,
                    borderRadius: new BorderRadius.all(new Radius.circular(4.0)),
                  ),
                  height:  35,
                  width: MediaQuery.of(context).size.width*0.8,
                  child:TextField(
                    decoration: new InputDecoration.collapsed(
                      hintText: '回复用户【施爱港】',
                    ),
                    cursorColor:Colors.lightBlue,
                    style:TextStyle(color: Colors.black54),
                  ),

                ),
                new Expanded(child:
                new GestureDetector(
                    child: Container(
                      width: 80,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 0,right: 8),
                      padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom:5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.lightBlueAccent,
                      ),
                      child: Text("发送",style: TextStyle(color: Colors.white),),
                    ),
                    onTap: (){

                    }),
                )
              ],
            ),
          ],
        )
    );;
  }

}