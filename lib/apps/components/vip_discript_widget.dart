

import 'package:finerit_app_flutter/apps/profile/components/proflie_svip_icon.dart';
import 'package:finerit_app_flutter/apps/profile/components/proflie_vip_icon.dart';
import 'package:flutter/material.dart';

class VipDiscriptWidget extends StatelessWidget{
  VipDiscriptWidget({this.levelDesignation,this.isOpening,this.isAnnual}):super();
  String levelDesignation;
  bool isAnnual;
  bool isOpening;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return levelDesignation!='0'?Container(
      margin: EdgeInsets.only(left: 1,top: 2),
      child: isAnnual==false?VipIcon(
        viplevel: levelDesignation
        ,iconsize: 0.6
        ,isOpen: isOpening,
      ):SVipIcon(viplevel: levelDesignation,iconsize: 0.6,),
    ):Container();
  }

}