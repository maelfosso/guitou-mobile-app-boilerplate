
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:guitou/init.dart';
import 'package:guitou/models/data_model.dart';
import 'package:guitou/pages/data_list_page.dart';
import 'package:guitou/pages/home_page.dart';
import 'package:provider/provider.dart';

class GuitouApp extends StatefulWidget {
  
  @override
  _GuitouStateApp createState() => _GuitouStateApp();
}

class _GuitouStateApp extends State<GuitouApp> {
  final Future _init =  Init.initialize();
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init,
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.done){
          return ChangeNotifierProvider(
            create: (context) => DataModel(),
            child: MaterialApp(
              title: 'Guitou',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: DataListPage(), // HomePage(),
              // routes: {
              //   ArchSampleRoutes.listData: (context) {
              //     return ListDataScreen();
              //   },
              //   ArchSampleRoutes.addData: (context) {
              //     return AddEditDataScreen(
              //         key: ArchSampleKeys.addDataScreen,
              //         isEditing: false,
              //         onSave: (name, sex, age, longitude, latitude, altitude, id) {
              //           BlocProvider.of<DataBloc>(context).add(
              //             DataAdded(
              //               Data(name, sex, 0, longitude, latitude, altitude, 0, state: VisibilityFilter.notsynchronized.index.toInt())
              //             ) 
              //           );
              //         },
              //       );
              //   },
              //   ArchSampleRoutes.takePicture: (context) {
              //     return TakePictureScreen();
              //   },
              //   ArchSampleRoutes.classifyPicture: (context) {
              //     return BlocProvider(
              //       create: (BuildContext context) => ClassifiedPictureBloc(),
              //       child: ClassifyPictureScreen()
              //     );
              //   },
              // },
            )
          );
        } else {
          return Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}