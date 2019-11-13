import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_auth_flow/app/utils/auth_utils.dart';
import 'package:flutter_auth_flow/app/utils/network_utils.dart';
import 'package:flutter_auth_flow/app/models/member.dart';
import 'package:flutter_auth_flow/app/pages/scan_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetailPage extends StatefulWidget {
  final String memberId;

  OrderDetailPage(this.memberId);

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  /// The full member data.
  Member member;
  /// Flag indicating whether the name field is nonempty.
  bool fieldHasContent = false;
  /// The controller to keep track of name field content and changes.
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

	SharedPreferences _sharedPreferences;
  var _accessToken, _client, _uid, _expiry;
  /// Kicks off API fetch on creation.
  _OrderDetailPageState() {
    _fetchAuthDetails();
  }

  Future<void> _neverSatisfied(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Validation Result'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
                // Text('You\’re like me. I’m never satisfied.'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  _getMember() async {
    var responseJson = await NetworkUtils.fetch(_accessToken, _client, _uid, _expiry, '/api/v1/members/' + widget.memberId);
    Map<String, dynamic> newMemberRaw = responseJson;
    Member newMember = Member.fromJson(newMemberRaw);
    setState(() {
      member = newMember;
    });
  }
  
  _validateOrder() async {
    var responseJson = await NetworkUtils.fetch(_accessToken, _client, _uid, _expiry, '/api/v1/members/' + widget.memberId + '/validate');
    print(responseJson);
    _neverSatisfied(responseJson['message']);
  }


  _fetchAuthDetails() async {
    _sharedPreferences = await _prefs;
		String accessToken = AuthUtils.getToken(_sharedPreferences);
		String client = AuthUtils.getClient(_sharedPreferences);
		String uid = AuthUtils.getUid(_sharedPreferences);
		String expiry = AuthUtils.getExpiry(_sharedPreferences);
		_getMember();
		setState(() {
			_accessToken = accessToken;
      _client = client;
      _uid = uid;
      _expiry = expiry;
		});
		if(_accessToken == null) {
			print("Call logout.");
		}
  }

  // _navigateToScan() {
  //   print('+++++++++++++++++++++++++++++++++++++=');
  //   print(member.id);
  //   print('+++++++++++++++++++++++++++++++++++++=');
  //   Navigator.push(_scaffoldKey.currentContext, new MaterialPageRoute(builder: (context) =>new ScanPage(member.id.toString())));
  // }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: member.orders.length,
        itemBuilder: /*1*/ (context, i) {
          return _buildRow(member.orders[i].name, member.orders[i].quantity.toString());
        });
  }
  Widget _buildRow(String item, String quantity) {
    return ListTile(
      title: Text(
        "$item X $quantity",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(member?.name ?? ''),
      ),
      body: member != null
          ? 
          Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: TextField(
                  decoration: InputDecoration(hintText: 'Search for titles...'),
                ),
              ),
              new Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildSuggestions(),
                ),
              ),
              new ButtonTheme.bar(
                child: new ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new RaisedButton(
                      onPressed: () {
                        Route route = MaterialPageRoute(builder: (context) => ScanPage(member.id.toString()));
                        Navigator.push(context, route);
                      },
                      child: Row(
                        children: <Widget>[
                          Text('Add more item', style: TextStyle(color: Colors.white)),
                          Icon(Icons.add, color: Colors.white),
                        ],
                      ),
                      color: Colors.green,
                    ),
                    new RaisedButton(
                      onPressed: () {
                        _validateOrder();
                      },
                      child: Row(
                        children: <Widget>[
                          Text('Validate and finish', style: TextStyle(color: Colors.white)),
                          Icon(Icons.crop_square, color: Colors.white),
                        ],
                      ),
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          )
      //     new Container(
			// 	margin: const EdgeInsets.symmetric(horizontal: 16.0),
			// 	child: new Column(
			// 		crossAxisAlignment: CrossAxisAlignment.stretch,
			// 		children: <Widget>[
      //       new Container(
      //         child: _buildSuggestions(),
      //       ),
			// 			new MaterialButton(
			// 				color: Theme.of(context).primaryColor,
			// 				child: new Text(
			// 					'Scan Order',
			// 					style: new TextStyle(
			// 						color: Colors.white
			// 					),
			// 				),
			// 				onPressed: () {
      //           Route route = MaterialPageRoute(builder: (context) => ScanPage(member.id.toString()));

      //           Navigator.push(context, route);
      //         }
			// 			),
			// 		]
			// 	),
			// )
		
          : Center(child: CircularProgressIndicator()),
    );
  }
}

