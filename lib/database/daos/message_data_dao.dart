import 'dart:async';
import 'dart:convert';

import 'package:finerit_app_flutter/beans/message_data_bean.dart';
import 'package:finerit_app_flutter/beans/userinfo_brief_bean.dart';
import 'package:finerit_app_flutter/database/base_dao.dart';
import 'package:finerit_app_flutter/database/database.dart';
import 'package:finerit_app_flutter/database/models/message_data_model.dart';

class MessageDataDAO extends BaseDAO<MessageData, MessageDataModel> {
  MessageDataDAO._();

  static final MessageDataDAO dao = MessageDataDAO._();

  @override
  Future<int> deleteById(int id) async {
    var raw = await DBProvider.db.delete("messagedata", id);
    return raw;
  }

  @override
  Future<List<MessageDataModel>> getAll(Map map) async {
    List where_args=[];
    map.forEach((k,v){
      where_args.add(k.toString()+"='"+v.toString()+"'");
    });
    String where=where_args.join(' and ');
    List<Map<String, dynamic>> list1 = await DBProvider.db.getAll(
        "select * from messagedata order by is_top desc, date(update_date) desc");
    var rawList1 = list1.map((d) => (MessageDataModel.fromMap(d))).toList();
    List<Map<String, dynamic>> list = await DBProvider.db.getAll(
        "select * from messagedata where  $where  order by is_top desc, date(update_date) desc");
    var rawList = list.map((d) => (MessageDataModel.fromMap(d))).toList();
    return rawList;
  }

  @override
  Future<MessageDataModel> getById(int id) async {
    var mapData = await DBProvider.db.getById("messagedata", id);
    if (mapData == null) {
      return null;
    }
    var model = MessageDataModel.fromMap(mapData);
    return model;
  }

  @override
  Future insert(MessageDataModel model) async {
    var checkModel = await MessageDataDAO.dao.getById(model.id);
    if (checkModel != null) {
      return await update(model);
    } else {
      return await DBProvider.db.insert(
          "insert into messagedata "
          "(id,"
          "relate_user, "
          "info,"
          "is_show,"
          "is_top,"
          "type,"
          "push_date,"
          "update_date,"
              "info_num,"
              "user_id,"
              "show_date) "
          "values (?,?,?,?,?,?,?,?,?,?,?)",
          [
            model.id,
            model.relatedUser,
            model.info,
            model.isShow,
            model.isTop,
            model.type,
            model.pushDate,
            model.updateDate,
            model.infoNum,
            model.userId,
            model.showDate
          ]);
    }
  }

  @override
  Future update(MessageDataModel model) async {
    return await DBProvider.db.update("messagedata", model.toMap(), model.id);
  }

  @override
  Future insertAll(List<MessageDataModel> modelList) async {
    return Future.wait(modelList.map((model) async {
      await MessageDataDAO.dao.insert(model);
    }));
  }

  @override
  Future updateAll(List<MessageDataModel> modelList) async {
    return Future.wait(modelList.map((model) async {
      await MessageDataDAO.dao.update(model);
    }));
  }

  @override
  MessageDataModel convertBeanToModel(MessageData bean) {
    MessageDataModel messageDataModel = MessageDataModel(
      id: bean.id,
      relatedUser: json.encode(bean.relateUser.toJson()),
      info: bean.info,
      isShow: bean.isShow ? 1 : 0,
      isTop: bean.isTop ? 1 : 0,
      type: bean.type,
      pushDate: bean.date.replaceAll("T", " ").substring(0, 22),
      updateDate: bean.updateDate.replaceAll("T", " ").substring(0, 22),
        infoNum:bean.infoNum,
      userId: bean.user,
        showDate: bean.showDate
    );
    return messageDataModel;
  }

  @override
  List<MessageDataModel> convertBeanToModelAll(List<MessageData> beanList) {
    return List.generate(beanList.length, (i) {
      return MessageDataModel(
        id: beanList[i].id,
        relatedUser: json.encode(beanList[i].relateUser.toJson()),
        info: beanList[i].info,
        isShow: beanList[i].isShow ? 1 : 0,
        isTop: beanList[i].isTop ? 1 : 0,
        type: beanList[i].type,
        pushDate: beanList[i].date.replaceAll("T", " ").substring(0, 22),
        updateDate:
            beanList[i].updateDate.replaceAll("T", " ").substring(0, 22),
        infoNum: beanList[i].infoNum,
        userId: beanList[i].user,
          showDate: beanList[i].showDate
      );
    });
  }

  @override
  MessageData convertModelToBean(MessageDataModel model) {
    return MessageData(
        id: model.id,
        relateUser: UserInfoBrief.fromJson(json.decode(model.relatedUser)),
        info: model.info,
        isShow: model.isShow == 1 ? true : false,
        isTop: model.isTop == 1 ? true : false,
        type: model.type,
        date: model.pushDate,
        updateDate: model.updateDate,
        infoNum: model.infoNum,
        showDate: model.showDate,
      user: model.userId
        );
  }

  @override
  List<MessageData> convertModelToBeanAll(List<MessageDataModel> modelList) {
    return List.generate(modelList.length, (i) {
      return MessageData(
          id: modelList[i].id,
          relateUser: UserInfoBrief.fromJson(json.decode(modelList[i].relatedUser)),
          info: modelList[i].info,
          isShow: modelList[i].isShow == 1 ? true : false,
          isTop: modelList[i].isTop == 1 ? true : false,
          type: modelList[i].type,
          date: modelList[i].pushDate,
          updateDate: modelList[i].updateDate,
          showDate: modelList[i].showDate,
          infoNum: modelList[i].infoNum,
        user: modelList[i].userId
      );
    });
  }
}
