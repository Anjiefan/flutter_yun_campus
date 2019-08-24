
package com.finerit.campus.activity;

import android.Manifest;
import android.app.AlertDialog;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.provider.Settings;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;

import com.alipay.sdk.app.PayTask;
import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVInstallation;
import com.avos.avoscloud.AVOSCloud;
import com.avos.avoscloud.PushService;
import com.avos.avoscloud.SaveCallback;
import com.avos.avoscloud.feedback.FeedbackAgent;
import com.avos.avoscloud.im.v2.AVIMClient;
import com.avos.avoscloud.im.v2.AVIMException;
import com.avos.avoscloud.im.v2.callback.AVIMClientCallback;
import com.finerit.campus.FineritApp;
import com.finerit.campus.R;
import com.finerit.campus.activity.base.FlutterActivity;
import com.finerit.campus.alipay.PayResult;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;
import androidx.core.content.ContextCompat;

import cn.leancloud.chatkit.LCChatKit;
import cn.leancloud.chatkit.activity.LCIMConversationActivity;
import cn.leancloud.chatkit.utils.LCIMConstants;
import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.onekeyshare.OnekeyShare;
import cn.sharesdk.sina.weibo.SinaWeibo;
import cn.sharesdk.tencent.qzone.QZone;
import cn.sharesdk.wechat.moments.WechatMoments;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import kr.co.namee.permissiongen.PermissionFail;
import kr.co.namee.permissiongen.PermissionGen;
import kr.co.namee.permissiongen.PermissionSuccess;

import static android.app.Notification.EXTRA_CHANNEL_ID;
import static android.provider.Settings.EXTRA_APP_PACKAGE;
import static com.finerit.campus.common.Constants.ACTION_LC_RECEIVER;
import static com.finerit.campus.common.Constants.LC_CHANNEL;


public class MainActivity extends FlutterActivity {
    private static final String CHANNEL_PAYMENT_INVOKE = "com.finerit.campus/payment/invoke";
    private static final String CHANNEL_PAYMENT_CONFIRM = "com.finerit.campus/payment/confirm/android";
    private static final String CHANNEL_PUSH_CONFIRM = "com.finerit.campus/push/confirm";
    private static final String CHANNEL_PUSH_REGISTER = "com.finerit.campus/push/register";
    private static final String CHANNEL_PUSH_INITIALIZE = "com.finerit.campus/push/initialize";
    private static final String CHANNEL_CHAT_QQ = "com.finerit.campus/chat/qq";
    private static final String CHANNEL_CHAT_WX = "com.finerit.campus/chat/wx";
    private static final String CHANNEL_CHAT_WB = "com.finerit.campus/chat/wb";
    private static final String CHANNEL_FEEDBACK__INVOKE = "com.finerit.campus/fankui/invoke";
    private static final String CHANNEL_UNIFIED_INVOKE = "com.finerit.campus/unified/invoke";
    private BroadcastReceiver pushResultReceiver;

    //分享
    private static final String CHANNEL_SHARE = "com.finerit.campus/share/invoke";
    private static final String TAG = "MainActivity";
    private static final int SDK_PAY_FLAG = 1;
    private String toastMsg;
    private String bill_no;
    private MethodChannel pushRegisterEventChannel;
    private MethodChannel.Result shareResult;
    private MethodChannel moneyRefreshMethodChannel;
    private EventChannel pushConfirmEventChannel;


