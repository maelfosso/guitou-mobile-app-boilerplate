import 'package:flutter/material.dart';
import 'package:muitou/models/project.dart';

class DataEntryPage extends StatefulWidget {
  DataEntryPage({Key key, this.currentXorm}) : super(key: key);

  final String currentXorm;

  @override
  _DataEntryPageState createState() => _DataEntryPageState();
}

class _DataEntryPageState extends State<DataEntryPage> {

  @override
  Widget build(BuildContext context) {
    String currentXormTitle = Project.instance.xorms.firstWhere((x) => x.id == widget.currentXorm).title;

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
              currentXormTitle,
              style: TextStyle(fontSize: 14.0),
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: Project.instance.xormsDetails.map((xormDetails) => Text(xormDetails.id)).toList()
          // <Widget>[],
        )
      ),
    );
  }
}