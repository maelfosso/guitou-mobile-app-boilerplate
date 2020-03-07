import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:muitou/models/data_collected.dart';

class DataApiClient {
  final String baseUrl;
  final http.Client httpClient;

  DataApiClient({
    @required this.baseUrl,
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<DataCollected> postData(DataCollected data) async {
    final url = '$baseUrl/forms/${data.form}/data';

    var headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Accept": "application/json"
    };

    return http.post(url, headers: headers, body: json.encode(data)).then((http.Response response) {
      
      final int statusCode = response.statusCode;

      final body = json.decode(response.body);

      if (statusCode < 200 || statusCode > 400 || body == null || body['success'] != true) {
        throw new Exception("Error while fetching data");
      }

      return DataCollected.fromJson(json.decode(body['data']));
    });    
  }

  Future<Quote> fetchQuote() async {
    final url = 'https://quote-garden.herokuapp.com/quotes/random';
    final response = await this.httpClient.get(url);
    if (response.statusCode != 200) {
      throw new Exception('error getting quotes');
    }
    final json = jsonDecode(response.body);
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
