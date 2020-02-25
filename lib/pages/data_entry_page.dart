import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muitou/bloc/data_collected_bloc.dart';
import 'package:muitou/bloc/data_collected_event.dart';
import 'package:muitou/bloc/data_collected_state.dart';
import 'package:muitou/models/data_collected.dart';
import 'package:muitou/models/project.dart';

import '../models/project.dart';
import '../models/xorm_detail.dart';

class DataEntryPage extends StatefulWidget {
  DataEntryPage({Key key, this.currentXorm, this.id = 0, this.values = const {} }) : super(key: key);

  final String currentXorm;
  final int id;
  final Map<String, Map<String, String>> values;

  @override
  _DataEntryPageState createState() => _DataEntryPageState();
}

class _DataEntryPageState extends State<DataEntryPage> {
  DataCollectedBloc _dataCollectedBloc;
  XormDetails _currentXormDetails;

  PageController controller = PageController();
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  int currentPageViewPosition = 0;

  // Map<String, Map<String, String>> data = {};
  DataCollected data;

  @override
  void initState() {
    super.initState();

    _dataCollectedBloc = context.bloc<DataCollectedBloc>();  
    
    if (widget.id == 0) {
      this.data = DataCollected(form: widget.currentXorm, values: {});
    } else {
      _dataCollectedBloc.add(QueryDataCollected(id: widget.id));
    }

    setState(() {
      currentPageViewPosition = 0;
    });
  }

  Widget _buildPage(int position) {
    XormSection currentXormSection = this._currentXormDetails.sections[position];
    print("\_BUILD PAGE.... ${currentXormSection.id}");
    print(currentXormSection.toJson());
    print("\nRETURN WIDGETS....");

    List<Widget> widgets = <Widget>[
      Text(
        currentXormSection.params.title,
        style: Theme.of(context).textTheme.title,
      ),
      Text(
        currentXormSection.params.description,
        style: Theme.of(context).textTheme.subtitle,
      ),

      currentXormSection.build(data: this.data.values.containsKey(currentXormSection.id) ? this.data.values[currentXormSection.id] : {} )
    ];

    return ListView(
      children: widgets,
      scrollDirection: Axis.vertical,
    );
  }

  Widget buildPageView() {
    bool isLastPage = this.currentPageViewPosition == this._currentXormDetails.sections.length - 1;
    
    return Column(
      children: <Widget>[
        Expanded(
          child: 
          PageView.builder(
            controller: controller,
            itemBuilder: (context, position) {
              return _buildPage(position);
            },
            onPageChanged: (int page) {
              setState(() {
                this.currentPageViewPosition = page;
              });
            },
          ),
          flex: 1,
        ),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              child: Text("Previous"),
              color: Colors.blue,
              onPressed: () {
                this.controller.previousPage(duration: _kDuration, curve: _kCurve);
              },
            ),
            FlatButton(
              child: Text(isLastPage ? "Save it" : "Next"),
              color: Colors.blue,
              onPressed: () {
                final XormSection currentSection = this._currentXormDetails.sections[this.currentPageViewPosition];
                final String currentSectionKey = currentSection.id;
                Map<String, dynamic> currentSectionData = new Map();

                if (currentSection.sectionKey.currentState.saveAndValidate()) {
                  currentSectionData = currentSection.sectionKey.currentState.value; //.cast<String, String>();
                  
                  if (currentSectionData.isEmpty) {
                    this.data.values[currentSectionKey] = {};
                  } else {
                    final ca = currentSectionData.map((key, value) {
                      return MapEntry(key, value != null ? value.toString() : "");
                    });
                    // this.data.values[currentSectionKey] = ca;
                    this.data.values.update(currentSectionKey, 
                      (existingValue) => ca,
                      ifAbsent: () => ca
                    );
                  }
                }

                if (isLastPage) {
                  if (widget.id == 0) {
                    // this._dataCollectedBloc.add(AddDataCollected(data: new DataCollected(values: this.data, form: _currentXormDetails.id)));
                    this._dataCollectedBloc.add(AddDataCollected(data: this.data));
                  } else {
                    this._dataCollectedBloc.add(UpdateDataCollected(data: this.data));
                    // this._dataCollectedBloc.add(UpdateDataCollected(data: new DataCollected(values: this.data, id: widget.id, form: widget.currentXorm)));
                  }
                  
                  
                  Navigator.of(context).pop();
                } else {               
                  this.controller.nextPage(duration: _kDuration, curve: _kCurve);
                }
              },
            ),
          ],
        ) 
      ],      
    );
  }

  @override
  Widget build(BuildContext context) {
    print("\nBUILD... ${widget.currentXorm}");
    // this._currentXormDetails = Project.instance.xormsDetails.firstWhere((x) => x.id == widget.currentXorm);
    print("\nIn CURRENTXORM DETAILS");
    this._currentXormDetails = Project.instance.xormsDetails.firstWhere((x) {
      print("${x.id}---${widget.currentXorm}---${x.id.trim() == widget.currentXorm.trim()}");
      print("\n");
      return  x.id == widget.currentXorm;
    });

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
      body: BlocBuilder(
        bloc: _dataCollectedBloc,
        builder: (BuildContext context, DataCollectedState state) {
          if (state is DataCollectedLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } 
          if (widget.id > 0 && state is DataCollectedLoaded && state.datas.length == 1) {
            
            if (state.datas.first == null) {
              this.data = DataCollected(form: widget.currentXorm, values: {});
            } else {
              this.data = state.datas.first;            
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                top: 8.0
              ),
              child: buildPageView()
            );
          }

          return Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 8.0
            ),
            child: buildPageView()
          );
        }
      )
    );
  }
}