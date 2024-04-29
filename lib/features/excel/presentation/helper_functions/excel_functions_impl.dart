import 'dart:math' as math;
import 'dart:math';
import 'package:dart_numerics/dart_numerics.dart';
import 'package:dart_numerics/dart_numerics.dart' as dn;
import 'package:flutter/foundation.dart';

import 'helper_functions.dart';

String date(List<String> params) {
  String date = params[0];
  DateTime decodedData = decodeDate(date);
  return '${decodedData.day}/${decodedData.month}/${decodedData.year}';
}

int dateDif(List<String> parameters) {
  DateTime startDate = decodeDate(parameters[0]);
  DateTime endDate = decodeDate(parameters[1]);
  String unit = parameters[2].toLowerCase();

  Duration difference = endDate.difference(startDate);

  // Convert duration to days, months, or years based on the specified unit
  switch (unit.toUpperCase()) {
    case "Y":
      return (endDate.year - startDate.year);
    case "M":
      return ((endDate.year - startDate.year) * 12) +
          (endDate.month - startDate.month);
    case "D":
      return difference.inDays;
    case "MD":
      return endDate.day - startDate.day;
    case "YM":
      return (endDate.month - startDate.month) +
          ((endDate.year - startDate.year) * 12);
    case "YD":
      return difference.inDays % 365;
    default:
      throw ArgumentError("Invalid unit provided");
  }
}

int? dateValue(List<String> params) {
  try {
    String dateText = params[0];

    DateTime decodedDate = decodeDate(dateText);

    // Calculate the difference in days from January 1, 1900
    DateTime baseDate = DateTime(1900, 1, 1);
    int differenceInDays = decodedDate.difference(baseDate).inDays;

    return differenceInDays + 1; // Excel's serial number starts from 1
  } catch (e) {
    if (kDebugMode) {
      print("Error: Invalid date format");
    }
    return null;
  }
}

String day(List<String> params) {
  String date = params[0];
  DateTime decodedDate = decodeDate(date);
  return decodedDate.day.toString();
}

String days(List<String> date) {
  DateTime startDate = decodeDate(date[0]);
  DateTime endDate = decodeDate(date[1]);

  return startDate.difference(endDate).inDays.toString() ?? '';
}

int days360(List<String> parameters) {
  DateTime startDate = decodeDate(parameters[0]);
  DateTime endDate = decodeDate(parameters[1]);

  int startDay = startDate.day;
  int startMonth = startDate.month;
  int startYear = startDate.year;
  int endDay = endDate.day;
  int endMonth = endDate.month;
  int endYear = endDate.year;

  if (endDay == 31) endDay = 30;

  int days = (endYear - startYear) * 360 +
      (endMonth - startMonth) * 30 +
      (endDay - startDay);

  return days;
}

double db(List<String> params) {
  double cost = double.parse(params[0]);
  double salvage = double.parse(params[1]);
  double life = double.parse(params[2]);
  double period = double.parse(params[3]);
  double month =
      ( (params.length > 4 && params[4] == '') || params.length <=4) ? 12 : double.parse(params[4]);

  print('params are $cost $salvage $life $period $month');

  double rate = 1 - (math.pow((salvage / cost), (1 / life))).toDouble();

  // Special case for the first period
  if (period == 1) {
    return cost * rate * month / 12;
  }

  // Special case for the last period
  if (period == life) {
    double totalDepreciation = 0;
    for (int i = 1; i < life; i++) {
      totalDepreciation += db(
          [cost.toString(), salvage.toString(), life.toString(), i.toString()]);
    }
    return ((cost - totalDepreciation) * rate * (12 - month)) / 12;
  }

  // Regular depreciation calculation
  double priorDepreciation = 0;
  for (int i = 1; i < period; i++) {
    priorDepreciation += db(
        [cost.toString(), salvage.toString(), life.toString(), i.toString()]);
  }
  return (cost - priorDepreciation) * rate;
}

