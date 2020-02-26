import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muitou/bloc/data_collected_bloc.dart';
import 'package:muitou/bloc/data_collected_event.dart';
import 'package:muitou/bloc/data_collected_state.dart';
import 'package:muitou/models/data_collected.dart';
import 'package:muitou/models/project.dart';
import 'package:muitou/pages/data_entry_page.dart';

import '../models/project.dart';
import '../models/xorm_detail.dart';

class DataViewPage extends StatelessWidget {
  int id;
  DataCollected _data;
  XormDetails _currentXormDetails;

  DataCollectedBloc _dataCollectedBloc;

  DataViewPage({Key key, @required this.id }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    this._dataCollectedBloc = context.bloc<DataCollectedBloc>();
    this._dataCollectedBloc.add(QueryDataCollected(id: this.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('Data'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DataEntryPage(
                    currentXorm: this._data.form, 
                    id: this._data.id
                  )
                ),
              );
            },
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
                _dataCollectedBloc.add(DeleteDataCollected(data: this._data));
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
      body: BlocBuilder(
        bloc: _dataCollectedBloc,
        builder: (BuildContext context, DataCollectedState state) {
          if (state is DataCollectedLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } 
          if (state is DataCollectedLoaded && state.datas.length == 1) {
            print("\nDATA COLLECTED....\n");
            this._data = state.datas.first;            
            print(this._data.toJson());
            this._currentXormDetails = Project.instance.xormsDetails.firstWhere((x) => x.id == this._data.form);
            print(this._currentXormDetails.toJson());
            print("\n");
            return this._currentXormDetails.view(this._data.values);
          }
          
          return Container();
        },
      )
    );
 }

}