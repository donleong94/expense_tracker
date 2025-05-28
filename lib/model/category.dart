class Category {
  final String? name;
  final int? recommendedPercentage;
  final bool? isFixed;

  Category({
    required this.name,
    required this.recommendedPercentage,
    required this.isFixed,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      recommendedPercentage: json['recommendedPercentage'],
      isFixed: json['isFixed'],
    );
  }
}
