class ExpenseModel {
  int id;
  int year;
  String month;
  String purpose;
  double amount;
  String type;

  ExpenseModel({
    this.id = -1,
    required this.year,
    required this.month,
    required this.purpose,
    required this.amount,
    required this.type,
  });


  ExpenseModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        year = map['year'],
        month = map['month'],
        purpose = map['purpose'],
        amount = map['amount'],
        type = map['type'];

  Map <String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['year'] = year;
    data['month'] = month;
    data['purpose'] = purpose;
    data['amount'] = amount;
    data['type'] = type;
    return data;
  }

  factory ExpenseModel.fromJson(Map<String, dynamic> json){
    return ExpenseModel(
      id: json['id'] as int,
      year: json['year'] as int,
      month: json['month'] as String,
      purpose: json['purpose'] as String,
      amount: json['amount'] as double,
      type: json['type'] as String,
    );
  } 

  Map <String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['year'] = year;
    data['month'] = month;
    data['purpose'] = purpose;
    data['amount'] = amount;
    data['type'] = type;
    return data;
  }

  String toSubtitle() {
    return "R\$${amount.toStringAsFixed(2).replaceAll('.', ',')}  |  $type  |  $month/$year";
  }
}
