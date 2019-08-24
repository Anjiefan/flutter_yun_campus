import 'dart:io';

import 'package:finerit_app_flutter/apps/im/im_base.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future handle_im_go(BuildContext context, var from, var to,bool isFeedback) async {
  if (Platform.isAndroid) {
    var url =
        "https://im.finerit.com/#!/login/" + from + "~00" + "/" + to + "~00";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch ${url}';
    }
  }
  if (Platform.isIOS) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ImApp.name(from, to, isFeedback)));
  }
}