String dbcs(List<String> params) {
  String str = params[0];
  StringBuffer result = StringBuffer();

  for (int i = 0; i < str.length; i++) {
    int charCode = str.codeUnitAt(i);

    // Convert half-width letters to full-width
    if (charCode >= 0x20 && charCode <= 0x7E) {
      result.writeCharCode(charCode + 0xFF00 - 0x20);
    } else {
      result.write(str[i]);
    }
  }

  return result.toString();
}

double ddb(List<String?> params) {
  double cost = double.parse(params[0]!);
  double salvage = double.parse(params[1]!);
  double life = double.parse(params[2]!);
  double period = double.parse(params[3]!);
  double factor = params.length > 4 && params[4] == null && params[4] == ''
      ? double.parse(params[4]!)
      : 2.0;

  if (cost <= 0 || salvage < 0 || life <= 0 || period <= 0 || factor <= 0) {
    throw ArgumentError("All arguments must be positive numbers.");
  }

  double totalDepreciation = 0;
  late double depreciation;

  for (int i = 1; i <= period; i++) {
    if (i == 1) {
      depreciation = (cost * factor / life).toDouble();
    } else {
      depreciation = ((cost - totalDepreciation) * factor / life).toDouble();
    }

    totalDepreciation += depreciation;

    if (totalDepreciation >= cost - salvage) {
      return (cost - salvage - totalDepreciation + depreciation).toDouble();
    }
  }

  return depreciation;
}

String dec2bin(List<String> params) {
  int number = int.parse(params[0]);
  int? places = params.length > 1 ? int.parse(params[1]) : null;

  if (number < -512 || number > 511) {
    return '#NUM!';
  }

  if (number.isNaN) {
    return '#VALUE!';
  }

  String binary = number.toRadixString(2);

  if (places != null) {
    if (places <= 0) {
      return '#NUM!';
    }

    if (binary.length > places) {
      return '#NUM!';
    }

    return binary.padLeft(places, '0');
  }

  return binary;
}

String dec2hex(List<String> params) {
  int number = int.parse(params[0]);
  int? places = params.length > 1 ? int.parse(params[1]) : null;

  if (number < -549755813888 || number > 549755813887) {
    return '#NUM!';
  }

  if (number.isNaN) {
    return '#VALUE!';
  }

  String hex = number.toRadixString(16).toUpperCase();

  if (places != null) {
    if (places <= 0) {
      return '#NUM!';
    }

    if (hex.length > places) {
      return '#NUM!';
    }

    return hex.padLeft(places, '0');
  }

  return hex;
}

String dec2oct(List<String> params) {
  int number = int.parse(params[0]);
  int? places = params.length > 1 ? int.parse(params[1]) : null;

  if (number < -536870912 || number > 536870911) {
    return '#NUM!';
  }

  if (number.isNaN) {
    return '#VALUE!';
  }

  String octal = number.toRadixString(8);

  if (places != null) {
    if (places <= 0) {
      return '#NUM!';
    }

    if (octal.length > places) {
      return '#NUM!';
    }

    return octal.padLeft(places, '0');
  }

  return octal;
}

int decimal(List<String> params) {
  int radix = int.parse(params[1]);
  return int.parse(params[0], radix: radix);
}

double degrees(List<String> params) {
  double angle = double.parse(params[0]);
  return angle * (180 / math.pi);
}

int delta(List<String> params) {
  double number1 = double.parse(params[0]);
  print('11number1 is $number1 ');

  double number2 = params.length > 1 ? double.parse(params[1]) : 0.0;

  print('number1 is $number1 and number2 is $number2');
  
  return number1 == number2 ? 1 : 0;
}

double devsq(List<String> params) {

  List<double> numbers = params.map((e) => double.parse(e)).toList();

  double sum = 0;

  for (var element in numbers) {
    sum+= element;
  }

  // Calculate the mean
  double mean = sum / numbers.length;

  // Calculate the sum of squares of deviations
  double sumOfSquares = 0;
  for (int i = 0; i < numbers.length; i++) {
    double deviation = numbers[i] - mean;
    sumOfSquares += deviation * deviation;
  }

  return sumOfSquares;
}

