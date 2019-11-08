import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_auth_flow/app/utils/auth_utils.dart';
import 'package:flutter_auth_flow/app/utils/network_utils.dart';
import 'package:flutter_auth_flow/app/components/body_section.dart';
import 'package:flutter_auth_flow/app/models/item.dart';
import 'package:flutter_auth_flow/app/models/member.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_auth_flow/app/pages/order_detail_page.dart';

class DetailPage extends StatefulWidget {
  final String itemId;
  final String memberId;

  DetailPage(this.itemId, this.memberId);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  /// The full item data.
  Item item;
  Member member;
  /// Flag indicating whether the name field is nonempty.
  bool fieldHasContent = false;
  /// The controller to keep track of name field content and changes.
  final TextEditingController nameController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

	SharedPreferences _sharedPreferences;
  var _accessToken, _client, _uid, _expiry, _name, _email, _phone, itemId, memberId;
  /// Kicks off API fetch on creation.
  
  _DetailPageState() {
    _fetchAuthDetails();
    nameController.addListener(_handleTextChange);
  }

  _fetchMember(memberId) async {
    if(memberId != null) {
      print('calling get member');  
      _getMember();
    }  else{
      print("Calling create member");
      _createMember();
    } 
  }

  _getMember() async {
    var responseJson = await NetworkUtils.fetch(_accessToken, _client, _uid, _expiry, '/api/v1/members/' + widget.memberId);
    Map<String, dynamic> newMemberRaw = responseJson;
    Member newMember = Member.fromJson(newMemberRaw);
    setState(() {
      member = newMember;
    });
  }

  _createMember() async {
    var body = {
      'name': _name,
      'email': _email,
      'phone': _phone,
    };
    var responseJson = await NetworkUtils.post(_accessToken, _client, _uid, _expiry, '/api/v1/members', body);
    Map<String, dynamic> newMemberRaw = responseJson;
    Member newMember = Member.fromJson(newMemberRaw);
    setState(() {
      member = newMember;
    });
  }

  _fetchAuthDetails() async {
    _sharedPreferences = await _prefs;
		String accessToken = AuthUtils.getToken(_sharedPreferences);
		String client = AuthUtils.getClient(_sharedPreferences);
		String uid = AuthUtils.getUid(_sharedPreferences);
		String expiry = AuthUtils.getExpiry(_sharedPreferences);
    var email = _sharedPreferences.getString(AuthUtils.emailKey);
		var name = _sharedPreferences.getString(AuthUtils.nameKey);
		var phone = _sharedPreferences.getString(AuthUtils.phoneKey);

		_fetchItem(accessToken, client, uid, expiry, widget.itemId);
    _fetchMember(widget.memberId);

		setState(() {
			_accessToken = accessToken;
      _client = client;
      _uid = uid;
      _expiry = expiry;
      _name = name;
      _email = email;
      _phone = phone;
      itemId = widget.itemId;
      memberId = widget.memberId;
		});

		if(_accessToken == null) {
			print("Call logout.");
		}
  }

  /// Fetches the items details and updates state.
  void _fetchItem(String accessToken, String client, String uid, String expiry, String itemId) async {
    var responseJson = await NetworkUtils.fetch(accessToken, client, uid, expiry, '/api/v1/items/'+ itemId);
		if(responseJson == null) {
			NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');
		} else if(responseJson == 'NetworkError') {
			NetworkUtils.showSnackBar(_scaffoldKey, null);
		} else if(responseJson['errors'] != null) {
      print(responseJson['errors']);
		}
    Map<String, dynamic> newItemRaw = responseJson;
    Item newItem = Item.fromJson(newItemRaw);
    setState(() {
      item = newItem;
    });
  }

  /// Check out a item to the name entered.
  void _addToCart() async {
    var body = {
      'member_id': member.id,
      'item_id': item.id,
      'quantity': int.parse(nameController.text),
    };
    var responseJson = await NetworkUtils.post(_accessToken, _client, _uid, _expiry, '/api/v1/orders', body);
		if(responseJson == null) {
			NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');
		} else if(responseJson == 'NetworkError') {
			NetworkUtils.showSnackBar(_scaffoldKey, null);
		} else if(responseJson['errors'] != null) {
      print(responseJson['errors']);
		} else {
      Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return OrderDetailPage(memberId);
        }
      )
    );
    }
  }

  /// Remove a checked out entry for the name entered.
  void _return() async {
    // http.Response response = await http.post(
    //   'http://<API location>/returnItem',
    //   body: {'id': item.id, 'name': nameController.text},
    // );
    // Map<String, dynamic> newItemRaw = json.decode(response.body);
    // Item newItem = Item.fromJson(newItemRaw);
    // setState(() {
    //   item = newItem;
    // });
  }

  void _handleTextChange() {
    setState(() {
      fieldHasContent = int.parse(nameController.text) > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item?.name ?? ''),
      ),
      body: item != null
          ? new Center(
              child: new SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    elevation: 5.0,
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          BodySection(
                              'Category', item.category ?? 'N/A'),
                          BodySection('Description', item.description),
                          BodySection('Available Copies',
                              '${item.remainingQuantity} / ${item.quantity}'),
                          Column(
                            children: <Widget>[
                              TextField(
                                decoration:
                                    InputDecoration(hintText: 'Enter Required Quantity'),
                                controller: nameController,
                              ),
                              new Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    RaisedButton(
                                      child: Text('Add Order'),
                                      onPressed: fieldHasContent &&
                                              item.remainingQuantity > int.parse(nameController.text)
                                          ? _addToCart
                                          : null,
                                    ),
                                    RaisedButton(
                                      child: Text('Return'),
                                      onPressed:
                                          fieldHasContent ? _return : null,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )),
                  ),
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

