import 'db_excel_functions_impl.dart';
import 'excel_functions_impl.dart';

dynamic runExcelFunction(String name, List<String> parameters) {
  name = name.toLowerCase();

  switch (name) {
    case "date":
      return date(parameters);
    case "day":
      return day(parameters);
    case "days":
      return days(parameters);
    case "days360":
      return days360(parameters);
    case "datedif":
      return dateDif(parameters);
    case "datevalue":
      return dateValue(parameters);
    case "db":
      return db(parameters);
    case "dbcs":
      return dbcs(parameters);
    case "ddb":
      return ddb(parameters);
    case "dec2bin":
      return dec2bin(parameters);
    case "dec2hex":
      return dec2hex(parameters);
    case "dec2oct":
      return dec2oct(parameters);
    case "decimal":
      return decimal(parameters);
    case "degrees":
      return degrees(parameters);
    case "delta":
      return delta(parameters);
    case "devsq":
      return devsq(parameters);
    case "disc":
      return disc(parameters);
    case "dollar":
      return dollar(parameters);
    case "dollarde":
      return dollarDE(parameters);
    case "dollarfr":
      return dollarFR(parameters);
    case "duration":
      return durationExcel(parameters);
    case "edate":
      return edate(parameters);
    case "effect":
      return effect(parameters);
    case "encodeurl":
      return encodeUrl(parameters);
    case "eomonth":
      return eomonth(parameters);
    case "erf":
      return erf(parameters);
    case "erf.precise":
      return erfPrecise(parameters);
    case "erfc":
      return erfc(parameters);
    case "erfc.precise":
      return erfcPrecise(parameters);
    case "error.type":
      return errorType(parameters);
    case "euroconvert":
      return euroConvert(parameters);
    case "even":
      return even(parameters);
    case "exact":
      return exact(parameters);
    case "exp":
      return exponential(parameters);
    case "expon.dist":
      return exponDotDist(parameters);
    case "expondist":
      return exponDotDist(parameters);
    case "fact":
      return fact(parameters);
    case "factdouble":
      return factDouble(parameters);
    case "false":
      return falseFunction();
    case "f.dist":
      return fDotDist(parameters);
    case "fdist":
      return fDist(parameters);
    case "f.dist.rt":
      return fDistRT(parameters);
    case "find":
      return find(parameters);
    case "findb":
      return find(parameters);
    case "f.inv":
      return fInv(parameters);
    case "f.inv.rt":
      return fInvRt(parameters);
    default:
      throw ArgumentError("Function $name not found");
  }
}

dynamic runDatabaseExcelFunction(
    String name, List<String> parameters, List<String> database) {
  name = name.toLowerCase();

  switch (name) {
    case "daverage":
      return dAverage(parameters, database);
    case "dcount":
      return dCount(parameters, database);
    case "dcounta":
      return dCountA(parameters, database);
    case "dget":
      return dGet(parameters, database);
    case "dmax":
      return dMax(parameters, database);
    case "dmin":
      return dMin(parameters, database);
    case "dproduct":
      return dProduct(parameters, database);
    case "drop":
      return drop(parameters, database);
    case "dstdev":
      return dstDev(parameters, database).toString();
    case "dstdevp":
      return dstDevP(parameters, database);
    case "dsum":
      return dSum(parameters, database);
    case "dvar":
      return dVar(parameters, database);
    case "dvarp":
      return dVarP(parameters, database);
    case "expand":
      return expandA(parameters, database);
    case "filter":
      return filter(parameters, database);
    default:
      return "Function $name not found";
  }
}

dynamic callFunction(
  String textFieldInput,
  bool isDbFunction,
  List<String> database,
) {

  textFieldInput = textFieldInput.startsWith('=')
      ? textFieldInput.substring(1)
      : textFieldInput;

  List<String> parameters = [];

  String functionName = textFieldInput.split('(').first;

  textFieldInput = textFieldInput.split('(').last;
  textFieldInput = textFieldInput.split(')').first;

  if (textFieldInput.trim().isNotEmpty) {
    parameters = textFieldInput.split(',');
  }

  if (isDbFunction) {
    return runDatabaseExcelFunction(functionName, parameters, database);
  } else {
    return runExcelFunction(functionName, parameters);
  }
}
