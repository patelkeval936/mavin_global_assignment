

DateTime decodeDate(String value) {
  List<String> values = value.split('-');
  if (values.length == 3) {
    if (validateDate(values) == null) {
      return DateTime.parse(value);
    } else {
      throw Exception('Error parsing date');
    }
  } else {
    List<String> decodeBySlash = value.split('/');
    if (decodeBySlash.length == 3) {

      if (validateDate(decodeBySlash) == null) {
        return DateTime.parse(
            '${decodeBySlash[0]}-${decodeBySlash[1]}-${decodeBySlash[2]}');
      } else {
        throw Exception('Error parsing date');
      }
    } else {
      throw Exception('Please enter valid data');
    }
  }
}

String? validateDate(List<String> date) {
  if (date.length != 3) {
    return 'Please enter 3 parameters';
  } else if (date[0].length != 4) {
    return 'Please enter correct Year';
  } else if (date[1].length == 2 || date[1].length == 1) {
  // } else if (date[2].length != 2 || date[2].length != 1) {
    if (int.parse(date[1].toString()) < 0 ||
        int.parse(date[1].toString()) > 12) {
      return 'Please Enter valid Month';
    }
  } else if (date[2].length == 2 || date[2].length == 1) {
    // } else if (date[2].length != 2 || date[2].length != 1) {
    if (int.parse(date[2].toString()) < 0 ||
        int.parse(date[2].toString()) > 31) {
      return 'Please Enter valid Date';
    }else if((date[1].length != 2 && date[1].length != 1) || (date[2].length != 2 && date[2].length != 1)){
      return 'Please Enter valid Date';
    }
  }

  return null;
}

List<String> applyCondition(
    List<String> data, String checkForDataType, String? condition) {

  if (condition == null || condition.trim() == '') {
    return data;
  } else {
    List<String> conditionStrings = condition.trim().split(' ');

    if (conditionStrings.length == 3) {
      int index = conditionStrings.indexWhere((element) =>
          (element.toLowerCase() == 'and' || element.toLowerCase() == 'or'));

      String conditionOperator = conditionStrings[index];
      String op1 = conditionStrings[index - 1];
      String op2 = conditionStrings[index + 1];

      List<String> output = [];

      for (String element in data) {
        bool result1 = matchCriteria(element, checkForDataType, op1);
        bool result2 = matchCriteria(element, checkForDataType, op2);

        if (conditionOperator == 'and') {
          if (result1 && result2) {
            output.add(element);
          }
        } else if (conditionOperator == 'or') {
          if (result1 || result2) {
            output.add(element);
          }
        }
      }
      return output;
    } else if (conditionStrings.length == 1) {
      List<String> output = [];

      for (String element in data) {
        bool result =
            matchCriteria(element, checkForDataType, conditionStrings[0]);

        if (result) {
          output.add(element);
        }
      }

      return output;
    }

    return [];
  }
}

bool matchCriteria(
    String data, String checkForDataType, String inputCondition) {
  String conditionChar;
  String valueToCompareWith;

  if (inputCondition.startsWith('<=')) {
    conditionChar = '<=';
    valueToCompareWith = inputCondition.substring(2);
  } else if (inputCondition.startsWith('>=')) {
    conditionChar = '>=';
    valueToCompareWith = inputCondition.substring(2);
  } else if (inputCondition.startsWith('!=')) {
    conditionChar = '!=';
    valueToCompareWith = inputCondition.substring(2);
  } else {
    conditionChar = inputCondition[0];
    valueToCompareWith = inputCondition.substring(1);
  }

  List<String> intConditions = ['<', '>', '=', '<=', '>=', '!', '!='];
  List<String> stringConditions = ['=', '!', '!='];

  List<String> conditionsForDatatype = [];

  dynamic inputOfGivenDataType;

  if (checkForDataType.toLowerCase() == 'int') {
    conditionsForDatatype = intConditions;

    inputOfGivenDataType = int.parse(data);
  } else if (checkForDataType.toLowerCase() == 'string') {
    conditionsForDatatype = stringConditions;

    inputOfGivenDataType = data;
  }

  if (conditionsForDatatype.contains(conditionChar)) {
    if (checkForDataType.toLowerCase() == 'string') {
      switch (conditionChar) {
        case '=':
          return inputOfGivenDataType == valueToCompareWith;
        case '!=':
          return inputOfGivenDataType != valueToCompareWith;
        case '!':
          return inputOfGivenDataType != valueToCompareWith;
        default:
          return false;
      }
    } else if (checkForDataType.toLowerCase() == 'int') {
      int value = int.parse(valueToCompareWith);

      switch (conditionChar) {
        case '=':
          return inputOfGivenDataType == value;
        case '>=':
          return inputOfGivenDataType >= value;
        case '<=':
          return inputOfGivenDataType <= value;
        case '<':
          return inputOfGivenDataType < value;
        case '>':
          return inputOfGivenDataType > value;
        case '!=':
          return inputOfGivenDataType != value;
        case '!':
          return inputOfGivenDataType != value;
        default:
          return false;
      }
    } else {
      throw Exception('Invalid Datatype');
    }
  } else {
    throw Exception('Invalid Condition');
  }
}
