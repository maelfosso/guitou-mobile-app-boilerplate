// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:guitou/bloc/blocs.dart';
// import 'package:guitou/models/data_collected.dart';
// import 'package:guitou/models/project.dart';
// import 'package:guitou/pages/data_entry_page.dart';

// import '../models/project.dart';
// import '../models/xorm_detail.dart';

// class DataViewPage extends StatelessWidget {
//   int id;
//   DataCollected _data;
//   XormDetails _currentXormDetails;

//   DataCollectedBloc _dataCollectedBloc;

//   DataViewPage({Key key, @required this.id }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     this._dataCollectedBloc = BlocProvider.of<DataCollectedBloc>(context);
//     //  context.bloc<DataCollectedBloc>();
//     // this._dataCollectedBloc.add(QueryDataCollected(id: this.id));

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Data'),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.edit),
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => DataEntryPage(
//                     currentXorm: this._data.form, 
//                     id: this._data.id
//                   )
//                 ),
//               );
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.delete),
//             onPressed: () async {
//               bool isDeleted = await showDialog<bool>(
//                 context: context,
//                 barrierDismissible: false, // user must tap button for close dialog!
//                 builder: (BuildContext context) {
//                   return AlertDialog(
//                     title: Text('Delete Data?'),
//                     content: const Text(
//                       'Are you sure you want to delete that data?'    
//                     ),
//                     actions: <Widget>[
//                       FlatButton(
//                         child: const Text('NO'),
//                         onPressed: () {
//                           Navigator.of(context).pop(false);
//                         },
//                       ),
//                       FlatButton(
//                         child: const Text('YES'),
//                         onPressed: () {
//                           Navigator.of(context).pop(true);
//                         },
//                       )
//                     ],
//                   );
//                 },
//               );

//               if (isDeleted) {
//                 // _dataCollectedBloc.add(DeleteDataCollected(data: this._data));
//                 _dataCollectedBloc.add(DataCollectedDeleted(this._data));
//                 Navigator.of(context).pop();
//               }
//             },
//           )
//         ],
//       ),
//       body: BlocBuilder<DataCollectedBloc, DataCollectedState>(
//         builder: (context, state) {
          
//           final data = (state as DataCollectedLoadSuccess)
//               .data
//               .firstWhere((datum) => datum.id == id, orElse: () => null);
          
//           return this._currentXormDetails.view(data.values);
//         }
//       )  
//       // BlocBuilder(
//       //   bloc: _dataCollectedBloc,
//       //   builder: (BuildContext context, DataCollectedState state) {
//       //     if (state is DataCollectedLoading) {
//       //       return Center(
//       //         child: CircularProgressIndicator(),
//       //       );
//       //     } 
//       //     if (state is DataCollectedLoaded && state.datas.length == 1) {
//       //       this._data = state.datas.first;            
//       //       this._currentXormDetails = Project.instance.xormsDetails.firstWhere((x) => x.id == this._data.form);
//       //       return this._currentXormDetails.view(this._data.values);
//       //     }
          
//       //     return Container();
//       //   },
//       // )
//     );
//  }

// }