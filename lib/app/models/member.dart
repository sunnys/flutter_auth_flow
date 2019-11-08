import 'package:flutter_auth_flow/app/models/order.dart';

class Member {
  final int id;
  final String name;
  final String email;
  final String phone;
  final List<Order> orders;

  Member({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.orders
  });

  /// Creates a Item instance out of JSON received from the API.
  factory Member.fromJson(Map<String, dynamic> json) {
    var list = json['orders'] as List;
    print(list.runtimeType); //returns List<dynamic>
    List<Order> orderList;
    if(list != null) {
      orderList = list.map((i) => Order.fromJson(i)).toList();
    }
    return Member(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      orders: orderList
    );
  }
  
}
