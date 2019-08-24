//TODO 暂时搁置的老代码
//switch (type) {
//case "message_like_me":
////喜欢我的推送
//model.messageLikeCount = model.messageLikeCount + 1;
//break;
//case "message_comment_me":
////评论我的推送
//model.messageCommentCount = model.messageCommentCount + 1;
//break;
//case "profile_yesterday_comment":
////昨日神评推送
//model.profileYesterdayCommentCount =
//model.profileYesterdayCommentCount + 1;
//break;
//case "profile_yesterday_ranking":
////昨日榜单推送
//model.profileYesterdayRankingCount =
//model.profileYesterdayRankingCount + 1;
//break;
//case "profile_comment_money":
////获得神评奖励->获奖历程推送
//model.profileAwardHistoryCount = model.profileAwardHistoryCount + 1;
//break;
//case "profile_ranking_money":
////获得排行榜名次奖励->获奖历程推送
//model.profileAwardHistoryCount = model.profileAwardHistoryCount + 1;
//break;
//case "task":
////新手任务完成->新手任务推送
//model.profileTaskCount = model.profileTaskCount + 1;
//break;
//case 'profile_verify_success':
//NetUtil.get(Api.USER_INFO+model.objectId+'/', (data) {
//UserInfoDetail userInfo = UserInfoDetail.fromJson(data);
//model.userInfo=userInfo;
//}, headers: {"Authorization": "Token ${model.session_token}"});
//break;
//}