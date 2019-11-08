class Order {
  final int quantity;
  final String name;
  final String status;

  /// Creates a Item instance out of JSON received from the API.
  Order.fromJson(Map<String, dynamic> json)
      : name = json['item']['name'],
        quantity = json['quantity'],
        status = json['status'];
}