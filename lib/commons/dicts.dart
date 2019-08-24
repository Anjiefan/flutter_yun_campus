import 'package:finerit_app_flutter/icons/FineritIcons.dart';

class Dicts {
  static var MIMES = {
    ".3gp": "video/3gpp",
    ".apk": "application/vnd.android.package-archive",
    ".asf": "video/x-ms-asf",
    ".avi": "video/x-msvideo",
    ".bin": "application/octet-stream",
    ".bmp": "image/bmp",
    ".c": "text/plain",
    ".class": "application/octet-stream",
    ".conf": "text/plain",
    ".cpp": "text/plain",
    ".doc": "application/msword",
    ".docx":
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
    ".xls": "application/vnd.ms-excel",
    ".xlsx":
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
    ".exe": "application/octet-stream",
    ".gif": "image/gif",
    ".gtar": "application/x-gtar",
    ".gz": "application/x-gzip",
    ".h": "text/plain",
    ".htm": "text/html",
    ".html": "text/html",
    ".jar": "application/java-archive",
    ".java": "text/plain",
    ".jpeg": "image/jpeg",
    ".jpg": "image/jpeg",
    ".js": "application/x-javascript",
    ".log": "text/plain",
    ".m3u": "audio/x-mpegurl",
    ".m4a": "audio/mp4a-latm",
    ".m4b": "audio/mp4a-latm",
    ".m4p": "audio/mp4a-latm",
    ".m4u": "video/vnd.mpegurl",
    ".m4v": "video/x-m4v",
    ".mov": "video/quicktime",
    ".mp2": "audio/x-mpeg",
    ".mp3": "audio/x-mpeg",
    ".mp4": "video/mp4",
    ".mpc": "application/vnd.mpohun.certificate",
    ".mpe": "video/mpeg",
    ".mpeg": "video/mpeg",
    ".mpg": "video/mpeg",
    ".mpg4": "video/mp4",
    ".mpga": "audio/mpeg",
    ".msg": "application/vnd.ms-outlook",
    ".ogg": "audio/ogg",
    ".pdf": "application/pdf",
    ".png": "image/png",
    ".pps": "application/vnd.ms-powerpoint",
    ".ppt": "application/vnd.ms-powerpoint",
    ".pptx":
        "application/vnd.openxmlformats-officedocument.presentationml.presentation",
    ".prop": "text/plain",
    ".rc": "text/plain",
    ".rmvb": "audio/x-pn-realaudio",
    ".rtf": "application/rtf",
    ".sh": "text/plain",
    ".tar": "application/x-tar",
    ".tgz": "application/x-compressed",
    ".txt": "text/plain",
    ".wav": "audio/x-wav",
    ".wma": "audio/x-ms-wma",
    ".wmv": "audio/x-ms-wmv",
    ".wps": "application/vnd.ms-works",
    ".xml": "text/plain",
    ".z": "application/x-compress",
    ".zip": "application/x-zip-compressed",
    "": "*/*"
  };
  static var TASK_IMAGES = {
    'com.finerit.first_send_status': 'assets/profile/task/post.png',
    'com.finerit.first_send_comment': 'assets/profile/task/comment.png',
    'com.finerit.first_top_up': 'assets/profile/task/popup.png',
    'com.finerit.achive_student.authentication': 'assets/profile/task/verify.png',
    'com.finerit.first_become_best_comment': 'assets/profile/task/god_comment.png',
    'com.finerit.first_become_best_status': 'assets/profile/task/ranking.png',
    'com.finerit.first_send_wx': 'assets/profile/task/moments.png',
    'com.finerit.first_send_qq': 'assets/profile/task/qzone.png',
    'com.finerit.first_send_wb': 'assets/weibo.png',
    'com.finerit.ten_use_your_invitation_code': 'assets/profile/task/invite.png',
  };
  //微博，微信，qq分享
  static var TASK_STARE_CHIVE={
    "23":'com.finerit.first_send_wx',
    "7":'com.finerit.first_send_qq',
    "1":'com.finerit.first_send_wb',
  };
  //推送类型
  static var PUSH_TYPE={
    "INCOME_RANKING": "ranking", //收入排行
    "FEEDBACK": "feedback", //在线反馈
    "IM": "im", //即时通讯
    "COMMENT": "comment", //评论
    "FAVORITE": "favorite", //收藏
    "ADD_FRIEND": "add", //添加好友
    "COURSE": "course", //刷课
  };

  static var LEVEL_IMAGES={
    '幼稚园':FineritIcons.ranking1,
    '小学':FineritIcons.ranking2,
    '初中':FineritIcons.ranking3,
    '高中':FineritIcons.ranking4,
    '大学':FineritIcons.ranking5,
    '研究生':FineritIcons.ranking6,
    '博士':FineritIcons.ranking7,
    '博士后':FineritIcons.ranking8,
  };
}
