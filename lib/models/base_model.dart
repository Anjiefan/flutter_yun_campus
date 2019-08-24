import 'dart:async';
import 'dart:convert';
import 'package:finerit_app_flutter/beans/Invite_data_list_bean.dart';
import 'package:finerit_app_flutter/beans/commuity_message_data_list_bean.dart';
import 'package:finerit_app_flutter/beans/community_message_data_bean.dart';
import 'package:finerit_app_flutter/beans/experience_data_bean.dart';
import 'package:finerit_app_flutter/beans/experience_data_list_bean.dart';
import 'package:finerit_app_flutter/beans/invite_data_bean.dart';
import 'package:finerit_app_flutter/beans/ranting_data_bean.dart';
import 'package:finerit_app_flutter/beans/ranting_data_list_bean.dart';
import 'package:finerit_app_flutter/beans/comment_data_bean.dart';
import 'package:finerit_app_flutter/beans/comment_data_list_bean.dart';
import 'package:finerit_app_flutter/beans/earn_code_data_bean.dart';
import 'package:finerit_app_flutter/beans/earn_code_list_bean.dart';
import 'package:finerit_app_flutter/beans/finercode_info_data_bean.dart';
import 'package:finerit_app_flutter/beans/finercode_info_list_bean.dart';
import 'package:finerit_app_flutter/beans/friend_data_bean.dart';
import 'package:finerit_app_flutter/beans/friend_data_list_bean.dart';
import 'package:finerit_app_flutter/beans/friend_request_data_bean.dart';
import 'package:finerit_app_flutter/beans/friend_request_data_list_bean.dart';
import 'package:finerit_app_flutter/beans/message_data_bean.dart';
import 'package:finerit_app_flutter/beans/message_data_list_bean.dart';
import 'package:finerit_app_flutter/beans/reply_comment_data.dart';
import 'package:finerit_app_flutter/beans/reply_comment_list_bean.dart';
import 'package:finerit_app_flutter/beans/shied_user_data_bean.dart';
import 'package:finerit_app_flutter/beans/shied_user_list_bean.dart';
import 'package:finerit_app_flutter/beans/status_data_bean.dart';
import 'package:finerit_app_flutter/beans/status_data_list_bean.dart';
import 'package:finerit_app_flutter/beans/team_info_data_list_bean.dart';
import 'package:finerit_app_flutter/beans/team_message_data_bean.dart';
import 'package:finerit_app_flutter/beans/tean_message_data_list_bean.dart';
import 'package:finerit_app_flutter/beans/userinfo_detail_bean.dart';
import 'package:finerit_app_flutter/beans/userinfo_detail_list_bean.dart';
import 'package:finerit_app_flutter/beans/vip_pay_info_bean.dart';
import 'package:finerit_app_flutter/commons/prefs_constant.dart';
import 'package:finerit_app_flutter/database/daos/message_data_dao.dart';
import 'package:finerit_app_flutter/database/models/message_data_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CommonPageStatus { READY, RUNNING, DONE, ERROR }

abstract class BaseModel extends Model {
  SharedPreferences prefs;
}

abstract class UserAuthModel extends BaseModel {
  bool _isLogin = false;
  bool _ifAgreeEULA=false;
  String _session_token;
  String _phone;
  String _objectId;
  String _password;
  bool _isFirst;
  bool _ifshowios=false;
  bool get ifAgreeEULA=> _ifAgreeEULA;

  set ifAgreeEULA(bool ifAgree){
    _saveAgreeEULA(ifAgree);
    _ifAgreeEULA=true;
  }
  bool get ifshowios=> _ifshowios;

  set ifshowios(bool ifAgree){
    _ifshowios=ifAgree;
  }
  set isFirst(bool isFirst){
    _saveIsFirst(isFirst);
    this._isFirst=isFirst;
  }
  CommonPageStatus _state = CommonPageStatus.READY;

  bool get isLogin => _isLogin;
  bool get isFirst=>prefs.get(Constant.IS_FIRST);
  String get session_token => _session_token;

  String get phone => _phone;

  String get objectId => _objectId;

  String get password => _password;

  CommonPageStatus get state => _state;

