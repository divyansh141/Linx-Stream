import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';

var auth = FirebaseAuth.instance;
var fs = FirebaseFirestore.instance;

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  var textColor = Hexcolor('#001b48');
  List<Widget> history = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.code),
        title: Text('Linx'),
        backgroundColor: textColor,
      ),
      backgroundColor: textColor,
      body: StreamBuilder<QuerySnapshot>(
        builder: (context, snapshot) {
          var hisData = snapshot.data.docs;

          for (var x in hisData) {
            var cmd = x.data()['command'];
            var cmdName = Text(cmd,
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold));
            var cmdOutx = x.data()['output'];
            var cmdOut = Text(cmdOutx, style: TextStyle(color: Colors.black));
            var y = Text('$cmd:$cmdOut');
            var out = ListTile(
              title: cmdName,
              subtitle: cmdOut,
            );
            // var out = Text(
            //   '$cmdName : $cmdOut',
            //   style: TextStyle(color: Colors.white),
            // );
            history.add(out);
          }

          return ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: history.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: history[index],
                  ),
                );
              });
        },
        stream: fs.collection('output').snapshots(),
      ),
    );
  }
}
