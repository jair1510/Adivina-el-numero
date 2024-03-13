import 'dart:math';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _controller = TextEditingController();
  int _intentos = 0;
  List<String> _mayor = [];
  List<String> _menor = [];
  List<String> _historial = [];
  double _currentSliderValue = 0;
  late int _secretNumber;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _start();
  }

  void _start() {
    setState(() {
      _secretNumber = _generateSecretNumber();
      print('secret ' + _secretNumber.toString());
    });
  }

  int _generateSecretNumber() {
    Random random = Random();
    return random.nextInt(_getMaxNumberForDifficulty()) + 1;
  }

  int _getMaxNumberForDifficulty() {
    switch (_currentSliderValue.round()) {
      case 0:
        _intentos = 5;
        return 10;
      case 1:
        _intentos = 8;
        return 20;
      case 2:
        _intentos = 15;
        return 100;
      case 3:
        _intentos = 25;
        return 1000;
      default:
        _intentos = 5;
        return 10; // Default to easy if history is somehow corrupted
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Adivina el numero',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Numero',
                    ),
                    controller: _controller,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text('Intentos'),
                    Text(_intentos.toString()),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: buildContainer('Mayor que', _mayor),
              ),
              Expanded(
                flex: 3,
                child: buildContainer('Menor que', _menor),
              ),
              Expanded(
                flex: 3,
                child: buildContainer('Historial', _historial),
              ),
            ],
          ),
          Center(child: Text(_getDifficultyLabel(_currentSliderValue.round()))),
          Slider(
            value: _currentSliderValue,
            max: 3, // El número de niveles de dificultad
            divisions: 3,
            label: _getDifficultyLabel(_currentSliderValue.round()),
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;

                _start();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildContainer(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 300, // Cambia la altura según sea necesario
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            width: 2.0,
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(title),
            SizedBox(
              height: 100,
              child: ListView(
                children: items.map((String item) {
                  return ListTile(
                    title: Text(item),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDifficultyLabel(int value) {
    switch (value) {
      case 0:
        return 'Fácil';
      case 1:
        return 'Medio';
      case 2:
        return 'Avanzado';
      case 3:
        return 'Extremo';
      default:
        return '';
    }
  }
}