  set session_token(String session_token) {
    _saveToken(session_token);
    _session_token = session_token;
    notifyListeners();
  }
  Future<Null> _saveIsFirst(bool isFirst) async {
    prefs.setBool(Constant.IS_FIRST, isFirst);
  }
  Future<Null> _saveToken(String session_token) async {
    prefs.setString(Constant.SESSION_TOKEN, session_token);
  }
  Future<Null> _saveAgreeEULA(bool ifAgree) async {
    prefs.setBool(Constant.AGREE_EULA, ifAgree);
  }

  Future<Null> _savePassword(String password) async {
    prefs.setString(Constant.PASSWORD, password);
  }

  Future<Null> _saveObjectId(String objectId) async {
    prefs.setString(Constant.OBJECTID, objectId);
  }

  Future<Null> _savePhone(String phone) async {
    prefs.setString(Constant.PHONE, phone);
  }

  set password(String password) {
    _savePassword(password);
    _password = password;
    notifyListeners();
  }

  set objectId(String objectId) {
    _saveObjectId(objectId);
    _objectId = objectId;
    notifyListeners();
  }

  set phone(String phone) {
    _savePhone(phone);
    _phone = phone;
    notifyListeners();
  }

  initAuth() async {
    _session_token=prefs.getString(Constant.SESSION_TOKEN);
    if (_session_token != null && _session_token != "") {
      _isLogin = true;
    }
    _password = prefs.getString('password');
    _phone = prefs.getString('phone');
    _objectId = prefs.getString('objectId');
    _state = CommonPageStatus.RUNNING;
  }

  Future<Null> logout() async {
    bool is_read_licence=prefs.get('is_read_licence');
    prefs.clear();
    _saveIsFirst(false);
    _saveAgreeEULA(_ifAgreeEULA);

    prefs.setBool('is_read_licence', is_read_licence);
    _isLogin = false;
    _session_token = null;
    _phone = null;
    _objectId = null;
    _password = null;
    notifyListeners();
  }

  Future<Null> login(String session_token) async {

    _saveToken(session_token);
    _session_token = session_token;
    _ifAgreeEULA=prefs.getBool(Constant.AGREE_EULA);
    _isLogin = true;
    notifyListeners();
  }
}

abstract class UserInfoModel extends BaseModel  {
  UserInfoDetail _userInfo;

  UserInfoDetail get userInfo => _userInfo;

  set userInfo(UserInfoDetail userInfo) {
    _saveUserInfo(userInfo);
    _userInfo = userInfo;
    notifyListeners();
  }

  Future<Null> _saveUserInfo(UserInfoDetail userInfo) async {
    prefs.setString(Constant.USER_INFO, json.encode(userInfo));
  }

  initUserInfo() {
    var jsonStr = prefs.getString(Constant.USER_INFO);
    if(jsonStr!=null){
      _userInfo = UserInfoDetail.fromJson(json.decode(jsonStr));
    }
  }
}

abstract class BaseStatusModel extends Model {
  StatusDataList _StatusDataList = new StatusDataList();

  List<StatusData> getData() {
    return _StatusDataList.data;
  }

  void setData(List<StatusData> bbsItemList) {
    _StatusDataList.data = bbsItemList;
    notifyListeners();
  }

  addAll(List<StatusData> bbsItemList) {
    _StatusDataList.data.addAll(bbsItemList);
    notifyListeners();
  }

  update(StatusData data, int index) {
    _StatusDataList.data[index] = data;
    notifyListeners();
  }

  addBegin(StatusData element) {
    if (_StatusDataList.data != null) {
      _StatusDataList.data.insert(0, element);
      notifyListeners();
    }
  }

  removeByIndex(int index){
    _StatusDataList.data.removeAt(index);
    notifyListeners();
  }

  bool _initData = false;

  set initData(bool b) {
    _initData = b;
  }

  get initData => _initData;
}
abstract class PushMessageModel extends BaseModel {
  int _profile=0;//0或者1，表示有无消息
  int _message=0;//0或者1，表示有无消息
  int _friend=0;//0或者1，表示有无消息
  int _addFriendNum=0;//记录具体消息条数
  int _ranking=0;
  int get ranking => _ranking;
  int get friend => _friend;
  int get message => _message;
  int get profile => _profile;
  int get addFriendNum => _addFriendNum;
  void _saveProfile(int num){
    prefs.setInt("profile", num);
  }
  void _saveRanking(int num){
    prefs.setInt("ranking", num);
  }
  void _saveMessage(int num){
    prefs.setInt("message", num);
  }

