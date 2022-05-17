import 'package:flutter/material.dart';
import 'package:whatapp_clone_ui/pages/root_app.dart';
import 'package:whatapp_clone_ui/pages/uiChat/Routing/AppRoutes.dart';
//import 'package:whatapp_clone_ui/pages/uiStreaming/settings_page.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
//import 'dart:isolate';
import 'package:whatapp_clone_ui/notificationservice.dart';
import 'dart:core';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:whatapp_clone_ui/json/chat_json.dart';
import 'package:whatapp_clone_ui/json/server_config.dart';

IO.Socket socket = null;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
var bol = false;

void setAlarm() async {
  bol = false;
  print("setAlarm");
  final int alarmID = 5;
  //navigatorKey.currentState?.pushNamed('/setting');

  // navigatorKey.currentState?.pushNamed('/videoCallReceiver');
  // IO.Socket socket = null;
/*
  String mess = '';

  print('---------->poipjpoijpoijpoijpoijpoijpoijpoijpojpoijpmmpoipoijpmi');
  socket = IO.io(URL, IO.OptionBuilder().setTransports(socket_config).build());
  socket.onConnect((data) => {
        print('connection ok!'),
      });

  socket.emit('join', {
    [profile[0]]
  });
  */
  await AndroidAlarmManager.oneShot(Duration(seconds: 2), alarmID, playAlarm);
}

void playAlarm() {
  print("playAlarm");

  IO.Socket socket = null;
  String mess = '';

  // print('---------->poipjpoijpoijpoijpoijpoijpoijpoijpojpoijpmmpoipoijpmi');
  socket = IO.io(URL, IO.OptionBuilder().setTransports(socket_config1).build());
  socket.onConnect((data) => {
        print('connection ok!'),
      });

  socket.emit('join', {
    [profile[0]]
  });

  //String mess = '';
  socket.on('youhavecall', (emett) {
    //print('vous avez un appel de ');
    //data = jsonDecode(data);
    print('vous avez un appel de  ');
    print(emett['emett']['name']);
    sendNotification(
        title: "Vous avez un Appel Video",
        body:
            '${emett['emett']['name']} essaye de vous joindre via un appel video');
    bol = true;
  });
//Navigator.pushNamed(context, '/videoCallReceiver');

  //socket.dispose();
  //setAlarm();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  // NavigationService().setupLocator();
  //pushNamed('/setting');
  // AndroidAlarmManager.initialize();
  //String test = "Press Me!";
  //sendNotification(title: "il y'a rien", body: "juste des tests");
  //navigatorKey.currentState.pushNamed('/setting');
/*
final NavigationService _navigationService = locator<NavigationService>();
 _navigationService.navigateTo('setting');
*/
//Navigator.pushReplacementNamed(context, '/settings/brightness');
  setAlarm();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "whatsapp",
    home: RootApp(),
    initialRoute: !bol ? '/setting' : '/videoCallReceiver',
    routes: AppRoutes(),
  ));
  //setAlarm();
//await AndroidAlarmManager.initialize();
  //setAlarm();
  print('bonjour snake eyes! ${bol}');
}
