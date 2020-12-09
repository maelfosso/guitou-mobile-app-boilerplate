
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:guitou/init.dart';
import 'package:guitou/pages/home_page.dart';

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
          return MaterialApp(
            title: 'Guitou',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: HomePage(),
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

  // @override
  // Widget build(BuildContext context) {
    
  //   return BlocProvider(
  //     create: (BuildContext _) => DataCollectedBloc(),
  //     child: MaterialApp(
  //       title: 'Guitou',
  //       theme: ThemeData(
  //         // This is the theme of your application.
  //         //
  //         // Try running your application with "flutter run". You'll see the
  //         // application has a blue toolbar. Then, without quitting the app, try
  //         // changing the primarySwatch below to Colors.green and then invoke
  //         // "hot reload" (press "r" in the console where you ran "flutter run",
  //         // or simply save your changes to "hot reload" in a Flutter IDE).
  //         // Notice that the counter didn't reset back to zero; the application
  //         // is not restarted.
  //         primarySwatch: Colors.blue,
  //       ),
  //       home: HomePage(title: 'Home'),
  //     )
  //   );
  // }
}