  void _saveAddFriend(int num){
    prefs.setInt("friend", num);
  }
  void _saveAddFriendNum(int num){
    prefs.setInt("addFriendNum", num);
  }
  set profile(int num){
    _saveProfile(num);
    _profile=num;
    notifyListeners();
  }
  set friend(int num) {
    _saveAddFriend(num);
    _friend = num;
    notifyListeners();
  }
  set ranking(int num) {
    _saveRanking(num);
    _ranking = num;
    notifyListeners();
  }
  set message(int num) {
    _saveMessage(num);
    _message = num;
    notifyListeners();
  }
  set addFriendNum(int num) {
    _saveAddFriendNum(num);
    _addFriendNum = num;
    notifyListeners();
  }
  initCount() {
    _addFriendNum = prefs.getInt("addFriendNum") == null
        ? 0
        : prefs.getInt("addFriendNum");
    _message = prefs.getInt("message") == null
        ? 0
        : prefs.getInt("message");
    _ranking = prefs.getInt("ranking") == null
        ? 0
        : prefs.getInt("ranking");
    _friend = prefs.getInt("friend") == null
        ? 0
        : prefs.getInt("friend");
    _profile = prefs.getInt("profile") == null
        ? 0
        : prefs.getInt("profile");
  }
}
abstract class BaseMoneyPaymentInfoModel extends Model {
  FinerCodeInfoList _paymentInfoList = new FinerCodeInfoList();

  List<FinerCodeInfoData> getData() {
    return _paymentInfoList.data;
  }
  double _income = 0.0;
  double _outcome = 0.0;

  set income(double _income){
    _income = _paymentInfoList.income;
  }

  get income => _income;

  set outcome(double _outcome){
    _outcome = _paymentInfoList.outcome;
  }

  get outcome => _outcome;

  void getIncome(){
    _income = _paymentInfoList.income;
  }

  void setData(List<FinerCodeInfoData> paymentInfoList) {
    _paymentInfoList.data = paymentInfoList;
    notifyListeners();
  }

  addAll(List<FinerCodeInfoData> paymentInfoList) {
    _paymentInfoList.data.addAll(paymentInfoList);
    notifyListeners();
  }

  update(FinerCodeInfoData data, int index) {
    _paymentInfoList.data[index] = data;
    notifyListeners();
  }

  addBegin(FinerCodeInfoData element) {
    _paymentInfoList.data.insert(0, element);
    notifyListeners();
  }

  bool _initData = false;

  set initData(bool b) {
    _initData = b;
  }

  get initData => _initData;
}

abstract class BaseEarnModel extends Model {
  EarnCodeList _earnList = new EarnCodeList();

  List<EarnCodeData> getData() {
    return _earnList.data;
  }
  double _income = 0.0;

  set income(double _income){
    _income = _earnList.income;
  }

  get income => _income;


  void getIncome(){
    _income = _earnList.income;
  }

  void setData(List<EarnCodeData> earnList) {
    _earnList.data = earnList;
    notifyListeners();
  }

  addAll(List<EarnCodeData> earnList) {
    _earnList.data.addAll(earnList);
    notifyListeners();
  }

  update(EarnCodeData data, int index) {
    _earnList.data[index] = data;
    notifyListeners();
  }

  addBegin(EarnCodeData element) {
    _earnList.data.insert(0, element);
    notifyListeners();
  }

  bool _initData = false;

  set initData(bool b) {
    _initData = b;
  }

  get initData => _initData;
}

abstract class BaseCommentModel extends Model {
  CommentList _commentList = new CommentList();

  List<CommentData> get commentList => _commentList.data ?? [];

  set commentList(List<CommentData> dataComment) {
    _commentList.data = dataComment;
    notifyListeners();
  }

  addAllComments(List<CommentData> dataComment) {
    _commentList.data.addAll(dataComment);
    notifyListeners();
  }

  addBeginComment(CommentData element) {
    _commentList.data.insert(0, element);
    notifyListeners();
  }

  updateComment(CommentData data, int index) {
    _commentList.data[index] = data;
    notifyListeners();
  }
  updateCommentById(CommentData data){
    for(int i=0;i<_commentList.data.length;i++){
      if(_commentList.data[i].id==data.id){
        _commentList.data[i]=data;
      }
    }
    notifyListeners();
  }
  removeCommentByIndex(int index){
    _commentList.data.removeAt(index);
    notifyListeners();
  }
}

