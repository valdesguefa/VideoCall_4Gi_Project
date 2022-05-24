import 'dart:convert';
import 'dart:core';
//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:permission_handler/permission_handler.dart';
import 'package:whatapp_clone_ui/theme/colors.dart';
import 'package:whatapp_clone_ui/json/chat_json.dart';
import 'package:whatapp_clone_ui/json/server_config.dart';

enum SignalingState {
  CallStateNew,
  CallStateRinging,
  CallStateInvite,
  CallStateConnected,
  CallStateBye,
  ConnectionOpen,
  ConnectionClosed,
  ConnectionError,
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /*late */ IO.Socket socket = null;
  //Signaling _signaling;
  bool _inCalling = false;

  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  MediaStream _localStream;
  RTCPeerConnection pc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  Future init() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();

    await connectSocket();
    // _makeCall();
    await joinRoom();
    /*
    final mediaConstraints = videoConstraintsPhone1;
    navigator.mediaDevices.getUserMedia(mediaConstraints).then((stream){
      this.setState(() {
        _localStream = stream;
      });
    });
    */
  }

  Future connectSocket() async {
    /*
              if (ContextCompat.checkSelfPermission(context, Manifest.permission.CAMERA) != 
          PackageManager.PERMISSION_GRANTED) { 
          ActivityCompat.requestPermissions(this, new String[] {Manifest.permission.CAMERA}, 
          50); }
          */
    print('poipjpoijpoijpoijpoijpoijpoijpoijpojpoijpmmpoipoijpmi');
    socket =
        IO.io(URL, IO.OptionBuilder().setTransports(socket_config1).build());
    socket.onConnect((data) => {
          print('connection ok!'),
          this.setState(() {
            _inCalling = true;
          })
        });

    socket.on('joined', (data) {
      _sendOffer();
    });

    socket.on('offer', (data) async {
      data = jsonDecode(data);
      await _gotOffer(RTCSessionDescription(data['sdp'], data['type']));
      await _sendAnswer();
    });

    socket.on('answer', (data) {
      data = jsonDecode(data);
      _gotAnswer(RTCSessionDescription(data['sdp'], data['type']));
    });

    socket.on('ice', (data) {
      data = jsonDecode(data);
      _gotIce(RTCIceCandidate(
          data['candidate'], data['sdpMid'], data['sdpMLineIndex']));
    });
  }

  Future joinRoom() async {
    final config = {
      'iceServers': [
        {"url": "stun:stun.l.google.com:19302"},
      ]
    };

    final sdpConstraints = {
      'mandatory': {
        'OfferToReceiveAudio': true,
        'OfferToReceiveVideo': true,
      },
      'optional': []
    };

    pc = await createPeerConnection(config, sdpConstraints);

    final mediaConstraints = videoConstraintsPhone1;

    // _localStream = await Helper.openCamera(mediaConstraints);

    try {
      await Permission.camera.request();
      await Permission.microphone.request();
      // _localStream =  await navigator.mediaDevices.getUserMedia(mediaConstraints);
      //await navigator.mediaDevices.getUserMedia(mediaConstraints);
      MediaStream stream = await Helper.openCamera(
          mediaConstraints); //await navigator.mediaDevices.getUserMedia( mediaConstraints); //await Helper.openCamera( mediaConstraints); //await navigator.getUserMedia(mediaConstraints);  //await navigator.getDisplayMedia(mediaConstraints);
      _localStream = stream;
      this.setState(() {
        _localStream = stream;
      });
      /*
      navigator.mediaDevices.getUserMedia(mediaConstraints).then((stream){
        this.setState(() {
          _localStream = stream;
        });
      });
*/
      /* use the stream */
      /*
      navigator.mediaDevices.getUserMedia(mediaConstraints).then((stream){
        _localStream=stream;
      })
      */
    } catch (err) {
      /* handle the error */
      print('erreur genere');
      print(err);
      await Permission.camera.request();
      await Permission.microphone.request();

      if (await Permission.camera.isPermanentlyDenied) {
        // The user opted to never again see the permission request dialog for this
        // app. The only way to change the permission's status now is to let the
        // user manually enable it in the system settings.
        openAppSettings();
      }
    }
    try {
      print('kjslajdfnlkjasnlkjnlkjnalskdjn ${_localStream}');
      _localStream.getTracks()?.forEach((track) {
        pc.addTrack(track, _localStream);
      });

      _localRenderer?.srcObject = _localStream;
    } catch (err) {
      /* handle the error */
      print('erreur genere 2');
      print(err);
    }
    pc.onIceCandidate = (ice) {
      _sendIce(ice);
    };

    pc.onAddStream = (stream) {
      _remoteRenderer.srcObject = stream;

    };

    Map data = ModalRoute.of(context).settings.arguments;
    print(data);

    socket.emit('join', {
      [profile[0], data]
    });
  }

  Future _sendOffer() async {
    print('send offer');
    
    var offer = await pc.createOffer();
    pc.setLocalDescription(offer);
    socket.emit('offer', jsonEncode(offer.toMap()));
    
  

  }

  Future _gotOffer(RTCSessionDescription offer) async {
    print('got offer');
    pc.setRemoteDescription(offer);
  }

  Future _sendAnswer() async {
    print('send answer');

    var answer = await pc.createAnswer();
    pc?.setLocalDescription(answer);
    socket.emit('answer', jsonEncode(answer.toMap()));
  
  }

  Future _gotAnswer(RTCSessionDescription answer) async {
    print('got answer');
    pc.setRemoteDescription(answer);
  }

  Future _sendIce(RTCIceCandidate ice) async {
    socket.emit('ice', jsonEncode(ice.toMap()));
  }

  Future _gotIce(RTCIceCandidate ice) async {
    pc.addCandidate(ice);
  }

  void _switchCamera() {
    if (_localStream != null) {
      _localStream.getVideoTracks()[0].switchCamera();
    }
  }

  Future<void> _closeSession() async {
    _localStream?.getTracks().forEach((element) async {
      await element.stop();
    });
    await _localStream?.dispose();
    _localStream = null;

    await pc.close();
  }

  void _hangUp() {
    _closeSession();
    if (_localStream != null) {
      _localStream.dispose();
      _localStream = null;
    }
    _localRenderer.dispose();
    //  _localStream.dispose();
    Navigator.pop(context);
  }

  void _muteMic() {
    if (_localStream != null) {
      bool enabled = _localStream.getAudioTracks()[0].enabled;
      //print(enabled);
      _localStream.getAudioTracks()[0].enabled = !enabled;
    }
  }

