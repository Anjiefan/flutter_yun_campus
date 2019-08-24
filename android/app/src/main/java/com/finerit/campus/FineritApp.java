package com.finerit.campus;

//import com.avos.avoscloud.AVMixPushManager;
import com.avos.avoscloud.AVOSCloud;
import com.avos.avoscloud.PushService;
import com.finerit.campus.chatkit.CustomUserProvider;
import com.mob.MobSDK;
import com.tencent.bugly.Bugly;

import cn.leancloud.chatkit.LCChatKit;
import io.flutter.app.FlutterApplication;

import static com.finerit.campus.common.Constants.LC_CHANNEL;

public class FineritApp extends FlutterApplication {

    public static boolean isLCPushInitialized = false;
    @Override
    public void onCreate() {
        super.onCreate();

        //初始化Bugly
        Bugly.init(getApplicationContext(), "1fd3fdfc7b", false);
        //初始化LeanCloud相关服务
        PushService.setDefaultChannelId(this, LC_CHANNEL);
        AVOSCloud.initialize(this, "aveFaAUxq89hJCelmHX33pLU-gzGzoHsz", "SX8gmajxVuYL4MvfOCTvV5zR");
        AVOSCloud.setLastModifyEnabled(true);
        AVOSCloud.setDebugLogEnabled(true);
        LCChatKit.getInstance().setProfileProvider(CustomUserProvider.getInstance());
        LCChatKit.getInstance().init(getApplicationContext(), "aveFaAUxq89hJCelmHX33pLU-gzGzoHsz", "SX8gmajxVuYL4MvfOCTvV5zR");
        MobSDK.init(this);
    }
}
