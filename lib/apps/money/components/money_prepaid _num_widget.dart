import 'package:finerit_app_flutter/commons/api.dart';
import 'package:finerit_app_flutter/commons/net_utils.dart';
import 'package:finerit_app_flutter/icons/icons_route.dart';
import 'package:finerit_app_flutter/models/base_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

class MoneyPrepaidNumWidget extends StatelessWidget {
  static const CHANNEL_PAYMENT_INVOKE =
  const MethodChannel("com.finerit.campus/payment/invoke");
  UserAuthModel userAuthModel;
  bool loading = false;
  int finerCode;
  MoneyPrepaidNumWidget({Key key,this.finerCode}):super();
  @override
  Widget build(BuildContext context) {
    int rmb=(finerCode/5).toInt();
    // TODO: implement build
    if (loading == false) {
      userAuthModel =
          ScopedModel.of<MainStateModel>(context, rebuildOnChange: true);
    }

    return new InkWell(
      onTap: () {
        NetUtil.post(
          Api.DJ_ORDERS,
              (data) {
            NetUtil.get(
              Api.DJ_ORDERS + data['id'].toString() + "/",
                  (data) {
                print(data);
                CHANNEL_PAYMENT_INVOKE
                    .invokeMethod("doAlipay",
                    [data['alipay_url']]);
              },
              headers: {
                "Authorization":
                "Token ${userAuthModel.session_token}"
              },
            );
          },
          params: {'finer_code': '${finerCode}'},
          headers: {
            "Authorization":
            "Token ${userAuthModel.session_token}"
          },
        );
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
                Radius.circular(10))),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  MyFlutterApp.money,
                  color: Colors.amber,
                ),
                Text(
                  "  ${finerCode}",
                  style:
                  TextStyle(fontSize: 16),
                ),
              ],
              mainAxisAlignment:
              MainAxisAlignment.center,
            ),
            Row(
              children: <Widget>[
                Text(
                  "  ${rmb}.0元",
                  style: TextStyle(
                      color: Colors.grey[500]),
                ),
              ],
              mainAxisAlignment:
              MainAxisAlignment.center,
            )
          ],
          mainAxisAlignment:
          MainAxisAlignment.spaceEvenly,
        ),
        height:
        MediaQuery.of(context).size.height *
            0.15,
        width:
        MediaQuery.of(context).size.width *
            0.25,
      ),
    );
  }
}
