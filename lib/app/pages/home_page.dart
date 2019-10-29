import 'dart:async';
import 'package:flutter_auth_flow/app/utils/auth_utils.dart';
import 'package:flutter_auth_flow/app/utils/network_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
	var _accessToken, _id, _name, _homeResponse;

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
		var id = _sharedPreferences.getInt(AuthUtils.userIdKey);
		var name = _sharedPreferences.getString(AuthUtils.nameKey);

		print(accessToken);

		_fetchHome(accessToken, client, uid, expiry);

		setState(() {
			_accessToken = accessToken;
			_id = id;
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

		setState(() {
		  _homeResponse = responseJson.toString();
		});
	}

	_logout() {
		NetworkUtils.logoutUser(_scaffoldKey.currentContext, _sharedPreferences);
	}

	@override
	Widget build(BuildContext context) {
		return new Scaffold(
			key: _scaffoldKey,
			appBar: new AppBar(
				title: new Text('Home'),
			),
			body: new Container(
				margin: const EdgeInsets.symmetric(horizontal: 16.0),
				child: new Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: <Widget>[
						new Container(
							padding: const EdgeInsets.all(8.0),
							child: new Text(
								"USER_ID: $_id \nUSER_NAME: $_name \nHOME_RESPONSE: $_homeResponse",
								style: new TextStyle(
									fontSize: 24.0,
									color: Colors.grey.shade700
								),
							),
						),
						new MaterialButton(
							color: Theme.of(context).primaryColor,
							child: new Text(
								'Logout',
								style: new TextStyle(
									color: Colors.white
								),
							),
							onPressed: _logout
						),
					]
				),
			)
		);
	}

}