import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeDescribeWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Divider(
          height: 2,
        ),
        Row(
          children: <Widget>[
            new Container(
              width:20,
              height: 1,
              decoration: new BoxDecoration(
                gradient:  LinearGradient(
                  colors: [Colors.white,Colors.tealAccent,Colors.lightBlueAccent],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
//            Image.asset(
//              'assets/base/right.png',
//              width: 20,
//              height: 15,
//            ),
            new Container(
              margin: EdgeInsets.only(left: 0,right: 0),
              padding: EdgeInsets.only(top: 1,left: 6,right: 6,bottom: 1),
//              decoration: new BoxDecoration(
//                  gradient:  LinearGradient(
//                    colors: [Colors.lightBlueAccent, Colors.tealAccent],
//                  ),
//                  borderRadius: BorderRadius.circular(20),
//              ),
              child: Text(
                " 云端下的智慧校园 ",
                style: TextStyle(fontSize: 16,color: Colors.lightBlueAccent,fontWeight: FontWeight.w100),
              ),
            ),
//            Image.asset(
//              'assets/base/left.png',
//              width: 20,
//              height: 15,
//            ),
            new Container(
              width:20,
              height: 1,
              decoration: new BoxDecoration(
                gradient:  LinearGradient(
                  colors: [Colors.lightBlueAccent, Colors.tealAccent,Colors.white],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ],
        ),
        Divider(
          height: 2,
        )
      ],
    );
  }

}