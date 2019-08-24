import 'package:finerit_app_flutter/icons/FineritIcons.dart';
import 'package:finerit_app_flutter/icons/icons_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class WelcomePasswordTextFieldWidget extends StatefulWidget{
  TextEditingController controller;
  String text;
  IconData icon;
  int maxLength;
  WelcomePasswordTextFieldWidget({Key key,
    @required this.controller,
    @required this.text,
    @required this.icon,
    @required this.maxLength
  }):super(key:key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WelcomeTextFieldState(
        controller: controller
        ,text: text
        ,icon: icon
        ,maxLength: maxLength
        );
  }
}

class WelcomeTextFieldState extends State<WelcomePasswordTextFieldWidget>{
  TextEditingController controller;
  bool _obscureText = true;
  String text;
  IconData icon;
  int maxLength;
  WelcomeTextFieldState({Key key,
    @required this.controller,
    @required this.text,
    @required this.icon,
    @required this.maxLength
  }):super();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      margin: EdgeInsets.only(top: 50, right: 20,left: 10),
      height: 50,
      width: MediaQuery.of(context).size.width * 0.74,
      alignment: FractionalOffset.topLeft,
      child:
      new Theme(
        data: ThemeData(
            primaryColor: Colors.grey,
            accentColor: Colors.grey,
            hintColor: Colors.grey),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.text,
                cursorColor: Colors.grey,
                maxLines: 1,
                maxLength: maxLength,
                style: TextStyle(color: Colors.grey, fontSize: 20),
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: text,
                  hintStyle: new TextStyle(fontSize: 13),
                  icon: Icon(icon),
                  contentPadding: EdgeInsets.only(bottom: 3),
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
            ),
            GestureDetector(
              child: new Container(
                margin: EdgeInsets.only(top: 4,left: 12),
                width: 20,
                height: 20,
                child: _obscureText
                    ? Icon(
                  FineritIcons.eyeclose,
                  size: 16,
                  color: Colors.black54,
                )
                    : Icon(
                  FineritIcons.eyes,
                  size: 16,
                  color: Colors.black54,
                ),
              ),
              onTap: (){
                _showAndHidePassword();
              },
            )

          ],
        ),
      ),
    );
  }
  void _showAndHidePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}