abstract class BaseReplyComment extends Model {
  ReplyCommentList _relayCommentList = new ReplyCommentList();

  List<ReplyCommentData> get relayCommentList => _relayCommentList.data ?? [];

  set commentList(List<ReplyCommentData> dataComment) {
    _relayCommentList.data = dataComment;
    notifyListeners();
  }

  addAllComments(List<ReplyCommentData> dataComment) {
    _relayCommentList.data.addAll(dataComment);
    notifyListeners();
  }

  addBeginComment(ReplyCommentData element) {
    _relayCommentList.data.insert(0, element);
    notifyListeners();
  }

  updateComment(ReplyCommentData data, int index) {
    _relayCommentList.data[index] = data;
    notifyListeners();
  }
  removeCommentByIndex(int index){
    _relayCommentList.data.removeAt(index);
    notifyListeners();
  }
}

abstract class FriendRequestBaseModel extends Model{
  FriendRequestDataList _friendRequestList = new FriendRequestDataList();

  List<FriendRequestData> get friendRequestList => _friendRequestList.data ?? [];

  set friendRequestList(List<FriendRequestData> dataRequest) {
    _friendRequestList.data = dataRequest;
    notifyListeners();
  }

  addAllRequests(List<FriendRequestData> dataRequest) {
    _friendRequestList.data.addAll(dataRequest);
    notifyListeners();
  }

  addBeginRequest(FriendRequestData element) {
    _friendRequestList.data.insert(0, element);
    notifyListeners();
  }

  updateRequest(FriendRequestData data, int index) {
    _friendRequestList.data[index] = data;
    notifyListeners();
  }
  removeRequestByIndex(int index){
    _friendRequestList.data.removeAt(index);
    notifyListeners();
  }
}

abstract class FriendBaseModel extends Model{
  FriendDataList _friendList = new FriendDataList();

  List<FriendData> get friendList => _friendList.data ?? [];

  set friendList(List<FriendData> data) {
    _friendList.data = data;
    notifyListeners();
  }

  addFriendAlls(List<FriendData> data) {
    _friendList.data.addAll(data);
    notifyListeners();
  }

  addFriendBegin(FriendData element) {
    _friendList.data.insert(0, element);
    notifyListeners();
  }

  updateFriend(FriendData data, int index) {
    _friendList.data[index] = data;
    notifyListeners();
  }
  removeFriendByIndex(int index){
    _friendList.data.removeAt(index);
    notifyListeners();
  }
}

abstract class UserInfoListBaseModel extends Model{
  UserInfoDetailList _userinfoList = new UserInfoDetailList();

  List<UserInfoDetail> get userinfoList => _userinfoList.data ?? [];

  set userinfoList(List<UserInfoDetail> data) {
    _userinfoList.data = data;
    notifyListeners();
  }

  addUserAlls(List<UserInfoDetail> data) {
    _userinfoList.data.addAll(data);
    notifyListeners();
  }

  addUserBegin(UserInfoDetail element) {
    _userinfoList.data.insert(0, element);
    notifyListeners();
  }

  updateUser(UserInfoDetail data, int index) {
    _userinfoList.data[index] = data;
    notifyListeners();
  }
  removeUserByIndex(int index){
    _userinfoList.data.removeAt(index);
    notifyListeners();
  }
}

abstract class ShieldUserBaseModel extends Model{
  ShieldUserDataList _shieldUserList = new ShieldUserDataList();

  List<ShieldUserData> get shieldUserList => _shieldUserList.data ?? [];

  set shieldUserList(List<ShieldUserData> data) {
    _shieldUserList.data = data;
    notifyListeners();
  }

  addShieldUserAlls(List<ShieldUserData> data) {
    _shieldUserList.data.addAll(data);
    notifyListeners();
  }

  addShieldUserBegin(ShieldUserData element) {
    _shieldUserList.data.insert(0, element);
    notifyListeners();
  }

  updateShieldUser(ShieldUserData data, int index) {
    _shieldUserList.data[index] = data;
    notifyListeners();
  }
  removeShieldUserByIndex(int index){
    _shieldUserList.data.removeAt(index);
    notifyListeners();
  }
}

