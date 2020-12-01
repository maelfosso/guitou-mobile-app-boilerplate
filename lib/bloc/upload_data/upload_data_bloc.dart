import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:tracer/blocs/data/data.dart';
import 'package:tracer/blocs/upload_data/upload_data.dart';
import 'package:tracer/data_repository/data_entity.dart';
import 'package:tracer/data_repository/data_repository.dart';
import 'package:tracer/env_config.dart';
import 'package:tracer/models/models.dart';

class UploadDataBloc extends Bloc<UploadDataEvent, UploadDataState> {
  final DataRepository dataRepository = GetIt.I.get<DataRepository>();
  final DataBloc dataBloc;

  UploadDataBloc({@required this.dataBloc})
      : super(DataUploadInProgress());

  @override
  Stream<UploadDataState> mapEventToState(UploadDataEvent event) async* {
    if (event is DataUpload) {
      yield* _mapDataUploadToState(event);
    }
  }

  Stream<UploadDataState> _mapDataUploadToState(UploadDataEvent event) async* {
    final data = (this.dataBloc.state as DataLoadSuccess)
        .data
        .where((data) => data.state == VisibilityFilter.notsynchronized.index.toInt())
        .toList();

    yield* _uploadData(data);
  }

  Stream<UploadDataState> _uploadData(List<Data> stream) async* {
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

  Future<DataEntity> postData(Data data) async {
    final http.Response response = await http.post(
      '${EnvConfig.API_URL}/api/data',
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(data.toMap())
    );
    
    if (response.statusCode == 201) {
      return DataEntity.fromJson(jsonDecode(response.body));
    } else {
      print('\nAn error occured');
      print(response.body);
      throw Exception('Failed to upload $data. \nResponse Status Code ${response.statusCode}');
    }
  }

}
