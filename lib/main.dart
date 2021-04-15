import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Integration Native',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _numberOne = 0;
  int _numberTwo = 0;
  int _resultSum = 0;

  void _sumNumbers() {
    setState(() {
      _resultSum = _numberOne + _numberTwo;
    });
  }

  Future<void> _sumNumbersNative() async {
    const channel =
        MethodChannel('jonathastassi.com.br/flutter_integration_native');

    try {
      final result = await channel
          .invokeMethod('calcSum', {"a": _numberOne, "b": _numberTwo});
      setState(() {
        _resultSum = result;
      });
    } on PlatformException {
      setState(() {
        _resultSum = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Flutter - Integração com Nativo"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Soma: $_resultSum"),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _numberOne = int.tryParse(value) ?? 0;
                  });
                },
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _numberTwo = int.tryParse(value) ?? 0;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _sumNumbers,
                    child: Text("Somar no Flutter"),
                  ),
                  ElevatedButton(
                    onPressed: _sumNumbersNative,
                    child: Text("Somar no Kotlin/Swift"),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
