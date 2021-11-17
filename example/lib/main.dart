import 'package:flutter/material.dart';
import 'package:kanye_rest_api/kanye_rest_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kanye Examples',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color.fromRGBO(18, 18, 18, 1),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _client = KanyeRestApiClient();
  var _quote = '"Theres so many lonely emojis man"';

  Future<void> _refreshQuote() async {
    final quote = await _client.getQuote();
    setState(() {
      _quote = '"$quote"';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Image.network(
          'https://images0.persgroep.net/rcs/JsQyegc7IS1bdgqF0EOd-a4HaRU/diocontent/206781566/_fitwidth/694/?appId=21791a8992982cd8da851550a453bd7f&quality=0.8',
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Kanye West © AFP',
              style: TextStyle(
                color: Colors.grey.shade300,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14.0,
              vertical: 98.0,
            ),
            child: Container(
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                _quote,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color.fromRGBO(187, 134, 252, 1),
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshQuote,
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
        backgroundColor: const Color.fromRGBO(252, 246, 134, 1),
        foregroundColor: const Color.fromRGBO(18, 18, 18, 1),
      ),
    );
  }
}
