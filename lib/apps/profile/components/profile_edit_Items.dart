import 'package:flutter/material.dart';

class EditItems extends StatelessWidget{

  String text = "";
  bool headimg = false;
  ImageProvider imageProvider;
  String nickname;
  EditItems({@required this.text,@required this.headimg,this.imageProvider,this.nickname}):super();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return headimg?
    new Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 4),
      padding: EdgeInsets.only(left: 8,top: 10,bottom: 10,right: 4),
      child: Row(
        children: <Widget>[
          Text(this.text,),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: imageProvider,
                  radius: 10,
                ),
                Container(width: 2,),
                Icon(
                  Icons.keyboard_arrow_right,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    ):new Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 4),
      padding: EdgeInsets.only(left: 8,top: 12,bottom: 13,right: 4),
      child: Row(
        children: <Widget>[
          Text(this.text,),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: Text(nickname,style: TextStyle(color: Colors.black54),),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }

}