double disc(List<String> params) {
  DateTime settlement = decodeDate(params[0]);
  DateTime maturity = decodeDate(params[1]);
  double pr = double.parse(params[2]);
  double redemption = double.parse(params[3]);
  int basis = params.length > 4 ? int.parse(params[4]) : 0;

  // Calculate the number of days between settlement and maturity
  int dsm = maturity.difference(settlement).inDays;

  // Check if settlement is less than maturity
  if (dsm <= 0) {
    throw ArgumentError("Settlement date must be before maturity date.");
  }

  // Calculate the number of days in a year based on the year basis
  int b;
  switch (basis) {
    case 0:
      b = 360;
      break;
    case 1: // Actual/actual
      b = 365;
      break;
    case 2: // Actual/360
      b = 360;
      break;
    case 3: // Actual/365
      b = 365;
      break;
    case 4: // European 30/360
      b = 360;
      break;
    default:
      throw ArgumentError(
          "Invalid basis value. Basis must be between 0 and 4.");
  }

  // Calculate DISC
  return (redemption - pr) / (pr * (dsm / b));
}

String dollar(List<String> params) {
  double number = double.parse(params[0]);
  int decimals = params.length > 1 ? int.parse(params[1]) : 2;

  double roundedNumber = double.parse(number.toStringAsFixed(decimals));

  return '\$${roundedNumber.toStringAsFixed(decimals)}';
}

double dollarDE(List<String> params) {
  double fractionalDollar = double.parse(params[0]);
  int fraction = int.parse(params[1]);

  if (fraction < 0) {
    throw ArgumentError("Fraction must be greater than or equal to 0.");
  }

  if (fraction >= 0 && fraction < 1) {
    throw ArgumentError("Fraction must be greater than or equal to 1.");
  }

  return fractionalDollar + (fractionalDollar.truncate() / fraction);
}

String dollarFR(List<String> params) {
  double decimalDollar = double.parse(params[0]);
  int fraction = int.parse(params[1]);

  if (fraction < 0) {
    throw ArgumentError("Fraction must be greater than or equal to 0.");
  }

  if (fraction == 0) {
    throw ArgumentError("Fraction cannot be 0.");
  }

  int integerPart = decimalDollar.toInt();

  int numerator = ((decimalDollar - integerPart) * fraction).toInt();

  return '$integerPart and $numerator/$fraction';
}

double durationExcel(List<String> params) {
  DateTime settlement = decodeDate(params[0]);
  DateTime maturity = decodeDate(params[1]);
  double coupon = double.parse(params[2]);
  double yld = double.parse(params[3]);
  int frequency = int.parse(params[4]);
  int basis = params.length > 5 ? int.parse(params[5]) : 0;

  int settlementInt =
      settlement.millisecondsSinceEpoch ~/ (24 * 60 * 60 * 1000);
  int maturityInt = maturity.millisecondsSinceEpoch ~/ (24 * 60 * 60 * 1000);

  if (settlementInt >= maturityInt) {
    throw ArgumentError("Settlement date must be before maturity date.");
  }

  if (coupon < 0 || yld < 0) {
    throw ArgumentError("Coupon and yield must be non-negative.");
  }

  if (![1, 2, 4].contains(frequency)) {
    throw ArgumentError("Frequency must be 1, 2, or 4.");
  }

  if (basis < 0 || basis > 4) {
    throw ArgumentError("Basis must be between 0 and 4.");
  }

  double duration = 0.0;
  for (int i = 1; i <= maturityInt - settlementInt; i++) {
    double presentValue = coupon / frequency;
    if (i % (365 / frequency) == 0) {
      presentValue += 100.0 /
          math.pow(1 + yld / frequency, i.toDouble() / (365.0 / frequency));
    }
    duration += presentValue * i / (365.0 / frequency);
  }

  duration /= 100.0;

  return duration;
}

DateTime edate(List<String> params) {
  DateTime startDate = decodeDate(params[0]);
  int months = int.parse(params[1]);

  return DateTime(startDate.year, startDate.month + months, startDate.day);
}

