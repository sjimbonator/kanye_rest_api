import 'dart:convert';

import 'package:http/http.dart' as http;

/// Exception thrown when getWeather fails.
class QuoteRequestFailure implements Exception {}

/// Exception thrown when quote is not found.
class QuoteNotFoundFailure implements Exception {}

class KanyeRestApiClient {
  KanyeRestApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'api.kanye.rest';
  final http.Client _httpClient;

  /// Use this method to fetch quotes from the API.
  ///
  /// Can throw an [QuoteRequestFailure] or [QuoteNotFoundFailure].
  Future<String> getQuote() async {
    final quoteRequest = Uri.https(_baseUrl, '/');
    final quoteResponse = await _httpClient.get(quoteRequest);

    if (quoteResponse.statusCode != 200) {
      throw QuoteRequestFailure();
    }

    final bodyJson = jsonDecode(quoteResponse.body) as Map<String, dynamic>;

    if (bodyJson.isEmpty) {
      throw QuoteNotFoundFailure();
    }

    final quote = bodyJson['quote'];

    if (quote is! String) {
      throw QuoteNotFoundFailure();
    }

    return quote;
  }
}
