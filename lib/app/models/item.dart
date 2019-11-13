class Item {
  final int id;
  final String name;
  final String category;
  final String description;
  final String itemCode;
  final String lotNo;
  final int primaryQty;
  final String primaryUom;
  final int secondaryQty;
  final String secondaryUom;
  final int quantity;
  final int remainingQuantity;

  /// Creates a Item instance out of JSON received from the API.
  Item.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        category = json['category'],
        description = json['description'],
        itemCode = json['item_code'],
        lotNo = json['lot_no'],
        primaryQty = json['primary_qty'],
        primaryUom = json['primary_uom'],
        secondaryQty = json['secondary_qty'],
        secondaryUom = json['secondary_uom'],
        quantity = json['quantity'],
        remainingQuantity = json['remaining_quantity'];
}