double effect(List<String> params) {
  double nominalRate = double.parse(params[0]);
  int npery = int.parse(params[1]);

  int nperyInt = npery;

  // Check if nominalRate or npery is nonnumeric
  if (nominalRate.isNaN || nperyInt.isNaN) {
    throw ArgumentError("Both nominalRate and npery must be numeric.");
  }

  // Check if nominalRate is not positive or if npery is less than 1
  if (nominalRate <= 0 || nperyInt < 1) {
    throw ArgumentError(
        "Nominal rate must be positive and npery must be at least 1.");
  }

  // Calculate effective interest rate using pow function
  double effectiveRate = (1 + (nominalRate / nperyInt));
  effectiveRate = math.pow(effectiveRate, nperyInt) - 1;

  return effectiveRate;
}

String encodeUrl(List<String> params) {
  String text = params[0];

  // Define a map of characters that need to be encoded
  Map<String, String> urlEncodeMap = {
    "%": "%25",
    "!": "%21",
    "#": "%23",
    "\$": "%24",
    "&": "%26",
    "'": "%27",
    "(": "%28",
    ")": "%29",
    "*": "%2A",
    "+": "%2B",
    ",": "%2C",
    "/": "%2F",
    ":": "%3A",
    ";": "%3B",
    "=": "%3D",
    "?": "%3F",
    "@": "%40",
    "[": "%5B",
    "]": "%5D",
    " ": "%20",
  };

  // Encode each character in the input text
  String encodedText = "";
  for (int i = 0; i < text.length; i++) {
    String char = text[i];
    if (urlEncodeMap.containsKey(char)) {
      encodedText += urlEncodeMap[char]!;
    } else {
      encodedText += char;
    }
  }

  return encodedText;
}

DateTime eomonth(List<String> params) {
  DateTime startDate = decodeDate(params[0]);
  int months = int.parse(params[1]);

  DateTime adjustedDate = DateTime(startDate.year, startDate.month + months, 1);

  if (adjustedDate.month == 2) {
    adjustedDate = DateTime(adjustedDate.year, adjustedDate.month, 0);
  } else {
    adjustedDate = DateTime(adjustedDate.year, adjustedDate.month + 1, 0);
  }

  return adjustedDate;
}

double erf(List<String> params) {
  double value = double.parse(params[0]);

  return dn.erf(value);
}

double erfPrecise(List<String> params) {
  double value = double.parse(params[0]);

  return dn.erf(value);
}

String erfc(List<String> params) {
  double value = double.parse(params[0]);

  return dn.erfc(value).toString();
}

double erfcPrecise(List<String> params) {
  double value = double.parse(params[0]);

  return dn.erfc(value);
}

int errorType(List<String> params) {
  String? errorVal = params.isNotEmpty ? params[0] : null;

  if (errorVal == null) {
    return 1; // #NULL!
  } else {
    switch (errorVal.toString()) {
      case "#DIV/0!":
        return 2;
      case "#VALUE!":
        return 3;
      case "#REF!":
        return 4;
      case "#NAME?":
        return 5;
      case "#NUM!":
        return 6;
      case "#N/A":
        return 7;
      case "#GETTING_DATA":
        return 8;
      default:
        return 7;
    }
  }
}

double euroConvert(List<String> params) {
  double number = double.parse(params[0]);
  String source = params[1];
  String target = params[2];
  bool fullPrecision = bool.parse(params[3], caseSensitive: false);
  int triangulationPrecision = int.parse(params[4]);

  Map<String, double> conversionRates = {
    'BEF': 40.3399,
    'LUF': 40.3399,
    'DEM': 1.95583,
    'ESP': 166.386,
    'FRF': 6.55957,
    'IEP': 0.787564,
    'ITL': 1936.27,
    'NLG': 2.20371,
    'ATS': 13.7603,
    'PTE': 200.482,
    'FIM': 5.94573,
    'GRD': 340.750,
    'SIT': 239.640,
    'EUR': 1.0,
  };

  if (!conversionRates.containsKey(source) ||
      !conversionRates.containsKey(target)) {
    throw ArgumentError('Invalid currency ISO code');
  }

  double result;
  if (source == target) {
    // If source and target are the same, return the original number
    result = number;
  } else {
    if (source == 'EUR') {
      // Convert from Euro to another currency
      result = number * conversionRates[target]!;
    } else if (target == 'EUR') {
      // Convert to Euro from another currency
      result = number / conversionRates[source]!;
    } else {
      // Triangulation: Convert from one non-Euro currency to another via Euro
      double euroValue = number / conversionRates[source]!;
      result = euroValue * conversionRates[target]!;
    }
  }

  if (!fullPrecision) {
    int precision = 2;
    if (source != 'EUR') {
      // Set precision based on source currency
      precision = (source == 'BEF' ||
              source == 'LUF' ||
              source == 'ESP' ||
              source == 'ITL' ||
              source == 'PTE' ||
              source == 'GRD')
          ? 0
          : 2;
    }
    result = double.parse(result.toStringAsFixed(precision));
  } else if (triangulationPrecision >= 3) {
    // Apply triangulation precision if provided
    result = double.parse(result.toStringAsFixed(triangulationPrecision));
  }

  return result;
}

