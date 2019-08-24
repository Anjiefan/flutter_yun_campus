import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class WelcomeTextFieldWidget extends StatefulWidget{
  TextEditingController controller;
  String text;
  IconData icon;
  int maxLength;
  Function changeCallback;
  WelcomeTextFieldWidget({Key key,
    this.controller,
    @required this.text,
    @required this.icon,
    @required this.maxLength,
    this.changeCallback
  }):super(key:key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WelcomeTextFieldState(
      controller: controller
      ,text: text
      ,icon: icon
      ,maxLength: maxLength
    ,changeCallback: changeCallback);
  }
}

class WelcomeTextFieldState extends State<WelcomeTextFieldWidget>{
  TextEditingController controller;
  Function changeCallback;
  String text;
  IconData icon;
  int maxLength;
  WelcomeTextFieldState({Key key,
    this.controller,
    @required this.text,
    @required this.icon,
    @required this.maxLength,
    this.changeCallback
  }):super();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
        margin: EdgeInsets.only(top: 50, right: 20, left: 10),
        height: 50,
        width: MediaQuery.of(context).size.width * 0.7,
        alignment: FractionalOffset.topLeft,
        child: new Theme(
          data: ThemeData(
              primaryColor: Colors.grey,
              accentColor: Colors.grey,
              hintColor: Colors.grey),
          child:
          TextField(
            onChanged:changeCallback,
            controller: controller,
            keyboardType: TextInputType.number,
            cursorColor: Colors.grey,
            maxLines: 1,
            maxLength: maxLength,
            cursorWidth:1,
            style: TextStyle(color: Colors.grey, fontSize: 20),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(3),
              hintText:text,
              hintStyle: TextStyle(fontSize: 13),
              icon: Icon(icon),
              errorBorder:UnderlineInputBorder(
                borderSide:
                BorderSide( width: 0.5,color: Colors.black26),

              ),
              disabledBorder:UnderlineInputBorder(
                borderSide:
                BorderSide( width: 0.5,color: Colors.black26),

              ),
              enabledBorder:UnderlineInputBorder(
                borderSide:
                BorderSide( width: 0.5,color: Colors.black26),

              ),
              focusedBorder:UnderlineInputBorder(
                borderSide:
                BorderSide( width: 0.8,color: Colors.black26),

              ),
              border:UnderlineInputBorder(
                borderSide:
                BorderSide(width: 0.5,color: Colors.black26),

              ),
            ),
          ),
        )
    );
  }

}

