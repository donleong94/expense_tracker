class Category {
  Category({
    required this.name,
    required this.recommendedPercentage,
    required this.isFixed,
  });

  final String? name;
  final int? recommendedPercentage;
  final bool? isFixed;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      recommendedPercentage: json['recommendedPercentage'],
      isFixed: json['isFixed'],
    );
  }
}
