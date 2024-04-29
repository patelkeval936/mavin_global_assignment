import 'dart:math' as math;

import 'helper_functions.dart';

int _checkField(dynamic field) {
  if ((field is String && field.toLowerCase() == 'data') ||
      (field is int && (field == 0 || field == 1))) {
    return 0;
  }
  return -1;
}

double dAverage(List<String> parameters, List<String> database) {
  dynamic field = parameters.isNotEmpty ? parameters[0] : null;
  String? criteria = parameters.length >= 2 ? parameters[1] : null;

  double sum = 0;
  int count = 0;

  if ((field is String && field.toLowerCase() == 'data') ||
      (field is int && (field == 0 || field == 1))) {
    field = 0;
  }

  if (field == 0) {
    List output = applyCondition(database, 'int', criteria);

    for (var data in output) {
      sum += int.parse(data);
      count++;
    }
  }

  if (count > 0) {
    return sum / count;
  } else {
    return 0;
  }
}

int dCount(List<String> parameters, List<String> database) {
  dynamic field = parameters.isNotEmpty ? parameters[0] : null;
  String? criteria = parameters.length >= 2 ? parameters[1] : null;

  int count = 0;

  if ((field is String && field.toLowerCase() == 'data') ||
      (field is int && (field == 0 || field == 1))) {
    field = 0;
  }

  if (field == 0) {
    List output = applyCondition(database, 'int', criteria);

    for (var data in output) {
      if (double.tryParse(data) != null) {
        count++;
      }
    }
  }

  return count;
}

int dCountA(List<String> parameters, List<String> database) {
  dynamic field = parameters.isNotEmpty ? parameters[0] : null;
  String? criteria = parameters.length >= 2 ? parameters[1] : null;

  int count = 0;

  field = _checkField(field);

  if (field == 0) {
    List output = applyCondition(database, 'int', criteria);

    for (var data in output) {
      if (data.toString().trim().isNotEmpty) {
        count++;
      }
    }
  }

  return count;
}

String dGet(List<String> parameters, List<String> database) {
  dynamic field = parameters.isNotEmpty ? parameters[0] : null;
  String? criteria = parameters.length >= 2 ? parameters[1] : null;

  field = _checkField(field);

  if (field == 0) {
    List filteredRecords = applyCondition(database, 'int', criteria);

    // If no record matches the criteria, return #VALUE! error value
    if (filteredRecords.isEmpty) {
      return "#VALUE!";
    }

    // If more than one record matches the criteria, return #NUM! error value
    if (filteredRecords.length > 1) {
      return "#NUM!";
    }

    // Return the value of the specified field from the matched record
    return filteredRecords.first.toString();
  }

  return '#Error!';
}

double dMax(List<String> parameters, List<String> database) {
  dynamic field = parameters.isNotEmpty ? parameters[0] : null;
  String? criteria = parameters.length >= 2 ? parameters[1] : null;

  field = _checkField(field);

  double maxNum = double.negativeInfinity;

  if (field == 0) {
    List output = applyCondition(database, 'int', criteria);

    maxNum = double.parse(output[0]);

    for (var data in output) {
      double value = double.parse(data);
      if (value > maxNum!) {
        maxNum = value;
      }
    }
  }

  return maxNum;
}

double dMin(List<String> parameters, List<String> database) {
  dynamic field = parameters.isNotEmpty ? parameters[0] : null;
  String? criteria = parameters.length >= 2 ? parameters[1] : null;

  field = _checkField(field);

  double minNum = double.maxFinite;

  if (field == 0) {
    List output = applyCondition(database, 'int', criteria);

    minNum = double.parse(output[0]);

    for (var data in output) {
      double value = double.parse(data);
      if (value < minNum) {
        minNum = value;
      }
    }
  }

  return minNum;
}

double dProduct(List<String> parameters, List<String> database) {
  dynamic field = parameters.isNotEmpty ? parameters[0] : null;
  String? criteria = parameters.length >= 2 ? parameters[1] : null;

  double product = 1;

  field = _checkField(field);

  if (field == 0) {
    List output = applyCondition(database, 'int', criteria);

    for (var data in output) {
      product *= int.parse(data);
    }
  }

  return product;
}

List drop(List<String> params, List<String> database) {
  int rows = int.parse(params[1]);

  if (rows > 0) {
    return database.sublist(rows);
  } else if (rows < 0) {
    return database.sublist(0, database.length - rows);
  } else {
    return database;
  }
}

double dstDev(List<String> parameters, List<String> database) {
  dynamic field = parameters.isNotEmpty ? parameters[0] : null;
  String? criteria = parameters.length >= 2 ? parameters[1] : null;

  field = _checkField(field);

  if (field == 0) {
    List<String> filteredData = applyCondition(database, 'int', criteria);

    if (filteredData.isEmpty || filteredData.length == 1) {
      return double.nan;
    }

    // Calculate mean
    double sum = 0;

    for (var element in filteredData) {
      sum += double.parse(element);
    }

    double mean = sum / filteredData.length;

    // Calculate sum of squares of differences from the mean
    double sumSquares = 0;
    for (String value in filteredData) {
      sumSquares += math.pow(double.parse(value) - mean, 2);
    }

    // Estimate population standard deviation
    double variance = sumSquares / (filteredData.length - 1);
    double stdev = math.sqrt(variance);

    return stdev;
  }

  return double.nan;
}

