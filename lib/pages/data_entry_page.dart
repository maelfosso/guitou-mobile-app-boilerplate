import 'package:flutter/material.dart';
import 'package:muitou/models/project.dart';

import '../models/project.dart';
import '../models/xorm_detail.dart';

class DataEntryPage extends StatefulWidget {
  DataEntryPage({Key key, this.currentXorm}) : super(key: key);

  final String currentXorm;

  @override
  _DataEntryPageState createState() => _DataEntryPageState();
}

class _DataEntryPageState extends State<DataEntryPage> {
  XormDetails _currentXormDetails;

  PageController controller = PageController();
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  int currentPageViewPosition = 0;

  @override
  void initState() {
    super.initState();

    setState(() {
      currentPageViewPosition = 0;
    });
  }

  Widget _buildPage(int position) {
    
    if (position <= this._currentXormDetails.sections.length - 1) {
      XormSection currentXormSection = this._currentXormDetails.sections[position];

      return Container(
        child: 
        // SingleChildScrollView(
        //   scrollDirection: Axis.vertical,
        //   child: 
          Column(
            children: <Widget>[
              Text(currentXormSection.params.title),
              Text(currentXormSection.params.description),
              Spacer(flex: 1)
            ],
          ),
        // )
      );
    } else {
      return Container(
        child: Column(
          children: <Widget>[
            Text("Thank you for filling that form"),
            Text("Please, sign here to confirm your data entry and then validate"),

            // Input for his signature
            // Check for whether or not he want to restart again for the next one
          ],
        ),
      );
    }
  }

  Widget buildPageView() {
    bool isLastPage = !(this.currentPageViewPosition <= this._currentXormDetails.sections.length - 1);
    
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
                if (isLastPage) {

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
      body: buildPageView()
    );
  }
}