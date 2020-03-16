import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:guitou/bloc/data_collected_bloc.dart';
import 'package:guitou/bloc/data_collected_event.dart';
import 'package:guitou/bloc/data_collected_state.dart';
import 'package:guitou/models/data_collected.dart';
import 'package:guitou/models/project.dart';

import '../models/project.dart';
import '../models/xorm_detail.dart';

class DataEntryPage extends StatefulWidget {
  DataEntryPage({Key key, this.currentXorm, this.id = 0 }) : super(key: key);

  final String currentXorm;
  final int id;

  @override
  _DataEntryPageState createState() => _DataEntryPageState();
}

class _DataEntryPageState extends State<DataEntryPage> {
  DataCollectedBloc _dataCollectedBloc;
  XormDetails _currentXormDetails;

  PageController controller = PageController();
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  XormSection currentXormSection;
  GlobalKey<FormBuilderState> currentXormSectionKey;
  int currentSectionPosition = 0;
  int currentSectionDataPosition = 0;
  bool repeatIt = false;

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
      currentSectionPosition = 0;
      currentSectionDataPosition = 0;
      repeatIt = false;
    });
  }

  Future<String> _asyncInputDialog(BuildContext context) async {
    String repeatValue = '';

    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('How many times repeat it'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: currentXormSection.params.repeatMaxTimes == "inner" ? currentXormSection.params.repeatMaxTimesInner : null, 
                  ),
                  onChanged: (value) {
                    repeatValue = value;
                  },
                )
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(repeatValue);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPage(int position) {
    this.currentXormSectionKey = GlobalKey<FormBuilderState>();
    
    Map<String, dynamic> initData;
    if (this.currentXormSection.params.repeat ?? false) {
      if (this.repeatIt) {
        initData = {};
      } else {
        if (this.data.values.containsKey(currentXormSection.id)) {
          initData =  (this.data.values[currentXormSection.id] as List).length > 0 ? (this.data.values[currentXormSection.id] as List)[currentSectionDataPosition] : {};
        } else {
          initData = {};
        }
      }
    } else {
      initData = this.data.values.containsKey(currentXormSection.id) ? this.data.values[currentXormSection.id] : {};
    }

    var formElts = currentXormSection.build(
      context: context,
      globalKey: this.currentXormSectionKey, 
      data: initData
    );

    List<Widget> widgets = <Widget>[
      Text(
        currentXormSection.params.title,
        style: Theme.of(context).textTheme.title,
      ),
      Text(
        currentXormSection.params.description,
        style: Theme.of(context).textTheme.subtitle,
      ),

      formElts
    ];

    return ListView(
      children: widgets,
      scrollDirection: Axis.vertical,
    );

  }

  Widget buildPageView() {
    bool isLastPage = this.currentSectionPosition == this._currentXormDetails.sections.length - 1;
    
    return Column(
      children: <Widget>[
        Expanded(
          child: 
          PageView.builder(
            physics:new NeverScrollableScrollPhysics(),
            controller: controller,
            itemBuilder: (context, position)  {
              return _buildPage(position);
            },

            onPageChanged: (int page) async {
              this.currentXormSection = this._currentXormDetails.sections[this.currentSectionPosition];

              if (this.repeatIt) {
                return;
              }

              if ((this.currentXormSection.params.repeat ?? false) && 
                (currentXormSection.params.repeatMaxTimes == "inner" || currentXormSection.params.repeatMaxTimes == "fixed")) {

                var repeatValue = await _asyncInputDialog(context);

                if (currentXormSection.params.repeatMaxTimes == "inner") { // INNER
                  if (this.data.values.containsKey(this.currentXormSection.id + "__inner")) {
                    (this.data.values[this.currentXormSection.id + "_inner"] as Map).update("inner", (existing) => repeatValue, ifAbsent: () => repeatValue); //["inner"] = repeatValue; // + (currentXormSection.params.repeatMaxTimes == "inner" ? )
                  } else {
                    this.data.values[this.currentXormSection.id + "_inner"] = {
                      "inner" : repeatValue
                    };
                  }
                  
                } else { // FIXED
                  currentXormSection.params.repeatMaxTimesFixed = (repeatValue as int);
                }
                
              }

            },

          ),
          flex: 1,
        ),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              child: Text(
                "Previous",
                style: TextStyle(color: Colors.white)
              ),
              color: Colors.blue,
              onPressed: () {
                if (this.currentXormSection.params.repeat ?? false) {
                  if (this.currentSectionDataPosition > 0) {
                    setState(() {
                      this.currentSectionDataPosition -= 1;
                      this.repeatIt = false;
                    });
                  } else {
                    setState(() {
                      this.currentSectionPosition = currentSectionPosition == 0 ? 0 : currentSectionPosition - 1;
                      this.repeatIt = false;
                    });
                  }
                } else {
                  if (this.currentSectionPosition - 1 >= 0 && (this._currentXormDetails.sections[this.currentSectionPosition - 1].params.repeat ?? false) ) {
                    setState(() {
                      this.currentSectionDataPosition = (this.data.values[this._currentXormDetails.sections[this.currentSectionPosition - 1].id] as List).length - 1;
                      this.currentSectionPosition = currentSectionPosition - 1;
                      this.repeatIt = false;
                    });
                  } else {
                    setState(() {
                      this.currentSectionPosition = currentSectionPosition == 0 ? 0 : currentSectionPosition - 1;
                      this.repeatIt = false;
                    });
                  }
                }
                
                this.controller.previousPage(duration: _kDuration, curve: _kCurve);
              },
            ),
            FlatButton(
              child: Text(
                isLastPage ? "Save it" : "Next",
                style: TextStyle(color: Colors.white)
              ),
              color: Colors.blue,
              onPressed: () async {
                final String currentSectionKey = this.currentXormSection.id;
                Map<String, dynamic> currentSectionData = new Map();

                if (this.currentXormSectionKey.currentState.saveAndValidate()) {
                  currentSectionData = this.currentXormSectionKey.currentState.value;
                  
                  if (currentSectionData.isEmpty) {
                    this.data.values[currentSectionKey] = {};
                  } else {
                    final ca = currentSectionData.map((key, value) {
                      return MapEntry(key, value != null ? value.toString() : "");
                    });
                    
                    if (!(this.currentXormSection.params.repeat ?? false)) {
                      this.data.values.update(currentSectionKey, 
                        (existingValue) => ca,
                        ifAbsent: () => ca
                      );
                    } else {
                      if (!this.data.values.containsKey(currentSectionKey)) {
                        this.data.values[currentSectionKey] = [];
                      }

                      if (this.currentSectionDataPosition == (this.data.values[currentSectionKey] as List).length) {
                        (this.data.values[currentSectionKey] as List).add(ca);
                      } else {
                        (this.data.values[currentSectionKey] as List)[this.currentSectionDataPosition] = ca;
                      }
                      
                      print(this.data.values[currentSectionKey]);
                    }
                    
                  }
                }

                if (isLastPage) {
                  if (widget.id == 0) {
                    this._dataCollectedBloc.add(AddDataCollected(data: this.data));
                  } else {
                    this._dataCollectedBloc.add(UpdateDataCollected(data: this.data));
                  }
                  
                  if ( (currentSectionData["section_final__again"] as bool)?? false ) {
                    this.data = DataCollected(form: widget.currentXorm, values: {});
                    
                    setState(() {
                      this.currentSectionPosition = 0;
                      this.currentSectionDataPosition = 0;
                      this.repeatIt = false;
                    });
                  } else {
                    Navigator.of(context).pop();
                  }                  
                } else {        
                  XormSection currentXormSection = this._currentXormDetails.sections[this.currentSectionPosition]; 
                  AlertDialog alert = AlertDialog(
                    title: Text("Repeat it"),
                    content: Text("Do you want to repeat this section again?"),
                    actions: [
                      FlatButton(
                        child: Text("Yes"),
                        onPressed:  () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                      FlatButton(
                        child: Text("No"),
                        onPressed:  () {
                          Navigator.of(context).pop(false);
                        },
                      )
                    ],
                  );

                  /**
                   * nextRepeat = Unlimitted || fixed & length < fixedValue || inner & length < innerValue
                   */
                  bool nextRepeat = false;
                  if (this.currentXormSection.params.repeat ?? false) {
                    switch (currentXormSection.params.repeatMaxTimes) {
                      case "unlimitted":
                        nextRepeat = true;
                        break;
                      case "Fixed":
                        if (currentXormSection.params.repeatMaxTimesFixed > (this.data.values[this.currentXormSection.id] as List).length) {
                          nextRepeat = true;
                        }

                        break;
                      case "inner":
                        int innerValue = int.parse((this.data.values[this.currentXormSection.id + "_inner"] as Map)["inner"]);
                        if (innerValue > (this.data.values[this.currentXormSection.id] as List).length) {
                          nextRepeat = true;
                        }

                        break;
                      case "variable":
                        List<String> split = currentXormSection.params.repeatMaxTimesVariable.split("__");
                        String section = split[0];
                        String variable = split[1];

                        int variableValue = ((this.data.values[section] as Map)[variable] as int);
                        if (variableValue > (this.data.values[this.currentXormSection.id] as List).length) {
                          nextRepeat = true;
                        }

                        break;
                      default:
                        nextRepeat = false;
                    }
                  }
                  
                  if ((this.currentXormSection.params.repeat ?? false) && nextRepeat) {

                    if (this.currentSectionDataPosition == (this.data.values[this.currentXormSection.id] as List).length - 1) {
                        
                      final answer = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        },
                      );

                      if (answer != null && answer == true) {
                        setState(() {
                          this.repeatIt = true;
                          this.currentSectionDataPosition += 1;
                        });
                      } else {
                        setState(() {
                          this.repeatIt = false;
                          this.currentSectionPosition += 1;
                          this.currentSectionDataPosition = 0;
                        });
                      }
                    } else {
                      setState(() {
                        this.repeatIt = false;
                        this.currentSectionDataPosition += 1;
                      });
                    }                
                  } else {
                    if (this.repeatIt) {
                      setState(() {
                        this.repeatIt = false;
                        this.currentSectionPosition += 1;
                        this.currentSectionDataPosition = 0;
                      });
                    } else {
                      setState(() {
                        this.currentSectionPosition += 1;
                        this.currentSectionDataPosition = 0;
                      });
                    }
                  }
                  
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
    this._currentXormDetails = Project.instance.xormsDetails.firstWhere((x) {
      return  x.id == widget.currentXorm;
    });

    
    String currentXormTitle = Project.instance.xorms.firstWhere((x) => x.id == widget.currentXorm).title;
    this.currentXormSection = this._currentXormDetails.sections[this.currentSectionPosition];

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
