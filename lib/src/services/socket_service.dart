import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

enum ServerStatus {
  online,
  offline,
  connecting
}

class SocketService with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.connecting;
  late io.Socket _socket;

  SocketService(){
    _initConfig();
  }

  ServerStatus get serverStatus => _serverStatus;

  set serverStatus(ServerStatus value){
    _serverStatus = value;
    notifyListeners();
  }

  io.Socket get socket => _socket;

  IconData getIcon(){
    switch(serverStatus){
      case ServerStatus.online:
        return Icons.wifi;
      case ServerStatus.offline:
        return Icons.wifi_off;
      case ServerStatus.connecting:
        return Icons.wifi_find;
    }
  }

  void _initConfig(){
    
    _socket = io.io('http://localhost:3001', {
      'transports': ['websocket'],
      'autoConnect': true
    });

    _socket.on('connect', (data) {
      print('connect');
      serverStatus = ServerStatus.online;
    });

    _socket.on('disconnect', (data) { 
      print('disconnect');
      serverStatus = ServerStatus.offline;
    });

    _socket.on('new-msg', (payload) {
      print('New message: ${payload['name']}${payload.containsKey('msg') ? ', ${payload['msg']}' : ''}');
    });
  }

}