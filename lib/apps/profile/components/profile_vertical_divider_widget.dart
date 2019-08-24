import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileVerticalDividerWidget extends StatelessWidget{
  @override
  double height;
  ProfileVerticalDividerWidget({Key key,@required this.height,}): super(key: key);
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
        margin: EdgeInsets.only(top: 0),
        height: height,
        child: VerticalDivider(
          color: Colors.grey,
        )
    );
  }

}