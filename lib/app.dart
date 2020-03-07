
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:muitou/app_config.dart';
import 'package:muitou/bloc/data_collected_bloc.dart';
import 'package:muitou/db/data_collected_dao.dart';
import 'package:muitou/pages/home_page.dart';
import 'package:muitou/repository/data_api_client.dart';
import 'package:muitou/repository/data_repository.dart';
import 'package:muitou/repository/project_api_client.dart';

class GuitouApp extends StatelessWidget {
  // This widget is the root of your application.
  DataRepository repository;

  @override
  Widget build(BuildContext context) {
    repository = DataRepository(
      dataApiClient: DataApiClient(
        baseUrl: AppConfig.of(context).apiBaseUrl,
        httpClient: http.Client(),
      ),
      dataCollectedDao: DataCollectedDao(),
      projectApiClient: ProjectApiClient(
        baseUrl: AppConfig.of(context).apiBaseUrl,
        httpClient: http.Client()
      )
    );

    return BlocProvider(
      create: (BuildContext context) => DataCollectedBloc(repository: repository),
      child: MaterialApp(
        title: 'Guitou',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: HomePage(title: 'Home'),
      )
    );
  }
}