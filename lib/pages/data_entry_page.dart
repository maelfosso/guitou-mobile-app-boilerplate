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
import '../models/xorm_detail.dart';

class DataEntryPage extends StatefulWidget {
  DataEntryPage({Key key, this.currentXorm}) : super(key: key);

  final String currentXorm;

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

  Map<String, Map<String, String>> data = {};

  @override
  void initState() {
    super.initState();

    _dataCollectedBloc = context.bloc<DataCollectedBloc>();  //BlocProvider.of<DataCollectedBloc>(context);

    setState(() {
      currentPageViewPosition = 0;
    });
  }

  Widget _buildPage(int position) {
    XormSection currentXormSection = this._currentXormDetails.sections[position];

    List<Widget> widgets = <Widget>[
      Text(currentXormSection.params.title),
      Text(currentXormSection.params.description),

      currentXormSection.build(data: this.data.containsKey(currentXormSection.id) ? this.data[currentXormSection.id] : {} )
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
                  print(currentSection.sectionKey.currentState.value);
                  currentSectionData = currentSection.sectionKey.currentState.value; //.cast<String, String>();
                  
                  this.data[currentSectionKey] = currentSectionData.map((key, value) {
                    return MapEntry(key, value.toString());
                  });
                }

                if (isLastPage) {
                  print("\nIS LAST PAGE");
                  print(this.data);
                  print("\n");
                  
                  this._dataCollectedBloc.add(AddDataCollected(data: new DataCollected(values: this.data, form: _currentXormDetails.id)));
                  
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
    this._currentXormDetails = Project.instance.xormsDetails.firstWhere((x) => x.id == widget.currentXorm);

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
          return buildPageView();
        }
      )
    );
  }
}