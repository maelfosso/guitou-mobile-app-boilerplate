import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:muitou/models/data_collected.dart';

class DataApiClient {
  final _baseUrl =  'http://791e9c16.ngrok.io/api'; // 'http://192.168.8.100:3000/api';
  final http.Client httpClient;

  DataApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<DataCollected> postData(DataCollected data) async {
    print("\npostData - \n" + data.toJson().toString());
    final url = '$_baseUrl/forms/${data.form}/data';
    print(json.encode(data));
    print("\n");
    print(json.encode(data.toJson()));

    print('URL : \n' + url);

    var headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Accept": "application/json"
    };

    return http.post(url, headers: headers, body: json.encode(data)).then((http.Response response) {
      
      print(response.toString());
      final int statusCode = response.statusCode;
      print(statusCode);

      final body = json.decode(response.body);
      print("\nBODY");
      print(body);

      if (statusCode < 200 || statusCode > 400 || body == null || body['success'] != true) {
        throw new Exception("Error while fetching data");
      }

      print("\nBODY DATA");
      print(body['data']);
      print(DataCollected.fromJson(json.decode(body['data'])));
      print("\nRETURN IT");
      return DataCollected.fromJson(json.decode(body['data']));
    });
    
    // final response = await http.post(url, body: data.toJson());
    
  }

  Future<Quote> fetchQuote() async {
    print("Fetch Quote");
    final url = 'https://quote-garden.herokuapp.com/quotes/random';
    print(url);
    final response = await this.httpClient.get(url);
    print(response);
    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }
    print(response.body);
    final json = jsonDecode(response.body);
    print(json);
    return Quote.fromJson(json);
  }

}

class Quote extends Equatable {
  final id;
  final String quoteText;
  final String quoteAuthor;

  const Quote({this.id, this.quoteText, this.quoteAuthor});

  @override
  List<Object> get props => [id, quoteText, quoteAuthor];

  static Quote fromJson(dynamic json) {
    return Quote(
      id: json['_id'],
      quoteText: json['quoteText'],
      quoteAuthor: json['quoteAuthor'],
    );
  }

  @override
  String toString() => 'Quote { id: $id }';
}