int even(List<String> params) {
  double number = double.parse(params[0]);

  // Check if the input is nonnumeric
  if (number.isNaN) {
    throw ArgumentError('Nonnumeric value');
  }

  int result = number.ceil();
  if (result.isOdd) {
    result++;
  }

  return result;
}

bool exact(List<String> params) {
  String text1 = params[0];
  String text2 = params[1];

  return text1 == text2;
}

double exponential(List<String> params) {
  double number = double.parse(params[0]);

  return math.pow(math.e, number).toDouble();
}

double exponDotDist(List<String> params) {
  double x = double.parse(params[0]);
  double lambda = double.parse(params[1]);
  bool cumulative = bool.parse(params[2], caseSensitive: false);

  if (x < 0 || lambda <= 0 || !x.isFinite || !lambda.isFinite) {
    return double.nan; // Return NaN for invalid inputs
  }

  if (cumulative) {
    // Cumulative distribution function
    return 1 - exp(-lambda * x);
  } else {
    // Probability density function
    return lambda * exp(-lambda * x);
  }
}

double exponDist(List<String> params) {
  double x = double.parse(params[0]);
  double lambda = double.parse(params[1]);
  bool cumulative = bool.parse(params[2], caseSensitive: false);

  if (x < 0 || lambda <= 0 || !x.isFinite || !lambda.isFinite) {
    return double.nan; // Return NaN for invalid inputs
  }

  if (cumulative) {
    // Cumulative distribution function
    return 1 - exp(-lambda * x);
  } else {
    // Probability density function
    return lambda * exp(-lambda * x);
  }
}

int fact(List<String> params) {
  int number = int.parse(params[0]);

  if (number < 0) {
    // Factorial of a negative number is not defined
    throw ArgumentError('Factorial of a negative number is not defined.');
  }

  int result = 1;
  for (int i = 2; i <= number; i++) {
    result *= i;
  }
  return result;
}

int factDouble(List<String> params) {
  int number = int.parse(params[0]);

  if (number < 0) {
    throw ArgumentError(
        'Double factorial of a negative number is not defined.');
  }

  int result = 1;
  for (int i = number; i >= 1; i -= 2) {
    result *= i;
  }
  return result;
}

String falseFunction() {
  return 'FALSE';
}

double fDotDist(List<String> params) {

  double x = double.parse(params[0]);
  int degFreedom1 = int.parse(params[1]);
  int degFreedom2 = int.parse(params[2]);

  double p = dn.gammaLowerRegularized(
      degFreedom1 / 2, (degFreedom1 * x) / (degFreedom1 * x + degFreedom2 / 2));
  return p;

}

double fDist(List<String> params) {

  double x = double.parse(params[0]);
  int degFreedom1 = int.parse(params[1]);
  int degFreedom2 = int.parse(params[2]);

  double p = dn.gammaLowerRegularized(
      degFreedom1 / 2, (degFreedom1 * x) / (degFreedom1 * x + degFreedom2 / 2));
  return p;
}

