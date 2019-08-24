import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GlobalMessagePoint extends StatelessWidget{
  double width;
  double height;
  int num;
  GlobalMessagePoint({this.width=28
    ,this.height=14
    ,this.num=0}):super();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: num!=0?Center(child: Text((num) > 99?"99+" :
      (num).toString(), style: TextStyle(color: Colors.white, fontSize: 10),)):Container(),
      decoration: BoxDecoration(
          color: Color(0xff00c0ff),
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      width: width,
      height: height,
    );
  }

}