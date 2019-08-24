import 'package:flutter/material.dart';

class BBSCardIconWidget extends StatelessWidget{
  IconData icon;
  var number;
  double iconSize;

  BBSCardIconWidget({Key key,this.icon,this.iconSize,this.number}):super();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(

        child: new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(this.icon, size: iconSize, color: Colors.black54,),
            Container(
              margin: EdgeInsets.only(left: 2,right: 4),
              child:Text(this.number.toString(),style: TextStyle(fontSize: 12.5,color: Colors.black54,fontWeight: FontWeight.w300),
              ),
            ),
          ],
        )
    );
  }
}