/*
leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: primary,
        ),
      ),
      */
  Widget getAppBar() {
    return AppBar(
      //backgroundColor: Colors.white.withOpacity(0.18),
      backgroundColor: greyColor,
      elevation: 0,
      title: Container(
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Container(
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            )
          ],
        ),
      ),
      leading: GestureDetector(
        onTap: () {
          _closeSession();
          if (_localStream != null) {
            _localStream.dispose();
            _localStream = null;
          }

          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("voici l'affichage");
    print(_remoteRenderer);
    return MaterialApp(
        home: Scaffold(
            appBar: getAppBar(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
                width: 200.0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FloatingActionButton(
                        child: const Icon(Icons.switch_camera),
                        onPressed: _switchCamera,
                      ),
                      FloatingActionButton(
                        onPressed: _hangUp,
                        tooltip: 'Hangup',
                        child: Icon(Icons.call_end),
                        backgroundColor: Colors.pink,
                      ),
                      FloatingActionButton(
                        child: const Icon(Icons.mic_off),
                        onPressed: _muteMic,
                      )
                    ])),
            body: OrientationBuilder(builder: (context, orientation) {
              return Container(
                child: Stack(children: <Widget>[
                  Positioned(
                      left: 0.0,
                      right: 0.0,
                      top: 0.0,
                      bottom: 0.0,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        width: 300.0,
                        height: 200.0,
                        child: RTCVideoView(_remoteRenderer),
                       // decoration: BoxDecoration(color: Colors.black54),
                      )),
                  Positioned(
                    right: 20.0,
                    top: 20.0,
                    child: Container(
                      width: orientation == Orientation.portrait ? 90.0 : 120.0,
                      height:
                          orientation == Orientation.portrait ? 150.0 : 110.0,
                      child: RTCVideoView(_localRenderer, mirror: true),
                      //                         decoration: BoxDecoration(color: Colors.black54),
                    ),
                  ),
                ]),
              );
            })));
  }
}
