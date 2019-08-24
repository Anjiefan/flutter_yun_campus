import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeFinerLogoWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Padding(
      padding: const EdgeInsets.all(0.0),
      child: Center(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          height: 120,
          width: 180,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage('assets/base/finer2.png'))),
        ),
      ),
    );
  }

}