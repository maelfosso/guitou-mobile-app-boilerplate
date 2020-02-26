import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:muitou/bloc/data_collected_bloc.dart';
import 'package:muitou/bloc/data_collected_event.dart';
import 'package:muitou/bloc/data_collected_state.dart';
import 'package:muitou/models/data_collected.dart';
import 'package:muitou/models/project.dart';

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
      currentSectionPosition = 0;
      currentSectionDataPosition = 0;
      repeatIt = false;
    });
  }

  Widget _buildPage(int position) {
    this.currentXormSection = this._currentXormDetails.sections[this.currentSectionPosition];
    this.currentXormSectionKey = GlobalKey<FormBuilderState>();
    
    print("\_BUILD PAGE.... ${currentXormSection.id}");
    print(currentXormSection.toJson());
    print("\nRETURN WIDGETS....");
    print(this.data.values.containsKey(currentXormSection.id));
    print(this.data.values[currentXormSection.id]);
    print("\nWHAT ??");

    Map<String, dynamic> initData;
    if (this.currentXormSection.params.repeat) {
      if (this.repeatIt) {
        initData = {};
      } else {
        if (this.data.values.containsKey(currentXormSection.id)) {
          initData =  (this.data.values[currentXormSection.id] as List).length > 0 ? (this.data.values[currentXormSection.id] as List)[currentSectionDataPosition] : {};
        } else {
          initData = {};
        }
        
      }
      // if (widget.id > 0) {
      //   if (this.repeatIt) {
      //     initData = {};
      //   } else {
      //     initData = (this.data.values[currentXormSection.id] as List)[currentSectionDataPosition];
      //   }
      // } else {
      //   initData = {};
      // }      
    } else {
      initData = this.data.values.containsKey(currentXormSection.id) ? this.data.values[currentXormSection.id] : {};
    }
    print("\nDATA TO POPULATE \n");
    print(initData);
    var formElts = currentXormSection.build(
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
    print("\nBUILD PAGE VIEW .... ${this.currentSectionPosition} --- ${this._currentXormDetails.sections.length - 1} - ${this._currentXormDetails.sections[this.currentSectionPosition].id} ---- $isLastPage\n");
    // print(isLastPage);
    
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
              // setState(() {
              //   this.currentSectionPosition = page;
              // });
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
                if (this.currentXormSection.params.repeat) {
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
                  if (this.currentSectionPosition - 1 >= 0 && this._currentXormDetails.sections[this.currentSectionPosition - 1].params.repeat) {
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

                // if (this.currentXormSection.params.repeat && this.currentSectionDataPosition > 0) {
                //   setState(() {
                //     this.currentSectionDataPosition -= 1;
                //   });
                // } else {
                //   setState(() {
                //     this.currentSectionPosition = currentSectionPosition == 0 ? 0 : currentSectionPosition - 1;
                //   });
                // }
                
                this.controller.previousPage(duration: _kDuration, curve: _kCurve);
              },
            ),
            FlatButton(
              child: Text(isLastPage ? "Save it" : "Next"),
              color: Colors.blue,
              onPressed: () async {
                // final XormSection currentSection = this._currentXormDetails.sections[this.currentSectionPosition];
                final String currentSectionKey = this.currentXormSection.id;
                Map<String, dynamic> currentSectionData = new Map();

                // if (this.currentXormSection.sectionKey.currentState.saveAndValidate()) {
                if (this.currentXormSectionKey.currentState.saveAndValidate()) {
                  currentSectionData = this.currentXormSectionKey.currentState.value; //.cast<String, String>();
                  
                  if (currentSectionData.isEmpty) {
                    this.data.values[currentSectionKey] = {};
                  } else {
                    final ca = currentSectionData.map((key, value) {
                      return MapEntry(key, value != null ? value.toString() : "");
                    });
                    
                    if (!this.currentXormSection.params.repeat) {
                      // this.data.values[currentSectionKey] = ca;
                      this.data.values.update(currentSectionKey, 
                        (existingValue) => ca,
                        ifAbsent: () => ca
                      );
                    } else {
                      print("\n\nIT's REPEATED.... \n");
                      if (!this.data.values.containsKey(currentSectionKey)) {
                        this.data.values[currentSectionKey] = []; //.cast<List<Map<String, String>>>();
                        print("\nWAS EMPTY INIT...");
                      }

                      if (this.currentSectionDataPosition == (this.data.values[currentSectionKey] as List).length) {
                        print("\nVALUE ADDED INTO");
                        (this.data.values[currentSectionKey] as List).add(ca);
                      } else {
                        print("\nVALUE UPDATED.. INTO");
                        (this.data.values[currentSectionKey] as List)[this.currentSectionDataPosition] = ca;
                      }
                      
                      print(this.data.values[currentSectionKey]);
                      print("\nIT'S OKK...");

                      // if (widget.id > 0) {
                      //   if (this.repeatIt) { // new data added in this repeated section
                      //     (this.data.values[currentSectionKey] as List).add(ca);
                      //   } else {
                      //     (this.data.values[currentSectionKey] as List)[this.currentSectionDataPosition] = ca;
                      //   }
                      // } else {
                      //   if (!this.data.values.containsKey(currentSectionKey)) {
                      //     this.data.values[currentSectionKey] = []; //.cast<List<Map<String, String>>>();
                      //     print("\nWAS EMPTY INIT...");
                      //   }
                        
                      //   // this.data.values.update(currentSectionKey, 
                      //   //   (existingValue) => (existingValue as List).add(ca),
                      //   //   ifAbsent: () => ca
                      //   // );\
                      //   (this.data.values[currentSectionKey] as List).add(ca);
                        
                      //   print("\nVALUE ADDED INTO");
                      //   print(this.data.values[currentSectionKey]);
                      //   print("\nIT'S OKK...");
                      // }
                      
                    }
                    
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
      
                  if (currentXormSection.params.repeat && currentXormSection.params.repeatMaxTimes == -1) {

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

                    // Ask whether or not he wants to repeat it again?
                    // if (widget.id > 0) {
                    //   if (this.currentSectionDataPosition == (this.data.values[this.currentXormSection.id] as List).length - 1) {
                        
                    //     final answer = await showDialog(
                    //       context: context,
                    //       builder: (BuildContext context) {
                    //         return alert;
                    //       },
                    //     );

                    //     if (answer != null && answer == true) {
                    //       setState(() {
                    //         this.repeatIt = true;
                    //         this.currentSectionDataPosition += 1;
                    //       });
                    //     } else {
                    //       setState(() {
                    //         this.repeatIt = false;
                    //         this.currentSectionPosition += 1;
                    //         this.currentSectionDataPosition = 0;
                    //       });
                    //     }
                    //   } else {
                    //     setState(() {
                    //       this.repeatIt = false;
                    //       this.currentSectionDataPosition += 1;
                    //     });
                    //   }
                    // } else {
                      
                    //   // show the dialog
                    //   final answer = await showDialog(
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return alert;
                    //     },
                    //   );

                    //   if (answer != null && answer == true) {
                    //     setState(() {
                    //       this.repeatIt = true;
                    //       this.currentSectionDataPosition += 1;
                    //     });
                    //   } else {
                    //     setState(() {
                    //       this.repeatIt = false;
                    //       this.currentSectionPosition += 1;
                    //       this.currentSectionDataPosition = 0;
                    //     });
                    //   }
                    // }                    
                  } else {
                    // TODO : To review
                    if (this.repeatIt) {
                      setState(() {
                        this.repeatIt = false;
                        this.currentSectionPosition += 1;
                      });
                    } else {
                      setState(() {
                        this.currentSectionPosition += 1;
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
    print("\nBUILD... ${widget.currentXorm}");
    // this._currentXormDetails = Project.instance.xormsDetails.firstWhere((x) => x.id == widget.currentXorm);
    print("\nIn CURRENTXORM DETAILS");
    this._currentXormDetails = Project.instance.xormsDetails.firstWhere((x) {
      print("${x.id}---${widget.currentXorm}---${x.id.trim() == widget.currentXorm.trim()}");
      print("\n");
      return  x.id == widget.currentXorm;
    });

    print("\nTHERE ARE .. ${_currentXormDetails.sections.length} SECTIONS....\n");
    this._currentXormDetails.sections.forEach((section) {
      print(section.id);
    });
    print("\n");
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