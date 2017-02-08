package com.fh.util;



import java.util.HashMap;
import java.util.Map;

import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

import cn.jpush.api.JPushClient;
import cn.jpush.api.common.resp.APIConnectionException;
import cn.jpush.api.common.resp.APIRequestException;
import cn.jpush.api.push.PushResult;
import cn.jpush.api.push.model.Message;
import cn.jpush.api.push.model.Options;
import cn.jpush.api.push.model.Platform;
import cn.jpush.api.push.model.PushPayload;
import cn.jpush.api.push.model.audience.Audience;
import cn.jpush.api.push.model.notification.AndroidNotification;
import cn.jpush.api.push.model.notification.IosNotification;
import cn.jpush.api.push.model.notification.Notification;



public class JPush {

    private static String masterSecret="5e7540abfceb4d31123f4a1b";

    private static String appKey="2113d3121bba78972fa251c5";

    @SuppressWarnings("deprecation")
    public static Boolean sendMsg(String alias[], String message) {
        for (String string : alias) {
            if (string == null) {
                return false;
            }
        }
        JSONObject object = JSONObject.fromObject(message);
        Map<String, String> map = new HashMap<>();
        for (Object key : object.keySet()) {
            map.put(key.toString(), object.getString(key.toString()));
        }
        try {
            JPushClient jpushClient = new JPushClient(masterSecret, appKey, 3);
            // PushPayload payload =
            // PushPayload.newBuilder().setPlatform(Platform.all()).setAudience(Audience.alias(alias))
            // .setNotification(Notification.alert(message)).build();
            PushPayload payload = PushPayload
                .newBuilder()
                .setPlatform(Platform.android_ios())
                .setAudience(Audience.alias(alias))
                .setNotification(
                    Notification.newBuilder()
                        .addPlatformNotification(AndroidNotification.newBuilder().addExtras(map).setAlert(object.getString("content")).build())
                        .addPlatformNotification(IosNotification.newBuilder().setAlert(object.getString("content")).setBadge(5).addExtras(map).build()).build())
                .setOptions(Options.newBuilder().setApnsProduction(false).build()).setMessage(Message.content(message)).build();
            PushResult result = jpushClient.sendPush(payload);
            if (result.getResponseCode() == 200) {
                return true;
            } else {
                return false;
            }
        } catch (APIConnectionException | APIRequestException e) {
            return false;
        }
    }
//    public static void main(String[] args) {
//        String alias [] = new String[1];
//        alias[0] = "xiaoti";
//        Map<String, String> map = new HashMap<>();
//        map.put("content", "11");
//        map.put("rid", "123123");
//        map.put("type", "10003");
//        sendMsg(alias, JSONObject.fromObject(map).toString());
//    }

}
