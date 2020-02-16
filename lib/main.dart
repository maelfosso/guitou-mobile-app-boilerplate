import 'package:flutter/material.dart';

void main() => runApp(MyApp());

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

  final List<String> _xormsList = [
    "All",
    "Questionnaire Radio Communautaire",
    "Questionnaire Promoteur",
    "Questionnaire Beneficiaire",
    // "One",
    // "Two",
    // "Three",
    // "Four",
    // "Five"
  ];
  String _currentlySelectedXorms;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }


  Future<String> _asyncSelectXormDialog(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select the xorm'),
          children: this._xormsList.skip(1).map((String xorm) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, xorm);
              },
              child: Text(xorm),
            );
          }).toList(),
        );
      });
    }

    Widget filterByXormWidget() {
      return DropdownButtonHideUnderline(
          child: DropdownButton(
            onChanged: (String value) {
              setState(() {
                this._currentlySelectedXorms = value;
              });
            },
            // selectedItemBuilder: (BuildContext context) {
            //   return _xormsList.map<Widget>((String text) {
            //     return Text(text, maxLines: 1, style: TextStyle(color: Colors.white));
            //   }).toList();
            // },
            items: _xormsList.map<DropdownMenuItem<String>>((String text) {
              return DropdownMenuItem<String>(
                value: text,
                child:Text(text) //, maxLines: 2, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            isExpanded: true,
            value: this._currentlySelectedXorms
          )
      );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
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
            this._currentlySelectedXorms != "All" ? Text(
              this._currentlySelectedXorms,
              style: TextStyle(fontSize: 14.0),
            ) : Container()
          ],
        ),
        // centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              print("Open the dialog xorms selection.");
            },
          ),
          // Container(
          //   width: 50.0,
          //   child: filterByXormWidget(),
          // ),
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                this._currentlySelectedXorms = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return _xormsList.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: 
                  Row(
                    children: [
                      this._currentlySelectedXorms == choice ? Icon(Icons.check, color: Colors.black,) : Container(),
                      Expanded(
                        child: Text(choice),
                        flex: 1,
                      )
                    ]
                    
                  ),
                  // Text(choice)
                );
              }).toList();
            },
          )
          // filterByXormWidget()
        ],
        // titleSpacing: 200.0,
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
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
