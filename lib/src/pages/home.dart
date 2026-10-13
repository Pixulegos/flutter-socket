import 'dart:io';

import 'package:band_names/src/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Necrogoblikon', votes: 0),
    Band(id: '3', name: 'Muse', votes: 1),
    Band(id: '4', name: 'Marina', votes: 2)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Band Names', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: _addNewBand,
        child: Icon(Icons.add)
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, index) 
          => _bandTile(bands[index])
        
      )
   );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print('direction $direction');


      },
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
            onTap: () => print('tap ${band.name}'),
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
      bands.add( Band(id: DateTime.now().toString(), name: name) );
    }

    setState(() {});
    Navigator.pop(context);
  }
}