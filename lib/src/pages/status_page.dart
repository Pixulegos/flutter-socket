import 'package:band_names/src/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class StatusPage extends StatelessWidget {
  const StatusPage({super.key});


  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          socketService.socket.emit('new-msg', {'name': 'Flutter', 'msg': 'Hola desde Flutter'});
        },
        child: Icon(Icons.message),  
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(socketService.getIcon(), size: 60),
            Text('Server Status: ${socketService.serverStatus}'),
          ],
        ),
     ),
   );
  }
}