double dstDevP(List<String> parameters, List<String> database) {
  dynamic field = parameters.isNotEmpty ? parameters[0] : null;
  String? criteria = parameters.length >= 2 ? parameters[1] : null;

  field = _checkField(field);

  if (field == 0) {
    List<String> filteredData = applyCondition(database, 'int', criteria);

    if (filteredData.isEmpty) {
      return double.nan;
    }

    double sum = 0;

    for (var element in filteredData) {
      sum += double.parse(element);
    }
    double mean = sum / filteredData.length;

    // Calculate sum of squares of differences from the mean
    double sumSquares = 0;
    for (String value in filteredData) {
      sumSquares += math.pow(double.parse(value) - mean, 2);
    }

    // Calculate population standard deviation
    double stdevp = math.sqrt(sumSquares / filteredData.length);

    return stdevp;
  }

  return double.nan;
}

double dSum(List<String> parameters, List<String> database) {
  dynamic field = parameters.isNotEmpty ? parameters[0] : null;
  String? criteria = parameters.length >= 2 ? parameters[1] : null;

  double sum = 0;

  field = _checkField(field);

  if (field == 0) {
    List output = applyCondition(database, 'int', criteria);

    for (var data in output) {
      sum += int.parse(data);
    }
  }

  return sum;
}

double dVar(List<String> parameters, List<String> database) {
  dynamic field = parameters.isNotEmpty ? parameters[0] : null;
  String? criteria = parameters.length >= 2 ? parameters[1] : null;

  field = _checkField(field);

  if (field == 0) {
    List<String> filteredData = applyCondition(database, 'int', criteria);

    if (filteredData.isEmpty || filteredData.length == 1) {
      return double.nan;
    }

    double sum = 0;
    for (var element in filteredData) {
      sum += double.parse(element);
    }

    double mean = sum / filteredData.length;

    // Calculate sum of squares of differences from the mean
    double sumSquares = 0;
    for (String value in filteredData) {
      sumSquares += math.pow(double.parse(value) - mean, 2);
    }

    // Estimate population variance
    double variance = sumSquares / (filteredData.length - 1);

    return variance;
  }

  return double.nan;
}

double dVarP(List<String> parameters, List<String> database) {
  dynamic field = parameters.isNotEmpty ? parameters[0] : null;
  String? criteria = parameters.length >= 2 ? parameters[1] : null;

  field = _checkField(field);

  if (field == 0) {
    List<String> filteredData = applyCondition(database, 'int', criteria);

    if (filteredData.isEmpty) {
      return double.nan;
    }

    // Calculate mean

    double sum = 0;
    for (var element in filteredData) {
      sum += double.parse(element);
    }
    double mean = sum / filteredData.length;

    // Calculate sum of squares of differences from the mean
    double sumSquares = 0;
    for (String value in filteredData) {
      sumSquares += math.pow(double.parse(value) - mean, 2);
    }

    // Calculate population variance
    double variance = sumSquares / filteredData.length;

    return variance;
  }

  return double.nan;
}

List<List<dynamic>> expandA(List<String> parameters, List<String> database) {
  List<String> array = database;

  dynamic field = parameters.isNotEmpty ? parameters[0] : null;

  field = _checkField(field);

  if (field == 0) {
    int rows = parameters.length >= 2 ? int.parse(parameters[1]) : array.length;
    int columns = parameters.length >= 3 ? int.parse(parameters[2]) : 1;
    String padWith =
        parameters.length >= 4 && parameters[3] != '' ? parameters[3] : '#N/A';

    // Get the dimensions of the original array
    int originalRows = array.length;
    int originalColumns = 1;

    // Expand the array by padding rows and columns
    List<List<dynamic>> expandedArray = [];
    for (int i = 0; i < rows; i++) {
      List<dynamic> row = [];
      for (int j = 0; j < columns; j++) {
        if (i < originalRows && j < originalColumns) {
          row.add(array[i][j]);
        } else {
          // Pad the array with the specified value
          row.add(padWith);
        }
      }
      expandedArray.add(row);
    }

    return expandedArray;
  }
  return [];
}

List filter(List<String> parameters, List<String> database) {
  dynamic field = parameters.isNotEmpty ? parameters[0] : null;
  String? criteria = parameters.length >= 2 ? parameters[1] : null;

  field = _checkField(field);

  if (field == 0) {
    List filteredRecords = applyCondition(database, 'int', criteria);
    return filteredRecords;
  }

  return [];
}
