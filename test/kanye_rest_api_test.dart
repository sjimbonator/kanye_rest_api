import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:kanye_rest_api/kanye_rest_api.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('KanyeRestApiClient', () {
    late http.Client httpClient;
    late KanyeRestApiClient kanyeRestApiClient;

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    setUp(() {
      httpClient = MockHttpClient();
      kanyeRestApiClient = KanyeRestApiClient(httpClient: httpClient);
    });

    group('constructor', () {
      test('does not require an httpClient', () {
        expect(KanyeRestApiClient(), isNotNull);
      });
    });

    group('getQuote', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        try {
          await kanyeRestApiClient.getQuote();
        } catch (_) {}
        verify(
          () => httpClient.get(
            Uri.https('api.kanye.rest', '/'),
          ),
        ).called(1);
      });
    });

    test('throws QuoteRequestFailure on non-200 response', () async {
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(400);
      when(() => httpClient.get(any())).thenAnswer((_) async => response);
      expect(
        () async => await kanyeRestApiClient.getQuote(),
        throwsA(isA<QuoteRequestFailure>()),
      );
    });

    test('throws QuoteNotFoundFailure on empty response', () async {
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn('{}');
      when(() => httpClient.get(any())).thenAnswer((_) async => response);
      expect(
        () async => await kanyeRestApiClient.getQuote(),
        throwsA(isA<QuoteNotFoundFailure>()),
      );
    });

    test('throws QuoteNotFoundFailure on response with invalid quote',
        () async {
      final response = MockResponse();
      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn('{"quote" : 0 }');
      when(() => httpClient.get(any())).thenAnswer((_) async => response);
      expect(
        () async => await kanyeRestApiClient.getQuote(),
        throwsA(isA<QuoteNotFoundFailure>()),
      );
    });

    test('returns quote on correct response', () async {
      final response = MockResponse();
      const quote = "Life is the ultimate gift";
      when(() => response.statusCode).thenReturn(200);
      when(() => response.body).thenReturn('{"quote" : "$quote" }');
      when(() => httpClient.get(any())).thenAnswer((_) async => response);
      final actual = await kanyeRestApiClient.getQuote();
      expect(
        actual,
        quote,
      );
    });
  });
}
