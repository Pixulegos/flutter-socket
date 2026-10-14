import 'dart:io';

import 'package:band_names/src/models/band.dart';
import 'package:band_names/src/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket.on('active-bands', _handleActiveBands);

    super.initState();
  }

  void _handleActiveBands(dynamic payload){
    bands = List<Band>.from(payload.map((e) => Band.fromMap(e)));
    Future.microtask(() => setState(() {}));
  }

  @override
  void dispose() {
    Provider.of<SocketService>(context, listen: false).socket.off('activeBands');

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Band Names', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            child:
              socketService.serverStatus == ServerStatus.online
              ? Icon(Icons.check_circle, color: Colors.blue[300])
              : Icon(Icons.offline_bolt, color: Colors.red) 
              //Icon(socketService.getIcon()),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: _addNewBand,
        child: Icon(Icons.add)
      ),
      body: Column(
        children: [
          if(bands.isNotEmpty) _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, index) 
                => _bandTile(bands[index])
              
            ),
          ),
        ],
      )
   );
  }

  Widget _bandTile(Band band) {
    final emit = Provider.of<SocketService>(context, listen: false).
                          socket.emit;

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) => emit('delete-band', { 'id': band.id }),
      background: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        color: Colors.red,
        alignment: Alignment.centerLeft,
        child: Row(
          spacing: 4,
          children: [
            Icon(Icons.delete_outline,color: Colors.white),
            Text('Delete Band', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              //foregroundColor: Colors.white,
              child: Text(band.name.substring(0,2)),
            ),
            title: Text(band.name),
            trailing: Text('${band.votes}', style: TextStyle(fontSize: 20)),
            onTap: () => emit('vote-band', { 'id': band.id })
          ),
    );
  }

  void _addNewBand(){
    final textController = TextEditingController();

    Platform.isAndroid 
      ? showDialog(
        context: context, 
        builder: (context) => 
          AlertDialog(
            title: Text('New band name'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                onPressed: () =>
                  _addBandToList(textController.text),
                elevation: 5,
                textColor: Colors.blue,
                child: Text('Add'),
              )
            ],
          )
      )
      : showCupertinoDialog(
        context: context, 
        builder: (context) =>
          CupertinoAlertDialog(
            title: Text('New band name'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Add'),
                onPressed: ()=> _addBandToList(textController.text),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('Dismiss'),
                onPressed: ()=> Navigator.pop(context)
              ),
            ],
          )
      );
  }

  void _addBandToList(String name){
    if( name.length > 1 ){
      Provider.of<SocketService>(context, listen: false).
                          socket.emit('add-band', { 'name': name });
    }

    Navigator.pop(context);
  }

  Widget _showGraph(){
    Map<String, double> dataMap = {};
    for (var element in bands) {
      dataMap.putIfAbsent(element.name, () => element.votes.toDouble());
    }

    return SizedBox(
      width: double.infinity,
      height: 250,
      child: PieChart(
        chartLegendSpacing: 32,
        chartValuesOptions: ChartValuesOptions(
          showChartValuesInPercentage: true,
          chartValueBackgroundColor: Colors.transparent
        ),
        dataMap: dataMap));
  }
}