abstract class RantingBaseModel extends Model{
  RantingDataList _rantingDataList = new RantingDataList();

  List<RantingData> get rantingDataList => _rantingDataList.data ?? [];

  set rantingDataList(List<RantingData> data) {
    _rantingDataList.data = data;
    notifyListeners();
  }

  addRantingAlls(List<RantingData> data) {
    _rantingDataList.data.addAll(data);
    notifyListeners();
  }

  addRantingBegin(RantingData element) {
    _rantingDataList.data.insert(0, element);
    notifyListeners();
  }

  updateRanting(RantingData data, int index) {
    _rantingDataList.data[index] = data;
    notifyListeners();
  }
  removeRantingByIndex(int index){
    _rantingDataList.data.removeAt(index);
    notifyListeners();
  }
}
abstract class InviteBaseModel extends Model{
  InviteDataList _inviteDataList = new InviteDataList();

  List<InviteData> get inviteDataList => _inviteDataList.data ?? [];

  set inviteDataList(List<InviteData> data) {
    _inviteDataList.data = data;
    notifyListeners();
  }

  addInviteDataAlls(List<InviteData> data) {
    _inviteDataList.data.addAll(data);
    notifyListeners();
  }

  addInviteDataBegin(InviteData element) {
    _inviteDataList.data.insert(0, element);
    notifyListeners();
  }

  updateInviteData(InviteData data, int index) {
    _inviteDataList.data[index] = data;
    notifyListeners();
  }
  removeInviteDataByIndex(int index){
    _inviteDataList.data.removeAt(index);
    notifyListeners();
  }
}

abstract class CommunityMessageBaseModel extends Model{
  CommunityMessageDataList _communityMessageDataList = new CommunityMessageDataList();

  List<CommunityMessageData> get communityMessageDataList => _communityMessageDataList.data ?? [];

  set communityMessageDataList(List<CommunityMessageData> data) {
    _communityMessageDataList.data = data;
    notifyListeners();
  }

  addCommunityMessageDataAlls(List<CommunityMessageData> data) {
    _communityMessageDataList.data.addAll(data);
    notifyListeners();
  }

  addCommunityMessageDataBegin(CommunityMessageData element) {
    _communityMessageDataList.data.insert(0, element);
    notifyListeners();
  }

  updateCommunityMessageData(CommunityMessageData data, int index) {
    _communityMessageDataList.data[index] = data;
    notifyListeners();
  }
  removeCommunityMessageDataByIndex(int index){
    _communityMessageDataList.data.removeAt(index);
    notifyListeners();
  }
}

abstract class TeamBaseModel extends Model{
  TeamInfo _teamInfo;
  TeamInfo get teamInfo => _teamInfo;
  set teamInfo(TeamInfo data) {
    _teamInfo = data;
    notifyListeners();
  }
}
abstract class VipPayBaseModel extends Model{
  VipPayInfo _vipPayInfo;
  VipPayInfo get vipPayInfo => _vipPayInfo;
  set vipPayInfo(VipPayInfo data) {
    _vipPayInfo = data;
    notifyListeners();
  }
}
abstract class MessageBaseModel extends BaseModel{
  MessageDataList _messagedataList = new MessageDataList();

  List<MessageData> get messagedataList => _messagedataList.data ?? [];

  set messagedataList(List<MessageData> data) {
    var modelList = MessageDataDAO.dao.convertBeanToModelAll(data);
    insertAllDataAsync(modelList);
  }

//  addMessageAlls(List<MessageData> data) {
//    _messagedataList.data.addAll(data);
//    var modelList = MessageDataDAO.dao.convertBeanToModelAll(data);
//    insertAllDataAsync(modelList);
//  }

  addMessageBegin(MessageData element) {
    var model = MessageDataDAO.dao.convertBeanToModel(element);
    insertDataAsync(model);
  }

  updateMessage(MessageData data, int index) {
    var model = MessageDataDAO.dao.convertBeanToModel(data);
    updateDataAsync(model, index, data);
  }

//  removeMessageByIndex(int index){
//    deleteDataAsync(index);
//  }

//  deleteDataAsync(int index) {
//    MessageDataDAO.dao.deleteById(_messagedataList.data[index].id).then((value){
//      MessageDataDAO.dao.getAll().then((value2){
//        _messagedataList.data = MessageDataDAO.dao.convertModelToBeanAll(value2);
//        notifyListeners();
//      });
//    });
//  }

