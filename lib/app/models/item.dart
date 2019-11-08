class Item {
  final int id;
  final String name;
  final String category;
  final String description;
  final int quantity;
  final int remainingQuantity;

  /// Creates a Item instance out of JSON received from the API.
  Item.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        category = json['category'],
        description = json['description'],
        quantity = json['quantity'],
        remainingQuantity = json['remaining_quantity'];
}