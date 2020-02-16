import 'package:flutter/material.dart';

class DataEntryPage extends StatefulWidget {
  DataEntryPage({Key key, this.currentXorm}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String currentXorm;

  @override
  _DataEntryPageState createState() => _DataEntryPageState();
}


class _DataEntryPageState extends State<DataEntryPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              "Data Entry",
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              widget.currentXorm,
              style: TextStyle(fontSize: 14.0),
            )
          ],
        ),
      ),
      body: Center(
        child: Text("Data Entry Page"),
      ),
    );
  }
}