import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart'; // show rootBundle;
import 'package:muitou/models/project.dart';
import 'package:muitou/models/xorm.dart';
import 'package:muitou/pages/data_entry_page.dart';

Future<String> _loadProjectAsset() async {
  return await rootBundle.loadString('assets/project.json');
}

Future<Project> loadProject() async {
  String jsonString = await _loadProjectAsset();
  final jsonResponse = json.decode(jsonString);
  return new Project.fromJson(jsonResponse);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIOverlays([]);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await loadProject();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Collected Data'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  final List<Xorm> _xormsList = [
    Xorm(id:"all", title:"All")
  ];

  Xorm _currentlySelectedXorm = Xorm(id:"all", title:"All");

  void _fillAXorm() async {
    String selectedXorm = await _asyncSelectXormDialog(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DataEntryPage(currentXorm: selectedXorm)),
    );
  }

  Future<String> _asyncSelectXormDialog(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select the xorm'),
          children: this._xormsList.skip(1).map((Xorm xorm) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, xorm.id);
              },
              child: Text(xorm.title),
            );
          }).toList(),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    if (this._xormsList.length == 1) {
      this._xormsList.addAll(Project.instance.xorms);
    }

    // This method is rerun every time setState is called, for instance as done
    // by the _fillAXorm method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        // title: Text(widget.title),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              widget.title,
              style: TextStyle(fontSize: 20.0),
            ),
            this._currentlySelectedXorm != null && this._currentlySelectedXorm.id != "all" ? Text(
              this._currentlySelectedXorm.title,
              style: TextStyle(fontSize: 14.0),
            ) : Container()
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _fillAXorm
          ),
          PopupMenuButton<Xorm>(
            onSelected: (Xorm value) {
              setState(() {
                this._currentlySelectedXorm = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return _xormsList.map((Xorm choice) {
                return PopupMenuItem<Xorm>(
                  value: choice,
                  child: 
                  Row(
                    children: [
                      this._currentlySelectedXorm.id == choice.id ? Icon(
                        Icons.check, 
                        color: Colors.black
                      ) : Container(),
                      Expanded(
                        child: Text(choice.title),
                        flex: 1,
                      )
                    ]                    
                  ),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fillAXorm,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
