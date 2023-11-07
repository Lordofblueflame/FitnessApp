class UserDayEntry {
  final int entryId;
  final int userId;
  final String date;
  int? water;
  int? workout;
  int? productInMeal;

  UserDayEntry({
    required this.entryId,
    required this.userId,
    required this.date,
    this.water,
    this.workout,
    this.productInMeal,
  });

  factory UserDayEntry.fromJson(Map<String, dynamic> json) {
    return UserDayEntry(
      entryId: json['entry_id'],
      userId: json['user_id'],
      date: json['date'].toString(),
      water: json['water'],
      workout: json['workout'],
      productInMeal: json['product_in_meal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entry_id': entryId,
      'user_id': userId,
      'date': date,
      'water': water,
      'workout': workout,
      'product_in_meal': productInMeal,
    };
  }
}
