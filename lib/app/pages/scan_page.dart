import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter_auth_flow/app/pages/detail_page.dart';

class ScanPage extends StatefulWidget {
  // static final String routeName = 'scan';
  final String memberId;
  ScanPage(this.memberId);
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String barcode = '';
  bool getItemDetail = false;
  String memberId;
  Uint8List bytes = Uint8List(200);
  final TextEditingController itemController = TextEditingController();

  @override
  initState() {
    super.initState();
    print("0000000000000000000000000000000000000000000");
    print(widget.memberId);
    print("0000000000000000000000000000000000000000000");
    setState(() => memberId = widget.memberId);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text('Scan item'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 200,
                height: 200,
                child: Image.memory(bytes),
              ),
              Text('Scanned item is:  $barcode'),
              // Text(
							// 	"ITEM_RESPONSE: $_itemResponse",
							// 	style: new TextStyle(
							// 		fontSize: 24.0,
							// 		color: Colors.grey.shade700
							// 	)
              // ),
              TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter Item Code',
                ),
                controller: itemController
              ),
              
              RaisedButton(onPressed: _scan, child: Text("Scan")),
              RaisedButton(onPressed: (barcode != '' && !getItemDetail ? _fetchScannedItem : null), child: Text("Get Item detail")),
              // barcode != '' ?  : '',
              // RaisedButton(onPressed: _scanPhoto, child: Text("Scan Photo")),
              // RaisedButton(onPressed: _generateBarCode, child: Text("Generate Barcode")),
            ],
          ),
        ),
    );
  }

  Future _scan() async {
    String barcode = await scanner.scan();
    setState(() {
      this.barcode = barcode;
      this.itemController.text = barcode.split('|')[0];
    });

  }

  // Future _scanPhoto() async {
  //   String barcode = await scanner.scanPhoto();
  //   // _fetchScannedItem(barcode);
  //   setState(() => this.barcode = barcode);
  // }

  _fetchScannedItem() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          var text = itemController.text;
          return DetailPage(text, memberId);
        }
      )
    );
    // _sharedPreferences = await _prefs;
		// String accessToken = AuthUtils.getToken(_sharedPreferences);
		// String client = AuthUtils.getClient(_sharedPreferences);
		// String uid = AuthUtils.getUid(_sharedPreferences);
		// String expiry = AuthUtils.getExpiry(_sharedPreferences);
		// // var id = _sharedPreferences.getInt(AuthUtils.userIdKey);
		// // var name = _sharedPreferences.getString(AuthUtils.nameKey);

		// print(accessToken);

		// _fetchItem(accessToken, client, uid, expiry, barcode);

		// setState(() {
		// 	_accessToken = accessToken;
		// });

		// if(_accessToken == null) {
		// 	print('_logout()');
		// }
  }

  // _fetchItem(String accessToken, String client, String uid, String expiry, String itemId) async {
	// 	var responseJson = await NetworkUtils.fetch(accessToken, client, uid, expiry, '/api/v1/items/'+ itemId);

	// 	if(responseJson == null) {

	// 		NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');

	// 	} else if(responseJson == 'NetworkError') {

	// 		NetworkUtils.showSnackBar(_scaffoldKey, null);

	// 	} else if(responseJson['errors'] != null) {

	// 		// _logout();
  //     print(responseJson['errors']);

	// 	}
	// 	setState(() {
	// 	  _itemResponse = responseJson.toString();
  //     getItemDetail = true;
	// 	});
	// }

  // Future _generateBarCode() async {
  //   Uint8List result = await scanner.generateBarCode('https://github.com/leyan95/qrcode_scanner');
  //   this.setState(() => this.bytes = result);
  // }
}