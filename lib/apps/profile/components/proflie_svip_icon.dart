import 'package:flutter/material.dart';

class SVipIcon extends StatelessWidget{
  String viplevel = "0";
  double iconsize = 1;
  SVipIcon({@required this.viplevel,@required this.iconsize}):super();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 40*iconsize,
      height: 32*iconsize,
      child:
        Image(image: AssetImage("assets/profile/base/yearVip.png"),
          fit: BoxFit.fill,
      ),
    );
  }

}