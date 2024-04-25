import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'calculation_history.dart';
import 'database_helper.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<CalculationHistory> _history = []; // Инициализируем пустой список

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    List<CalculationHistory> history = await DatabaseHelper().getCalculations();
    setState(() {
      _history = history;
    });
  }

  // Метод для сохранения записи в истории расчетов:
  void _saveCalculationToHistory(String expression, String result) async {
    final history = CalculationHistory(expression: expression, result: result, timestamp: DateTime.now(), id: null);
    await DatabaseHelper().insertCalculation(history);
    print('Added to history: $history');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: _buildHistoryList(),
    );
  }

  Widget _buildHistoryList() {
    if (_history.isEmpty) {
      return Center(
        child: Text('No history yet'),
      );
    } else {
      return ListView.builder(
        itemCount: _history.length,
        itemBuilder: (context, index) {
          final item = _history[index];
          return ListTile(
            title: Text(item.expression),
            subtitle: Text(
              '${item.result} = ${DateFormat('yyyy-MM-dd HH:mm').format(item.timestamp)}',
            ),
          );
        },
      );
    }
  }
}