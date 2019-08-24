import 'package:finerit_app_flutter/commons/dicts.dart';
import 'package:finerit_app_flutter/icons/FineritIcons.dart';
import 'package:flutter/material.dart';

class LevelIcon extends StatelessWidget{
  String level;
  double iconsize = 1;
  String biglevel;
  Color color = Colors.lightBlue;
  LevelIcon({@required this.level,@required this.iconsize,this.color,this.biglevel}):super();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: new Row(
        children: <Widget>[
          new Icon(
            Dicts.LEVEL_IMAGES[biglevel],
            size: 13*iconsize,
            color: this.color,
          ),
          Container(width: 1,),
          new Text(this.level,style: TextStyle(color: this.color,fontSize: 11*iconsize,fontWeight: FontWeight.w300),),
        ],
      ),
    );
  }

}