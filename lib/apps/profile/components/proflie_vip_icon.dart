import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class VipIcon extends StatelessWidget{
  String viplevel = "0";
  double iconsize = 1;
  double _fontsizeauto = 14;
  bool isOpen;
  UserInfoModel userInfoModel;
  VipIcon({@required this.viplevel,@required this.iconsize,@required this.isOpen}):super();
  @override
  Widget build(BuildContext context) {
    if(double.parse(viplevel)>=10){
      _fontsizeauto=12;
    }
    return viplevel!='0'?Container(
      alignment: Alignment(0.1, -0.35),
      width: 40*iconsize,
      height: 32*iconsize,
      child: Text(
        "v"+viplevel,
        style: TextStyle(color: Colors.white, fontSize: _fontsizeauto*iconsize,),
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: isOpen==false?AssetImage("assets/profile/base/vipiconnone.png"):AssetImage("assets/profile/base/vipicon.png"),
          fit: BoxFit.fill,
        ),
      ),
    ):Row(
      children: <Widget>[
        Container(
            child: Text(
              "未开通",
              style: TextStyle(color: Colors.white, fontSize: _fontsizeauto*iconsize/2,),
            ),
            alignment: Alignment(0.1, -0.35),
            width: 40*iconsize,
            height: 32*iconsize,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: isOpen==false?AssetImage("assets/profile/base/vipiconnone.png"):AssetImage("assets/profile/base/vipicon.png"),
                fit: BoxFit.fill,
              ),
            )
        ),
        Text("前往开通", style: TextStyle(color: Colors.black87, fontSize: 10,),),
        Icon(Icons.arrow_right,size: 16,color: Colors.black87,)
      ],
    );
  }

}