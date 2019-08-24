
import 'package:finerit_app_flutter/apps/profile/state/profile_team_user_state.dart';
import 'package:flutter/cupertino.dart';

class ProfileFirstTab extends StatefulWidget {
  ProfileFirstTab({Key key}):super(key:key);
  @override
  State<StatefulWidget> createState() => ProfileFirstTabState();
}

class ProfileSecondTab extends StatefulWidget {
  ProfileSecondTab({Key key}):super(key:key);
  @override
  State<StatefulWidget> createState() => ProfileSecondTabState();
}

class ProfileFirstTabState extends TeamState<ProfileFirstTab>{
  String type='1';
}
class ProfileSecondTabState extends TeamState<ProfileFirstTab>{
  String type='2';
}