double fDistRT(List<String> params) {
  double x = double.parse(params[0]);
  int degFreedom1 = int.parse(params[1]);
  int degFreedom2 = int.parse(params[2]);

  if (x < 0) return double.nan; // Returns #NUM! error value if x is negative
  if (degFreedom1 < 1 || degFreedom2 < 1) {
    return double.nan;
  }

  double numerator = (math.pow(degFreedom1 * x, degFreedom1) *
          math.pow(degFreedom2, degFreedom2))
      .toDouble();

  double denominator = math
      .pow((degFreedom1 * x) + degFreedom2, degFreedom1 + degFreedom2)
      .toDouble();

  double result = numerator / denominator;
  return result;
}

dynamic find(List<String> params) {
  String findText = params[0];
  String withinText = params[1];
  int startNum = params.length > 2 ? int.parse(params[2]) : 1;

  if (startNum <= 0) {
    return "#VALUE!";
  }

  int index = withinText.indexOf(findText, startNum - 1);
  if (index == -1) {
    return '#VALUE! ';
  }

  return index + 1;
}

double fInv(List<String> params) {

  double probability = double.parse(params[0]);
  int degFreedom1 = int.parse(params[1]);
  int degFreedom2 = int.parse(params[2]);

  if (probability < 0 ||
      probability > 1 ||
      degFreedom1 < 1 ||
      degFreedom2 < 1) {
    return double.nan; // Returns NaN for error value
  }

  // Implementation of the inverse F cumulative distribution function
  // Using Newton's method for finding roots of equations
  double x0 = 0.0; // Initial guess
  double tol = 1e-10; // Tolerance
  int maxIter = 100; // Maximum number of iterations
  int iter = 0;
  double fx = 1.0;

  while ((fx.abs() > tol) && (iter < maxIter)) {
    double f = probability -
        _fdist(
            x0, degFreedom1, degFreedom2, false); // Calculating F distribution
    double df = -_fdist(x0, degFreedom1, degFreedom2,
        true); // Calculating derivative of F distribution
    double dx = f / df;
    x0 -= dx;
    fx = f;
    iter++;
  }

  return x0;
}

double _fdist(double x, int degFreedom1, int degFreedom2, bool cumulative) {

  double a = degFreedom1 / 2;
  double b = degFreedom2 / 2;

  double num = math.pow(a * x, a) *
      math.pow(b, b) *
      exp(-x * (a + b)) /
      (gamma(a) * gamma(b) * gamma(a + b));

  if (cumulative) {
    double sum = 0;
    double term = 1;
    for (int i = 0; i <= a - 1; i++) {
      term *= (1 + (b - 1) / (a - 1) * x) / (1 + b / (a - 1) * x);
      sum += term;
    }
    return 1 - sum * num;
  } else {
    return num;
  }
}

double fInvRt(List<String> params) {

  double probability = double.parse(params[0]);
  int degFreedom1 = int.parse(params[1]);
  int degFreedom2 = int.parse(params[2]);

  if (probability < 0 ||
      probability > 1 ||
      degFreedom1 < 1 ||
      degFreedom2 < 1 ||
      degFreedom2 >= 1e10) {
    return double.nan; // Return NaN for error value
  }

  // Initial guess for the root
  double guess = 1.0;

  // Find the root using an iterative search technique
  double root = _findRoot(
      (x) =>
          fDistRT(
              [x.toString(), degFreedom1.toString(), degFreedom2.toString()]) -
          probability,
      guess);

  return root;
}

double _findRoot(double Function(double) f, double guess,
    {double tolerance = 1e-10, int maxIterations = 64,}) {
  double x0 = guess;
  double fx = f(x0);
  double dfx = _derivative(f, x0);

  int iterations = 0;
  while ((fx.abs() > tolerance) && (iterations < maxIterations)) {
    x0 = x0 - fx / dfx;
    fx = f(x0);
    dfx = _derivative(f, x0);
    iterations++;
  }

  if (iterations >= maxIterations) {
    return double.nan; // Return NaN if convergence is not reached
  }

  return x0;
}

// Function to calculate the derivative of a given function using numerical approximation
double _derivative(double Function(double) f, double x,
    {double epsilon = 1e-10,}) {
  return (f(x + epsilon) - f(x - epsilon)) / (2 * epsilon);
}
