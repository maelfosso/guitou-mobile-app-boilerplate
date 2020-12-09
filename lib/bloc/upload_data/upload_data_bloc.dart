import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:guitou/bloc/blocs.dart';
import 'package:guitou/repository/repository.dart';
import 'package:guitou/env_config.dart';
import 'package:guitou/models/models.dart';

class UploadDataBloc extends Bloc<UploadDataEvent, UploadDataState> {
  final DataRepository dataRepository = GetIt.I.get<DataRepository>();
  final DataCollectedBloc dataBloc;

  UploadDataBloc({@required this.dataBloc})
      : super(DataUploadInProgress());

  @override
  Stream<UploadDataState> mapEventToState(UploadDataEvent event) async* {
    if (event is DataUpload) {
      yield* _mapDataUploadToState(event);
    }
  }

  Stream<UploadDataState> _mapDataUploadToState(UploadDataEvent event) async* {
    final data = (this.dataBloc.state as DataCollectedLoadSuccess)
        .data
        // .where((data) => data.state == VisibilityFilter.notsynchronized.index.toInt())
        .toList();

    yield* _uploadData(data);
  }

  Stream<UploadDataState> _uploadData(List<DataCollected> stream) async* {
    final total = stream.length;
    yield DataUploadStarted(total);

    for (final value in stream) {
      try {
        final entity = await postData(value);
        yield DataUploadedSuccess(entity);
      } catch (e) {
        yield DataUploadedFailure();
      }
    }
  }

  Future<DataEntity> postData(DataCollected data) async {
    final http.Response response = await http.post(
      '${EnvConfig.API_URL}/api/data',
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(data.toJson())
    );
    
    if (response.statusCode == 201) {
      return DataEntity.fromJson(jsonDecode(response.body));
    } else {
      debugPrint('\nAn error occured ${response.body}');
      throw Exception('Failed to upload $data. \nResponse Status Code ${response.statusCode}');
    }
  }

}
