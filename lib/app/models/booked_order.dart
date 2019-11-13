class BookedOrder {
  final int id;
  final String itemDescription;
  final String itemCode;
  final String lotNo;
  final String primaryQty;
  final String primaryUom;
  final int secondaryQty;
  final String secondaryUom;
  final String soNumber;
  final int loadBags;

  /// Creates a BookedOrder instance out of JSON received from the API.
  BookedOrder.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        itemCode = json['item_code'],
        itemDescription = json['item_desc'],
        lotNo = json['lot_no'],
        primaryQty = json['primary_qty'],
        primaryUom = json['primary_uom'],
        secondaryQty = json['secondary_qty'],
        secondaryUom = json['secondary_uom'],
        soNumber = json['so_number'],
        loadBags = json['load_bags'];
}