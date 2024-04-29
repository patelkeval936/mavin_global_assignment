
class ExcelFunction {
  String name;
  String category;
  String description;
  String definition;
  String output;
  bool isDbFunction;

  ExcelFunction({
    required this.name,
    required this.category,
    required this.description,
    required this.definition,
    required this.output,
    required this.isDbFunction,
  });

  factory ExcelFunction.fromJson(Map<String, dynamic> json) {
    return ExcelFunction(
      name: json["name"],
      category: json["category"],
      description: json["description"],
      definition: json["definition"],
      output: json["output"],
      isDbFunction: json["isDBFunction"],
    );
  }

}