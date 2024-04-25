import 'package:flutter/material.dart';
import 'calculation_history.dart';
import 'calculator_logic.dart';
import 'history_screen.dart'; // Импорт экрана с историей
import 'database_helper.dart';
import 'kilometer_mile_converter.dart'; // Импортируем экран конвертера
import 'package:cloud_firestore/cloud_firestore.dart'; // Импортируем Firestore

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = ''; // Текущее математическое выражение

  void _saveCalculationToHistory(String expression, String result) async {
    final history = CalculationHistory(expression: expression, result: result, timestamp: DateTime.now(), id: null);
    await DatabaseHelper().insertCalculation(history);

    try {
      await FirebaseFirestore.instance.collection('calculations').add({
        'expression': expression,
        'result': result,
        'timestamp': DateTime.now(),
      });
    } catch (e) {
      print('Error saving calculation to Firestore: $e');
    }
  }

  bool _isResult = false;

  // Обработчик нажатия кнопок калькулятора
  void _onButtonPressed(String text) {
    setState(() {
      if(_isResult) {
        _isResult = false;
        _expression = '';
      }
      if (_expression == 'Error') {
        // Если на экране отображается сообщение об ошибке, очистим его перед добавлением нового символа
        _expression = '';
      }

      if (text == 'C') {
        // Если нажата клавиша 'C', очистить экран
        _expression = '';
      } else if (text == '=') {
        // Если нажата клавиша '=', выполнить вычисление выражения
        if (_expression.isNotEmpty) {
          try {
            final result = CalculatorLogic.evaluateExpression(_expression);
            _saveCalculationToHistory(_expression, result.toString()); // Сохраняем вычисление в историю
            _expression = formatResult(result); // Отображаем результат на экране
            _isResult = true;
          } catch (e) {
            _expression = 'Error';
            return;
          }
        }
      } else {
        // Добавляем символ к текущему выражению
        _expression += text;
      }
    });
  }

  String formatResult(double result) {
    // Проверяем, является ли результат целым числом
    if (result % 1 == 0) {
      return result.toInt().toString(); // Если целое, преобразуем в строку и возвращаем
    } else {
      String formattedResult = result.toStringAsFixed(2); // Форматируем результат с двумя знаками после запятой
      if (formattedResult.endsWith('.00')) {
        return result.toInt().toString(); // Если десятичная часть равна 0, скрываем её
      } else {
        return formattedResult; // Иначе возвращаем форматированный результат
      }
    }
  }

  // Вспомогательный метод для создания кнопок калькулятора
  Widget _buildButton(String text, {Color? textColor, Color? buttonColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () => _onButtonPressed(text),
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor ?? Colors.black, backgroundColor: buttonColor ?? Colors.purple[100],
          padding: EdgeInsets.all(20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        backgroundColor: Colors.purple[200],
        actions: [ // Добавляем кнопку на панель приложения
          IconButton(
            icon: Icon(Icons.history), // Иконка "История"
            onPressed: () {
              Navigator.push( // Переходим на экран с историей
                context,
                MaterialPageRoute(builder: (context) => HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20.0),
              color: Colors.purple[50],
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  _expression,
                  style: TextStyle(fontSize: 36.0),
                ),
              ),
            ),
          ),
          // Ряды с кнопками для цифр и операторов
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('7'),
              _buildButton('8'),
              _buildButton('9'),
              _buildButton('/', buttonColor: Colors.purple[200]),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('4'),
              _buildButton('5'),
              _buildButton('6'),
              _buildButton('*', buttonColor: Colors.purple[200]),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('1'),
              _buildButton('2'),
              _buildButton('3'),
              _buildButton('-', buttonColor: Colors.purple[200]),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('0'),
              _buildButton('C', buttonColor: Colors.purple[300]),
              _buildButton('=', buttonColor: Colors.purple[300]),
              _buildButton('+', buttonColor: Colors.purple[200]),
            ],
          ),
          // Добавляем кнопку для перехода на экран конвертера
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Переходим на экран конвертера при нажатии на кнопку
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => KilometerMileConverterScreen()),
                );
              },
              child: Text('Go to Converter'), // Текст кнопки
            ),
          ),
        ],
      ),
    );
  }
}