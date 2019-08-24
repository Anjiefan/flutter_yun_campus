import 'package:flutter/material.dart';

class HorizontalDivider extends StatelessWidget{
  @override
  double width = -1;
  HorizontalDivider({Key key,@required this.width,}): super(key: key);
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
        margin: EdgeInsets.only(top: 0),
        width: width==-1?MediaQuery.of(context).size.width:width,
        child: Divider(
          color: Colors.grey,
        )
    );
  }

}