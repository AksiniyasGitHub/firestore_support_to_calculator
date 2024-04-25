import 'package:flutter/material.dart';

class KilometerMileConverterScreen extends StatefulWidget {
  @override
  _KilometerMileConverterScreenState createState() => _KilometerMileConverterScreenState();
}

class _KilometerMileConverterScreenState extends State<KilometerMileConverterScreen> {
  double kilometers = 0; // Переменная для хранения введенного количества километров
  double miles = 0; // Переменная для хранения результата в милях

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kilometer to Mile Converter'), // Заголовок экрана
        backgroundColor: Colors.purple[100], // Цвет фона appBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Enter kilometers'), // Текстовое поле для ввода километров
              keyboardType: TextInputType.number, // Клавиатура для ввода только чисел
              onChanged: (value) {
                setState(() {
                  // Обновляем значение километров при изменении текстового поля
                  kilometers = double.tryParse(value) ?? 0; // Преобразуем текст в число, если возможно
                });
              },
            ),
            SizedBox(height: 20), // Пространство между виджетами
            ElevatedButton(
              onPressed: () {
                // Выполняем конвертацию километров в мили при нажатии на кнопку
                setState(() {
                  miles = kilometers * 0.621371; // Формула для конвертации километров в мили
                });
              },
              child: Text('Convert', style: TextStyle(color: Colors.black)), // Текст на кнопке с черным цветом
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[200], // Цвет кнопки
              ),
            ),
            SizedBox(height: 20), // Пространство между виджетами
            Text(
              'Miles: $miles', // Отображаем результат в милях
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}