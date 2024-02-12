
class ShopsList {
  final String name;
  final int cost;

  ShopsList({required this.name, required this.cost});

  factory ShopsList.fromJson(Map<String, dynamic> json) {
    return ShopsList(
      name: json['name'] as String,
      cost: json['cost'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cost': cost,
    };
  }
}