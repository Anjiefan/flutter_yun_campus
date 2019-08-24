
import 'package:finerit_app_flutter/apps/profile/model/profile_model.dart';
import 'package:finerit_app_flutter/apps/profile/profile_userinfo_page.dart';
import 'package:finerit_app_flutter/beans/userinfo_brief_bean.dart';
import 'package:finerit_app_flutter/beans/userinfo_detail_bean.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactUserCard extends StatelessWidget{
  double height;
  UserInfoDetail user;
  VoidCallback callback;
  ContactUserCard({this.height,this.user,this.callback}):super();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          child:  SizedBox(
            height: height,
            child: ListTile(
              leading: GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(left: 0),
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: const Color(0xff7c94b6),
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    image: DecorationImage(
                      image: NetworkImage(user.headImg),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                onTap: (){
                  handle_to_profile_nav(user,context);
                },
              ),
              title: Text(user.nickName),
              onTap: () {
                if(callback==null){
                  handle_to_profile_nav(user,context);
                }
                else {
                  callback();
                }
              },
            ),

          ),
        ),
        Divider(height: 0.0, indent: 10, color: Colors.black12,)
      ],
    );
  }
  void handle_to_profile_nav(UserInfoDetail user,BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileUserPage(statusShouCangModel: StatusShouCangModel()
          ,statusSelfModel: StatusSelfModel(),user: user,),
      ),
    );
  }
}
