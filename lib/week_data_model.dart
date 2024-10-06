class WeekData {
  final String weekRange;
  final String size;
  final String fruit;
  final String babyGrowth;
  final String motherSymptoms;

  WeekData({
    required this.weekRange,
    required this.size,
    required this.fruit,
    required this.babyGrowth,
    required this.motherSymptoms,
  });

  factory WeekData.fromJson(Map<String, dynamic> json) {
    return WeekData(
      weekRange: json['weekRange'],
      size: json['size'],
      fruit: json['fruit'],
      babyGrowth: json['babyGrowth'],
      motherSymptoms: json['motherSymptoms'],
    );
  }
}
