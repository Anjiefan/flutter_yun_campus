package com.finerit.campus.chatkit;

import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import cn.leancloud.chatkit.LCChatKitUser;
import cn.leancloud.chatkit.LCChatProfileProvider;
import cn.leancloud.chatkit.LCChatProfilesCallBack;
import cn.leancloud.chatkit.fineirt.FineritConstants;
import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

import static de.greenrobot.event.EventBus.TAG;

public class CustomUserProvider implements LCChatProfileProvider {

  private static CustomUserProvider customUserProvider;

  public synchronized static CustomUserProvider getInstance() {
    if (null == customUserProvider) {
      customUserProvider = new CustomUserProvider();
    }
    return customUserProvider;
  }

  private CustomUserProvider() {
  }

  private static List<LCChatKitUser> partUsers = new ArrayList<LCChatKitUser>();

  // 此数据均为模拟数据，仅供参考
//  static {
//    partUsers.add(new LCChatKitUser("Tom", "Tom", "http://www.avatarsdb.com/avatars/tom_and_jerry2.jpg"));
//    partUsers.add(new LCChatKitUser("Jerry", "Jerry", "http://www.avatarsdb.com/avatars/jerry.jpg"));
//    partUsers.add(new LCChatKitUser("Harry", "Harry", "http://www.avatarsdb.com/avatars/young_harry.jpg"));
//    partUsers.add(new LCChatKitUser("William", "William", "http://www.avatarsdb.com/avatars/william_shakespeare.jpg"));
//    partUsers.add(new LCChatKitUser("Bob", "Bob", "http://www.avatarsdb.com/avatars/bath_bob.jpg"));
//  }

  @Override
  public void fetchProfiles(List<String> list, LCChatProfilesCallBack callBack) {
    List<LCChatKitUser> userList = new ArrayList<LCChatKitUser>();
    for (String userId : list) {
      Request request = new Request.Builder().url(FineritConstants.FINERIT_SERVER_BASE_URL + "user_meet?user=" + userId).build();
      OkHttpClient client = new OkHttpClient();
      client.newCall(request).enqueue(new Callback() {
        @Override
        public void onFailure(Call call, IOException e) {

        }

        @Override
        public void onResponse(Call call, Response response) throws IOException {
          if(!response.isSuccessful()) {
            System.out.println(response.message());
            return;
          }
          if (response.body() != null){
            String userInfo = response.body().string();
            try {
              JSONObject userJson = new JSONObject(userInfo);
              String id = userJson.getString("id");
              String name = userJson.getString("name");
              String head = userJson.getString("head");
              LCChatKitUser user = new LCChatKitUser(id, name, head);
              userList.add(user);
              callBack.done(userList, null);
            } catch (JSONException e) {
              e.printStackTrace();
            }

          }

        }
      });
//      for (LCChatKitUser user : partUsers) {
//        if (user.getUserId().equals(userId)) {
//          userList.add(user);
//          break;
//        }
//      }
    }

  }

  public List<LCChatKitUser> getAllUsers() {
    return partUsers;
  }
}