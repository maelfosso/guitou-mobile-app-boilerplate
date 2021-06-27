import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guitou/models/data.dart';
import 'package:guitou/models/data_model.dart';
import 'package:guitou/models/project.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class DataItem extends StatelessWidget {
  final int dataIndex;

  DataItem({ this.dataIndex });


  void openData(Data data) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => DataViewPage(
    //       id: data.id
    //     )
    //   ),
    // ).then((onValue) {
    //   this._dataCollectedBloc.add(DataLoad());
    // });
  }

  void _onUpdateData(Data data) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => DataEntryPage(
    //       currentXorm: data.form, 
    //       id: data.id,
    //     )
    //   ),
    // ).then((onValue) {
    //   this._dataCollectedBloc.add(DataLoad());
    // });
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<DataModel>(
      builder: (context, datas, child) {
        Data data = datas.datasList[this.dataIndex];
        final first = data.values.values.first;
        final form = Project.instance.xorms.firstWhere((x) => x.id == data.form).title;

        return ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    (first as Map)["Q00"].toString(),
                    style: Theme.of(context).textTheme.headline3
                  ),
                  Text(Jiffy(data.createdAt).fromNow())
                ],
              ),
              Chip(
                label: Text(form),
                labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
              ),
              // _buildActionButtons(data),
              Row(
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
                              TextButton(
                                child: const Text('NO'),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                              ),
                              TextButton(
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
                        // _dataCollectedBloc.add(DataDeleted(data));
                      }
                    },
                  ),        
                ],
              )
            ]
          ),
          onTap: () => this.openData(data),
        );
      }
    );
  }
}