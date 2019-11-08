import 'dart:async';
import 'package:flutter_auth_flow/app/utils/auth_utils.dart';
import 'package:flutter_auth_flow/app/utils/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_auth_flow/app/pages/scan_page.dart';
import 'package:flutter_auth_flow/app/pages/catalog_page.dart';
import 'package:flutter_auth_flow/app/components/header.dart';
import 'package:flutter_auth_flow/app/components/row_widget.dart';
import 'package:flutter_auth_flow/app/components/top_button_bar.dart';

class HomePage extends StatefulWidget {
	static final String routeName = 'home';

	@override
	State<StatefulWidget> createState() {
		return new _HomePageState();
	}

}

class _HomePageState extends State<HomePage> {
	GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
	Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

	SharedPreferences _sharedPreferences;
	var _accessToken, _name;

	@override
	void initState() {
		super.initState();
		_fetchSessionAndNavigate();
	}

	_fetchSessionAndNavigate() async {
		_sharedPreferences = await _prefs;
		String accessToken = AuthUtils.getToken(_sharedPreferences);
		String client = AuthUtils.getClient(_sharedPreferences);
		String uid = AuthUtils.getUid(_sharedPreferences);
		String expiry = AuthUtils.getExpiry(_sharedPreferences);
		var name = _sharedPreferences.getString(AuthUtils.nameKey);

		print(accessToken);

		_fetchHome(accessToken, client, uid, expiry);

		setState(() {
			_accessToken = accessToken;
			_name = name;
		});

		if(_accessToken == null) {
			_logout();
		}
	}

	_fetchHome(String accessToken, String client, String uid, String expiry) async {
		var responseJson = await NetworkUtils.fetch(accessToken, client, uid, expiry, '/api/v1/home');

		if(responseJson == null) {

			NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');

		} else if(responseJson == 'NetworkError') {

			NetworkUtils.showSnackBar(_scaffoldKey, null);

		} else if(responseJson['errors'] != null) {

			_logout();

		}

		// setState(() {
		//   _homeResponse = responseJson.toString();
		// });
	}

	_logout() {
		NetworkUtils.logoutUser(_scaffoldKey.currentContext, _sharedPreferences);
	}

  _navigateToScan() {
    Navigator.push(_scaffoldKey.currentContext, new MaterialPageRoute(builder: (context) =>new ScanPage(null)));
  }

  _navigateToCatalog() {
    Navigator.push(_scaffoldKey.currentContext, new MaterialPageRoute(builder: (context) =>new CatalogPage()));
  }

	@override
	Widget build(BuildContext context) {
		return new Scaffold(
			key: _scaffoldKey,
			appBar: new AppBar(
				title: new Text('Home'),
			),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints.expand(height: 400.0),
                    child: HeaderWidget(name: this._name),
                  ),
                  RowWidget(
                    title1: "Orders",
                    subTitle1: "Old",
                    title2: "Scan",
                    subTitle2: "New Order",
                    onPressed1: _navigateToCatalog,
                    onPressed2: _navigateToScan,
                    height: 100.0,
                  ),
                  // StatsWidget(stats: vm.stats, height: _kStatGridsHeight),
                  // TopRowWidget(stats: vm.stats, height: _kRowGridsHeight),
                  // MidRowWidget(stats: vm.stats, height: _kRowGridsHeight),
                  // BottomRowWidget(
                  //   stats: vm.stats,
                  //   account: vm.account,
                  //   height: _kRowGridsHeight,
                  // ),
                  // SizedBox(height: _kBottomBarHeight),
                ],
              ),
            ),
          ),
          TopButtonBar(
            onLogout: _logout,
          ),
        ],
      ),
    );
	}
}

