import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:hexcolor/hexcolor.dart';

var fsconnect = FirebaseFirestore.instance;

class CommandPage extends StatefulWidget {
  @override
  _CommandPageState createState() => _CommandPageState();
}

class _CommandPageState extends State<CommandPage> {
  String cmd;
  String webdata;
  var getHis;

  var containerBg = Hexcolor('#ffffff');
  var textColor = Hexcolor('#001b48');
  var buttonColor = Hexcolor('#008866');
  var btextColor = Hexcolor('#ffffff');

  web(cmd) async {
    var url = "http://192.168.43.14/cgi-bin/command.py?x=$cmd";
    var response = await http.get(url);
    setState(() {
      webdata = response.body;
    });
    fsconnect.collection('output').add({'command': cmd, 'output': webdata});

    print(response.body);
  }

  myget() async {
    var d = await fsconnect.collection('output').get();

    for (var i in d.docs) {
      print(i.data());
    }
  }

  var textControl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.code),
        title: Text('Linx'),
        backgroundColor: textColor,
        actions: [
          IconButton(
              icon: Icon(Icons.history),
              onPressed: () {
                Navigator.pushNamed(context, '/history',
                    arguments: {cmd: cmd, webdata: webdata});
              }),
        ],
      ),
      backgroundColor: textColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              margin: EdgeInsets.all(10),
              //padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black38,
                    offset: Offset(0, 0),
                    blurRadius: 15.0,
                  ),
                ],
              ),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(vertical: 20),
                color: Colors.black,
                child: SingleChildScrollView(
                  child: Text(
                    webdata ?? 'Your Output will appear here',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
              decoration: BoxDecoration(
                color: containerBg,
                borderRadius: BorderRadius.circular(20),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black38,
                    offset: Offset(0, 0),
                    blurRadius: 15.0,
                  ),
                ],
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    'Linux Commands',
                    style: TextStyle(
                      color: textColor,
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: textControl,
                    autocorrect: false,
                    onChanged: (value) {
                      cmd = value;
                    },
                    onSubmitted: (cmd) => web(cmd),
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        labelText: 'Type Command',
                        suffixIcon: IconButton(
                            icon: Icon(
                              Icons.send,
                              color: buttonColor,
                            ),
                            onPressed: () => web(cmd)),
                        contentPadding: EdgeInsets.all(8)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
