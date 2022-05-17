import 'package:flutter/material.dart';
import 'package:whatapp_clone_ui/pages/uiChat/view/camera_page.dart';
import 'package:whatapp_clone_ui/pages/uiStreaming/settings_page.dart';
import 'package:whatapp_clone_ui/pages/uiChat/view/video_call_page.dart';
import 'package:whatapp_clone_ui/pages/uiChat/view/videoCallReceiver.dart';

final String exploreSettingMenu = '/setting';
final String exemple = '/exemple';
final String videoCall = '/videoCall';
final String videoCallReceiver = '/videoCallReceiver';

Map<String, WidgetBuilder> AppRoutes() {
  return <String, WidgetBuilder>{
    //route pour atteindre la setting page ( /setting )
    exploreSettingMenu: ((context) => SettingsPage()),

    //exemple url /exemple  pour atteindre la page camera
    exemple: (context) => CameraPage(),
    videoCall: (context) => MyApp(),
    videoCallReceiver: (context) => MyApp1(),
  };
}