    private Handler mHandler = new Handler(new Handler.Callback() {
        /**
         * Callback interface you can use when instantiating a Handler to avoid
         * having to implement your own subclass of Handler.
         *
         * handleMessage() defines the operations to perform when
         * the Handler receives a new Message to process.
         */
        @Override
        public boolean handleMessage(Message msg) {
            switch (msg.what) {
                case SDK_PAY_FLAG:
                    PayResult payResult = new PayResult((Map<String, String>) msg.obj);
                    /**
                     * 对于支付结果，请商户依赖服务端的异步通知结果。同步通知结果，仅作为支付结束的通知。
                     */
                    String resultInfo = payResult.getResult();// 同步返回需要验证的信息
                    String resultStatus = payResult.getResultStatus();
                    // 判断resultStatus 为9000则代表支付成功
                    if (TextUtils.equals(resultStatus, "9000")) {
                        // 该笔订单是否真实支付成功，需要依赖服务端的异步通知。
                        moneyRefreshMethodChannel = new MethodChannel(getFlutterView(), CHANNEL_PAYMENT_CONFIRM);
                        moneyRefreshMethodChannel.invokeMethod("refreshMoney", 0);
                        Toast.makeText(MainActivity.this, "支付成功", Toast.LENGTH_LONG).show();
//                        showAlert(PayDemoActivity.this, getString(R.string.pay_success) + payResult);
                    } else {
                        // 该笔订单真实的支付结果，需要依赖服务端的异步通知。
                        Toast.makeText(MainActivity.this, "支付失败：" + payResult, Toast.LENGTH_LONG).show();
//                        showAlert(PayDemoActivity.this, getString(R.string.pay_failed) + payResult);
                    }
                    break;
            }
            return true;
        }
    });


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        initializeBCPay();
        GeneratedPluginRegistrant.registerWith(this);
        //注册Platform Channel
        registerPlatformChannels();
        //注册微信开放平台SDK
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED ||
                ContextCompat.checkSelfPermission(this, Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED ||
                ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED ||
                ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED ||
                ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_LOCATION_EXTRA_COMMANDS) != PackageManager.PERMISSION_GRANTED ||
                ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED ||
                ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO) != PackageManager.PERMISSION_GRANTED
        ) {
            showRequestPermissionDialog();
        }
    }

    private void showRequestPermissionDialog() {
        AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this, R.style.Theme_AppCompat_Light_Dialog);
        builder.setTitle("提示")
                .setMessage("为了保证APP正常运行，请允许以下权限申请。")
                .setCancelable(false)
                .setPositiveButton("确定", (dialog, which) -> {
                    doRequestPermission();
                })
                .show();
    }

    @PermissionFail(requestCode = 100)
    private void permissionDeny() {
        AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this, R.style.Theme_AppCompat_Light_Dialog);
        builder.setTitle("提示")
                .setMessage("为了保证APP正常运行，请允许以下权限申请。")
                .setCancelable(false)
                .setPositiveButton("确定", (dialog, which) -> {
                    doRequestPermission();
                })
                .show();
    }

    private void doRequestPermission() {
        PermissionGen.with(this)
                .addRequestCode(100)
                .permissions(
                        Manifest.permission.WRITE_EXTERNAL_STORAGE,
                        Manifest.permission.READ_EXTERNAL_STORAGE,
                        Manifest.permission.ACCESS_COARSE_LOCATION,
                        Manifest.permission.ACCESS_FINE_LOCATION,
                        Manifest.permission.ACCESS_LOCATION_EXTRA_COMMANDS,
                        Manifest.permission.CAMERA,
                        Manifest.permission.RECORD_AUDIO
                )
                .request();
    }

    @Override
    protected void onResume() {
        super.onResume();
        checkNotification();
        Log.e(TAG, "onResume: "+FineritApp.isLCPushInitialized);
        if(FineritApp.isLCPushInitialized){//恢复推送机制
            initializeLCPush();
        }
    }

    private void registerPushConfirmListener() {
        Log.e(TAG, "registerPushConfirmListener: in");
        //推送信息->Flutter
        pushConfirmEventChannel = new EventChannel(getFlutterView(), CHANNEL_PUSH_CONFIRM);
        pushConfirmEventChannel.setStreamHandler(
                new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object args, final EventChannel.EventSink events) {
                        pushResultReceiver = createPushResultReceiver(events);
                        registerReceiver(pushResultReceiver, new IntentFilter(ACTION_LC_RECEIVER));
                        Log.e(TAG, "onListen: pushReceiver");
                    }

                    @Override
                    public void onCancel(Object args) {
                        if (pushResultReceiver != null) {
                            unregisterReceiver(pushResultReceiver);
                            pushResultReceiver = null;
                            Log.e(TAG, "onCancel: pushReceiver");
                        }
                    }
                }
        );
    }

    @PermissionSuccess(requestCode = 100)
    private void checkNotification() {
        NotificationManagerCompat manager = NotificationManagerCompat.from(this);
        // areNotificationsEnabled方法的有效性官方只最低支持到API 19，低于19的仍可调用此方法不过只会返回true，即默认为用户已经开启了通知。
        boolean isOpened = manager.areNotificationsEnabled();
        if (isOpened) {
            //pass

        } else {
            AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this, R.style.Theme_AppCompat_Light_Dialog);
            builder.setTitle("重要提示")
                    .setMessage("为了保证APP正常使用，请按照引导开启消息推送功能~")
                    .setCancelable(false)
                    .setPositiveButton("去开启", (dialog, which) -> {
                        try {
                            // 根据isOpened结果，判断是否需要提醒用户跳转AppInfo页面，去打开App通知权限
                            Intent intent = new Intent();
                            intent.setAction(Settings.ACTION_APP_NOTIFICATION_SETTINGS);
                            //这种方案适用于 API 26, 即8.0（含8.0）以上可以用
                            intent.putExtra(EXTRA_APP_PACKAGE, getPackageName());
                            intent.putExtra(EXTRA_CHANNEL_ID, getApplicationInfo().uid);

                            //这种方案适用于 API21——25，即 5.0——7.1 之间的版本可以使用
                            intent.putExtra("app_package", getPackageName());
                            intent.putExtra("app_uid", getApplicationInfo().uid);

                            // 小米6 -MIUI9.6-8.0.0系统，是个特例，通知设置界面只能控制"允许使用通知圆点"——然而这个玩意并没有卵用，我想对雷布斯说：I'm not ok!!!
                            //  if ("MI 6".equals(Build.MODEL)) {
                            //      intent.setAction(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
                            //      Uri uri = Uri.fromParts("package", getPackageName(), null);
                            //      intent.setData(uri);
                            //      // intent.setAction("com.android.settings/.SubSettings");
                            //  }
                            startActivity(intent);
                        } catch (Exception e) {
                            e.printStackTrace();
                            // 出现异常则跳转到应用设置界面：锤子坚果3——OC105 API25
                            Intent intent = new Intent();

                            //下面这种方案是直接跳转到当前应用的设置界 x面。
                            //https://blog.csdn.net/ysy950803/article/details/71910806
                            intent.setAction(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
                            Uri uri = Uri.fromParts("package", getPackageName(), null);
                            intent.setData(uri);
                            startActivity(intent);
                        }
                    }).show();
        }
    }

    private void initializeLCPush() {
        Log.e(TAG, "initializeLCPush: " + FineritApp.isLCPushInitialized);
//        if(!FineritApp.isLCPushInitialized){//推送未注册
            PushService.setDefaultPushCallback(this, MainActivity.class);
            PushService.subscribe(this, "public", MainActivity.class);
            final String[] installationId = {"N/A"};
            AVInstallation.getCurrentInstallation().saveInBackground(new SaveCallback() {
                public void done(AVException e) {
                    if (e == null) {
                        // 保存成功
                        installationId[0] = AVInstallation.getCurrentInstallation().getInstallationId();
                        //推送注册信息->Flutter
                        pushRegisterEventChannel = new MethodChannel(getFlutterView(), CHANNEL_PUSH_REGISTER);
                        pushRegisterEventChannel.invokeMethod("updateInstallationId", installationId[0]);
                        FineritApp.isLCPushInitialized = true;
                        registerPushConfirmListener();
                    } else {
                        // 保存失败，输出错误信息
                    }
                }
            });
//        }

    }

    private void registerPlatformChannels() {
        new MethodChannel(getFlutterView(), CHANNEL_UNIFIED_INVOKE).setMethodCallHandler((methodCall, result) ->
        {
            switch (methodCall.method) {
                case "openChatKit":
                    doOpenChatKit(((ArrayList<String>) methodCall.arguments).get(0), ((ArrayList<String>) methodCall.arguments).get(1));
                    break;
            }
            if (methodCall.method.equals("fankui")) {
                doFeedback(((ArrayList<String>) methodCall.arguments).get(0));
            }
        });
        new MethodChannel(getFlutterView(), CHANNEL_FEEDBACK__INVOKE).setMethodCallHandler((methodCall, result) ->
        {
            if (methodCall.method.equals("fankui")) {
                doFeedback(((ArrayList<String>) methodCall.arguments).get(0));
            }
        });
        new MethodChannel(getFlutterView(), CHANNEL_SHARE).setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("doShare")) {
                        shareResult = result;
                        doShare(((ArrayList<String>) call.arguments).get(0));
                    }
                });
        new MethodChannel(getFlutterView(), CHANNEL_PAYMENT_INVOKE).setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("doAlipay")) {
                        doAlipay(((ArrayList<String>) call.arguments).get(0));
                    }
                });
        new MethodChannel(getFlutterView(), CHANNEL_PUSH_INITIALIZE).setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("initializeLCPush")) {
                        initializeLCPush();
                    }
                });
        new MethodChannel(getFlutterView(), CHANNEL_CHAT_QQ).setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("chatqq")) {
                        String url = "mqqwpa://im/chat?chat_type=wpa&uin=66064540";
                        startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url)));
                    }
                });
        new MethodChannel(getFlutterView(), CHANNEL_CHAT_WX).setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("chatwx")) {
                        AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this, R.style.Theme_AppCompat_Light_Dialog
                        );
                        builder.setTitle("提示信息")
                                .setMessage("公众号二维码已保存到相册，跳转微信扫码关注？")
                                .setCancelable(true)
                                .setPositiveButton("去关注", (dialog, which) -> {
                                    Intent intent = new Intent();
                                    ComponentName cmp = new ComponentName("com.tencent.mm", "com.tencent.mm.ui.LauncherUI");
                                    intent.setAction(Intent.ACTION_MAIN);
                                    intent.addCategory(Intent.CATEGORY_LAUNCHER);
                                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                                    intent.setComponent(cmp);
                                    startActivity(intent);
                                })
                                .setNegativeButton("取消", (dialog, which) -> {
                                })
                                .show();

                    }
                });
        new MethodChannel(getFlutterView(), CHANNEL_CHAT_WB).setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("chatwb")) {
                        String url = "sinaweibo://userinfo?uid=6838463764";
                        startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url)));
                    }
                });


    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if(requestCode == 500){

        }
    }

    private void doOpenChatKit(String from, String to) {
        LCChatKit.getInstance().open(from, new AVIMClientCallback() {
            @Override
            public void done(AVIMClient avimClient, AVIMException e) {
                if (null == e) {
//                    finish();
                    Log.e(TAG, "done: from:" + from + ", to:" + to);
                    Intent intent = new Intent(MainActivity.this, LCIMConversationActivity.class);
                    intent.putExtra(LCIMConstants.PEER_ID, to);
                    startActivityForResult(intent, 500);
                } else {
                    e.printStackTrace();
                    Toast.makeText(MainActivity.this, e.toString(), Toast.LENGTH_SHORT).show();
                }
            }
        });
    }

    @Override
    protected void onPause() {
        super.onPause();
        if (pushResultReceiver != null) {
            unregisterReceiver(pushResultReceiver);
            pushResultReceiver = null;
            Log.e(TAG, "onCancel: pushReceiver");
        }
    }

    @Override
    protected void onStop() {
        super.onStop();
    }

    private void doFeedback(String phone) {
        FeedbackAgent agent = new FeedbackAgent(this);
        agent.getDefaultThread().setContact(phone);
        agent.startDefaultThreadActivity();
    }

    private String sharePlatformFlag = "";

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        PermissionGen.onRequestPermissionsResult(this, requestCode, permissions, grantResults);
    }

    //微信消息分享
    private void doShare(String id) {
        OnekeyShare oks = new OnekeyShare();
        //关闭sso授权
        oks.disableSSOWhenAuthorize();
        // title标题，微信、QQ和QQ空间等平台使用
        oks.setTitle("云智校APP");
        // titleUrl QQ和QQ空间跳转链接
        oks.setTitleUrl("https://hwapp.finerit.com/web/team_register/?father_id="+id);
        // text是分享文本，所有平台都需要这个字段
        oks.setText("云智校，大学生的网络兼职平台，娱乐&赚钱，还有好用的自动代看网课系统哦～");
//        oks.setImageUrl("http://f1.sharesdk.cn/imgs/2014/02/26/owWpLZo_638x960.jpg");
        oks.setImageData(BitmapFactory.decodeResource(getResources(), R.mipmap.logo));
        oks.setShareContentCustomizeCallback((platform, shareParams) -> {
            if (WechatMoments.NAME.equals(platform.getName())) {
                sharePlatformFlag = "23";
                shareParams.setTitle("云智校APP");
                shareParams.setTitleUrl("https://hwapp.finerit.com/web/team_register/?father_id="+id);
                shareParams.setText("云智校，大学生的网络兼职平台，娱乐&赚钱，还有好用的自动代看网课系统哦～");
                shareParams.setImageData(BitmapFactory.decodeResource(getResources(), R.mipmap.logo));
            } else if (QZone.NAME.equals(platform.getName())) {
                sharePlatformFlag = "7";
                shareParams.setTitle("云智校APP");
                shareParams.setTitleUrl("https://hwapp.finerit.com/web/team_register/?father_id="+id);
                shareParams.setText("云智校，大学生的网络兼职平台，娱乐&赚钱，还有好用的自动代看网课系统哦～");
                shareParams.setImageData(BitmapFactory.decodeResource(getResources(), R.mipmap.logo));
            } else if (SinaWeibo.NAME.equals(platform.getName())) {
                sharePlatformFlag = "1";
                shareParams.setTitle("云智校APP https://hwapp.finerit.com/web/team_register/?father_id="+id);
                shareParams.setText("云智校，大学生的网络兼职平台，娱乐&赚钱，还有好用的自动代看网课系统哦～");
                shareParams.setImageData(BitmapFactory.decodeResource(getResources(), R.mipmap.logo));
            }
        });
        oks.setCallback(new PlatformActionListener() {
            @Override
            public void onComplete(Platform platform, int i, HashMap<String, Object> hashMap) {
//                Toast.makeText(MainActivity.this, "sharePlatformFlag=" + sharePlatformFlag, Toast.LENGTH_SHORT).show();
                shareResult.success(sharePlatformFlag);
                shareResult = null;
                sharePlatformFlag = "";
            }


            @Override
            public void onError(Platform platform, int i, Throwable throwable) {

            }

            @Override
            public void onCancel(Platform platform, int i) {

            }
        });
//        // imagePath是图片的本地路径，Linked-In以外的平台都支持此参数
//        oks.setImagePath("/sdcard/test.jpg");//确保SDcard下面存在此张图片
        // url在微信、微博，Facebook等平台中使用
        oks.setUrl("https://hwapp.finerit.com/web/team_register/?father_id="+id);
        // 启动分享GUI
        oks.show(this);
    }

    //支付宝
    private void doAlipay(String alipayUrl) {
        final Runnable payRunnable = () -> {
            PayTask alipay = new PayTask(MainActivity.this);
            Map<String, String> result = alipay.payV2(alipayUrl, true);
            Log.i("msp", result.toString());

            Message msg = new Message();
            msg.what = SDK_PAY_FLAG;
            msg.obj = result;
            mHandler.sendMessage(msg);
        };

        // 必须异步调用
        Thread payThread = new Thread(payRunnable);
        payThread.start();
    }

    //注册推送结果接收器
    private BroadcastReceiver createPushResultReceiver(final EventChannel.EventSink events) {
        return new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                Log.e(TAG, "onReceive: ");
                try {
                    if (intent.getAction().equals(ACTION_LC_RECEIVER)) {
                        Log.e(TAG, "onReceive: LC_RECEIVER");
                        String receiveContent = intent.getExtras().getString("com.avos.avoscloud.Data");
                        JSONObject json = new JSONObject(receiveContent);
                        final String title = json.getString("title");//推送消息标题
                        final String content = json.getString("content");//推送消息内容
                        String ticker = "你有一条新的消息";
                        Intent resultIntent = new Intent(AVOSCloud.applicationContext, MainActivity.class);
                        PendingIntent pendingIntent =
                                PendingIntent.getActivity(AVOSCloud.applicationContext, 0, resultIntent,
                                        PendingIntent.FLAG_UPDATE_CURRENT);
                        NotificationCompat.Builder mBuilder =
                                new NotificationCompat.Builder(AVOSCloud.applicationContext, LC_CHANNEL)
                                        .setSmallIcon(R.mipmap.logo)
                                        .setContentTitle(
                                                title)
                                        .setContentText(content)
                                        .setTicker(ticker);
                        NotificationManager notificationManager = (NotificationManager) AVOSCloud.applicationContext.getSystemService(Context.NOTIFICATION_SERVICE);
                        if (Build.VERSION.SDK_INT >= 26) {
                            NotificationChannel channel = new NotificationChannel(
                                    LC_CHANNEL,
                                    LC_CHANNEL,
                                    NotificationManager.IMPORTANCE_HIGH
                            );
                            channel.setDescription(LC_CHANNEL);
                            notificationManager.createNotificationChannel(channel);
                        }
                        mBuilder.setContentIntent(pendingIntent);
                        mBuilder.setAutoCancel(true);
                        int mNotificationId = (int) (System.currentTimeMillis() / 1000);
                        notificationManager.notify(mNotificationId, mBuilder.build());
                        events.success(receiveContent);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        };
    }
}
