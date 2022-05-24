String URL = 'http://192.168.221.208:3000';
//String URL = 'http://localhost:3000';
var socket_config = [
  'websocket',
  'flashsocket',
  'htmlfile',
  'xhr-polling',
  'jsonp-polling',
  'polling'
];

var socket_config1 = [
  'websocket',
];

var videoConstraintsPhone = {
  'audio': true,
  'video': {'facingMode': 'user'}
};

var videoConstraintsPhone1 = {'audio': true, 'video': true};
var videoConstraintsPhone2 = {
  'audio': true,
  'video': {
    'mandatory': {
      'minWidth': '1280',
      'minHeight': '720',
      'minFrameRate': '60',
    },
    'optional': []
  },
};

var videoConstraintsWeb = {
  'audio': true,
  'video': {
    'mandatory': {
      'minWidth': '540.0', // Provide your own width, height and frame rate here
      'minHeight': '480.0',
      'minFrameRate': '30.0',
    },
    'facingMode': 'user',
    'optional': [],
  }
};

/*
  _mediaDevicesList = await Helper.cameras;

{
  'audio': false,
  'video': {
    'mandatory': {
      'minWidth': '1280',
      'minHeight': '720',
      'minFrameRate': '60',
    },
    'optional': [
      {'sourceId': _mediaDevicesList?[0].deviceId}
    ]
  },
}
*/
