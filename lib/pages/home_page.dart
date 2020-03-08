import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guitou/models/project.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:jiffy/jiffy.dart';

import 'package:guitou/bloc/data_collected_bloc.dart';
import 'package:guitou/bloc/data_collected_event.dart';
import 'package:guitou/bloc/data_collected_state.dart';

import 'package:guitou/models/data_collected.dart';
import 'package:guitou/models/xorm.dart';


import 'package:guitou/pages/data_entry_page.dart';
import 'package:guitou/pages/data_view_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DataCollectedBloc _dataCollectedBloc;
  List<DataCollected> datas = [];
  List<DataCollected> datasToUpload = [];
  int datasUploaded = 0;

  ProgressDialog pr, prn; 

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
    if (selectedXorm != null && selectedXorm.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DataEntryPage(currentXorm: selectedXorm)),
      );
    }
  }

  void _uploadLocalData() async {
    this._dataCollectedBloc.add(UploadDataCollected());
  }

  void _downloadXorm() async {
    this._dataCollectedBloc.add(DownloadProject());
    this.prn.style(
      message: 'Download update...',
    );
    await this.prn.show();
  }

  void _showEndOperationDialog(String title, String body) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> _asyncSelectXormDialog(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select the xorm'),
          children: Project.instance.xorms.map((Xorm xorm) {
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
    return BlocListener<DataCollectedBloc, DataCollectedState>(
      listener: (context, state) async {
        
        if (state is DownloadProjectSuccess) {
          print("BUILD BODY: DOWNLOAD PROJECT SUCCESSS");
          
          return this.prn.hide().then((onValue) {
            _showEndOperationDialog("Download", "Successful");
          });
        }

        if (state is DownloadProjectFailed) {
          print("BUILD BODY: DOWNLOAD PROJECT FAILED");

          return this.prn.hide().then((onValue) {
            final snackBar = SnackBar(
              content: Text('Error occured when downloading!'),
              action: SnackBarAction(
                label: 'Try again',
                onPressed: () => _downloadXorm(),
              ),
            );
            Scaffold.of(context).showSnackBar(snackBar);
          });
        }

        if (state is StartUploadingLocalData) {
          this.datasToUpload = state.datas;

          if (this.datasToUpload.length == 0) {
            final snackBar = SnackBar(content: Text('No data to upload!!'));
            Scaffold.of(context).showSnackBar(snackBar);

            return;
          }

          this.pr.style(
            message: 'Uploading data...',
            progress: 0.0,
            maxProgress: 100.0,
            progressTextStyle: TextStyle(
              color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
            messageTextStyle: TextStyle(
              color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
          );
          await this.pr.show();

          this._dataCollectedBloc.add(RemoteAddDataCollected(data: this.datasToUpload[this.datasUploaded]));
          return;
        }

        if (state is SuccessRemoteAddDataCollected) {
          this.datasUploaded++;

          Future.delayed(Duration(seconds: 0)).then((onvalue) {
            pr.update(progress: 100 * this.datasUploaded.toDouble()/this.datasToUpload.length, message: "Please wait...");
          });

          if (this.datasToUpload.length == this.datasUploaded) {
            
            this._dataCollectedBloc.add(EndUploadingLocalData());
            this.datasUploaded = 0;
            await this.pr.hide();

            _showEndOperationDialog("Data uploaded", 'All the data has been correctly uploaded.');
          } else {
            this._dataCollectedBloc.add(RemoteAddDataCollected(data: this.datasToUpload[this.datasUploaded]));
          }
          return;
        }
      },
      child: BlocBuilder(
        bloc: _dataCollectedBloc,
        builder: (BuildContext context, DataCollectedState state) {
          if (state is DataCollectedLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } 
          if (state is DataCollectedLoaded) {
            this.datas = state.datas;
          }

          return ListView.builder(
            itemCount: this.datas.length,
            itemBuilder: (context, index) {
              final data = this.datas[index];

              return ListTile(

                title: Text(data.id.toString()),
                subtitle: Text(Jiffy(data.createdAt).fromNow()),
                trailing: _buildActionButtons(data),
                onTap: () => this._onOpenData(data),
              );
            },
          );
        },
      )
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
          // values: data.values.map((key, vals) {
          //   return MapEntry(key.toString(), Map<String, String>.from(vals));
          // })
        )
      ),
    ).then((onValue) {
      this._dataCollectedBloc.add(LoadDataCollected());
    });
  }

  Widget _buildActionButtons(DataCollected data) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[

        IconButton(
          icon: Icon(
            Icons.cloud_done,
            color: data.dataLocation == "remote" ? Colors.blue : null
          ),
          
          onPressed: () {},
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
        ),        
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    this.pr = ProgressDialog(context,
      type: ProgressDialogType.Download, 
      isDismissible: true, 
      showLogs: true
    );
    this.prn = ProgressDialog(context,
      type: ProgressDialogType.Normal, 
      isDismissible: true, 
      showLogs: true
    );
    

    if (this._xormsList.length == 1) {
      this._xormsList.addAll(Project.instance.xorms);
    }

    // var permissionStatus = await _permissionHandler.checkPermissionStatus(PermissionGroup.location);

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
            icon: Icon(Icons.cloud_download),
            onPressed: _downloadXorm
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _fillAXorm
          ),
          IconButton(
            icon: Icon(Icons.cloud_upload),
            onPressed: _uploadLocalData
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