  insertAllDataAsync(List<MessageDataModel> modelList){
    MessageDataDAO.dao.insertAll(modelList).then((value){
      MessageDataDAO.dao.getAll({'is_show':1,'user_id':prefs.getString('objectId')}).then((value2){
        _messagedataList.data = MessageDataDAO.dao.convertModelToBeanAll(value2);
        notifyListeners();
      });
    });
  }

  insertDataAsync(MessageDataModel model){
    MessageDataDAO.dao.insert(model).then((value){
      MessageDataDAO.dao.getAll({'is_show':1,'user_id':prefs.getString('objectId')}).then((value2){
        _messagedataList.data = MessageDataDAO.dao.convertModelToBeanAll(value2);
        notifyListeners();
      });
    });
  }

  updateDataAsync(MessageDataModel model, index, data){
    MessageDataDAO.dao.update(model).then((value){
      MessageDataDAO.dao.getAll({'is_show':1,'user_id':prefs.getString('objectId')}).then((value){
        _messagedataList.data = MessageDataDAO.dao.convertModelToBeanAll(value);
        notifyListeners();
         value.forEach((v){
          print(v.toMap().toString());
        });
        _messagedataList.data.forEach((v){
          print("mem," + v.toJson().toString());
        });
      });
    });
  }

}

abstract class EarnSumInfoBaseMode extends BaseModel{
  double _month_sum=0.0;
  double _day_sum=0.0;
  double _yesterday_sum=0.0;
  double get month_sum=>_month_sum;
  double get day_sum=>_day_sum;
  double get yesterday_sum=>_yesterday_sum;
  void setEarnSumData(double yesterday_sum,double day_sum,double month_sum){
    _yesterday_sum=yesterday_sum;
    _day_sum=day_sum;
    _month_sum=month_sum;
    notifyListeners();
  }
}
abstract class ExperienceBaseModel extends Model{
  ExperienceDataList _experienceDataList = new ExperienceDataList();

  List<ExperienceData> get experienceDataList => _experienceDataList.data ?? [];

  set experienceDataList(List<ExperienceData> data) {
    _experienceDataList.data = data;
    notifyListeners();
  }

  addExperienceDataAlls(List<ExperienceData> data) {
    _experienceDataList.data.addAll(data);
    notifyListeners();
  }

  addExperienceDataBegin(ExperienceData element) {
    _experienceDataList.data.insert(0, element);
    notifyListeners();
  }

  updateExperienceData(ExperienceData data, int index) {
    _experienceDataList.data[index] = data;
    notifyListeners();
  }
  removeExperienceDataByIndex(int index){
    _experienceDataList.data.removeAt(index);
    notifyListeners();
  }
}

abstract class TeamMessageBaseModel extends Model{
  TeamMessageDataList _teamMessageDataList = new TeamMessageDataList();

  List<TeamMessageData> get teamMessageDataList => _teamMessageDataList.data ?? [];

  set teamMessageDataList(List<TeamMessageData> data) {
    _teamMessageDataList.data = data;
    notifyListeners();
  }

  addTeamMessageDataAlls(List<TeamMessageData> data) {
    _teamMessageDataList.data.addAll(data);
    notifyListeners();
  }

  addTeamMessageDataBegin(TeamMessageData element) {
    _teamMessageDataList.data.insert(0, element);
    notifyListeners();
  }

  updateTeamMessageData(TeamMessageData data, int index) {
    _teamMessageDataList.data[index] = data;
    notifyListeners();
  }
  removeTeamMessageDataByIndex(int index){
    _teamMessageDataList.data.removeAt(index);
    notifyListeners();
  }
}
class MainStateModel extends Model
    with
        BaseModel,
        UserAuthModel,
        UserInfoModel,
        PushMessageModel,
        ShieldUserBaseModel,
        MessageBaseModel,
        RantingBaseModel,
        TeamBaseModel,
        VipPayBaseModel,
        CommunityMessageBaseModel,
        EarnSumInfoBaseMode,
        ExperienceBaseModel,
        TeamMessageBaseModel
{
  MainStateModel(SharedPreferences _prefs) {
    prefs=_prefs;
    initAuth();
    initUserInfo();
    initCount();
  }
}
