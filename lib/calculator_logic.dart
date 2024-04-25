class CalculatorLogic {
  static double evaluateExpression(String expression) {
    List<String> tokens = _tokenizeExpression(expression);
    if (tokens.isEmpty) return double.nan; // Если выражение пустое, вернуть NaN
    List<String> postfix = _toPostfix(tokens);
    return _evaluatePostfix(postfix);
  }

  static List<String> _toPostfix(List<String> tokens) {
    List<String> postfix = [];
    List<String> stack = [];
    for (int i = 0; i < tokens.length; i++) {
      if (_isNumber(tokens[i])) {
        postfix.add(tokens[i]);
      } else if (_isOperator(tokens[i])) {
        while (stack.isNotEmpty && _getPrecedence(stack.last) >= _getPrecedence(tokens[i])) {
          postfix.add(stack.removeLast());
        }
        stack.add(tokens[i]);
      } else if (tokens[i] == '(') {
        stack.add(tokens[i]);
      } else if (tokens[i] == ')') {
        while (stack.isNotEmpty && stack.last != '(') {
          postfix.add(stack.removeLast());
        }
        stack.removeLast();
      }
    }
    while (stack.isNotEmpty) {
      postfix.add(stack.removeLast());
    }
    return postfix;
  }

  static double _evaluatePostfix(List<String> postfix) {
    List<double> stack = [];
    for (String token in postfix) {
      if (_isNumber(token)) {
        stack.add(double.parse(token));
      } else if (_isOperator(token)) {
        double operand2 = stack.removeLast();
        double operand1 = stack.removeLast();
        switch (token) {
          case '+':
            stack.add(operand1 + operand2);
            break;
          case '-':
            stack.add(operand1 - operand2);
            break;
          case '*':
            stack.add(operand1 * operand2);
            break;
          case '/':
            stack.add(operand1 / operand2);
            break;
        }
      }
    }
    return stack.single;
  }

  static bool _isNumber(String token) {
    return double.tryParse(token) != null;
  }

  static bool _isOperator(String token) {
    return token == '+' || token == '-' || token == '*' || token == '/';
  }

  static int _getPrecedence(String token) {
    if (token == '+' || token == '-') return 1;
    if (token == '*' || token == '/') return 2;
    return 0;
  }

  static List<String> _tokenizeExpression(String expression) {
    List<String> tokens = [];
    String currentToken = '';
    for (int i = 0; i < expression.length; i++) {
      if (_isOperator(expression[i])) {
        if (currentToken.isNotEmpty) {
          tokens.add(currentToken.trim());
          currentToken = '';
        }
        tokens.add(expression[i]);
      } else if (expression[i] == '(' || expression[i] == ')') {
        if (currentToken.isNotEmpty) {
          tokens.add(currentToken.trim());
          currentToken = '';
        }
        tokens.add(expression[i]);
      } else {
        currentToken += expression[i];
      }
    }
    if (currentToken.isNotEmpty) {
      tokens.add(currentToken.trim());
    }
    return tokens;
  }
}