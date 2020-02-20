import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart'; // show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:muitou/bloc/data_collected_bloc.dart';
import 'package:muitou/bloc/data_collected_event.dart';
import 'package:muitou/bloc/data_collected_state.dart';
import 'package:muitou/models/data_collected.dart';
import 'package:muitou/models/project.dart';
import 'package:muitou/models/xorm.dart';
import 'package:muitou/pages/data_entry_page.dart';
import 'package:muitou/pages/data_view_page.dart';

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
    return BlocProvider(
      create: (BuildContext context) => DataCollectedBloc(),
      child: MaterialApp(
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
        home: MyHomePage(title: 'Home'),
      )
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
  DataCollectedBloc _dataCollectedBloc;

  final List<Xorm> _xormsList = [
    Xorm(id:"all", title:"All")
  ];

  Xorm _currentlySelectedXorm = Xorm(id:"all", title:"All");

  @override
  void initState() {
    super.initState();

    _dataCollectedBloc = context.bloc<DataCollectedBloc>();  //BlocProvider.of<DataCollectedBloc>(context);
    _dataCollectedBloc.add(LoadDataCollected());  
  }

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

  Widget _buildBody() {
    return BlocBuilder(
      bloc: _dataCollectedBloc,
      builder: (BuildContext context, DataCollectedState state) {
        if (state is DataCollectedLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } 
        if (state is DataCollectedLoaded) {
          return ListView.builder(
            itemCount: state.datas.length,
            itemBuilder: (context, index) {
              final data = state.datas[index];

              return ListTile(
                title: Text(data.id.toString()),
                subtitle: Text(Jiffy(data.createdAt).fromNow()),
                trailing: _buildActionButtons(data),
                onTap: () => this._onOpenData(data),
              );
            },
          );
        }
        
        return Container();
      },
    );
  }

  void _onOpenData(DataCollected data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataViewPage(
          id: data.id
        )
      ),
    ).then((onValue) {
      this._dataCollectedBloc.add(LoadDataCollected());
    });
  }

  void _onUpdateData(DataCollected data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataEntryPage(
          currentXorm: data.form, 
          id: data.id,
          values: data.values.map((key, vals) {
            return MapEntry(key.toString(), Map<String, String>.from(vals));
          })
        )
      ),
    );
  }

  Widget _buildActionButtons(DataCollected data) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.visibility),
          onPressed: () => this._onOpenData(data),
        ),
        IconButton(
          icon: Icon(Icons.edit),
          onPressed: () => this._onUpdateData(data)
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            bool isDeleted = await showDialog<bool>(
              context: context,
              barrierDismissible: false, // user must tap button for close dialog!
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Delete Data?'),
                  content: const Text(
                    'Are you sure you want to delete that data?'    
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: const Text('NO'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    FlatButton(
                      child: const Text('YES'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    )
                  ],
                );
              },
            );

            if (isDeleted) {
              _dataCollectedBloc.add(DeleteDataCollected(data: data));
            }
          },
        )
      ],
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
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _fillAXorm,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
