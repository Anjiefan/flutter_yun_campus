//import 'package:finerit_app_flutter/style/themes.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//
//class GestureFocusWidget extends StatefulWidget {
//
//  Widget child;
//  GestureFocusWidget({Key key,this.child}):super(key:key);
//
//  @override
//  State<StatefulWidget> createState() {
//    // TODO: implement createState
//    return GestureFocusState(child: child,);
//  }
//
//}
//class GestureFocusState extends State<GestureFocusWidget>{
//  Widget child;
//  GestureFocusState({Key key,
//    this.child,
//  }):super();
//  @override
//  Widget build(BuildContext context) {
//    return GestureDetector(
//      onTap: (){
//        if(!this.mounted){
//          return;
//        }
//        setState(() {
//          FocusScope.of(context).requestFocus(FocusNode());
//        });
//      },
//      child: Container(
//        color: Colors.white,
//        child: child,
//      ),
//    );
//  }
//
//}