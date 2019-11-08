import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'auth_utils.dart';

class NetworkUtils {
	static final String host = developmentHost;
	static final String productionHost = '';
	static final String developmentHost = 'http://192.168.43.141:3000';

	static dynamic authenticateUser(String email, String password) async {
		var uri = host + AuthUtils.endPoint;
    print(uri);
		try {
			final response = await http.post(
				uri,
				body: {
					'email': email,
					'password': password
				}
			);
      // print(response.headers);
			// final responseJson = json.decode(response.body);
			return response;

		} catch (exception) {
			print(exception);
			if(exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}

	static logoutUser(BuildContext context, SharedPreferences prefs) {
    prefs.setString(AuthUtils.accessToken, null);
		prefs.setString(AuthUtils.client, null);
		prefs.setString(AuthUtils.uid, null);
		prefs.setString(AuthUtils.expiry, null);
		prefs.setString(AuthUtils.expires, null);
		prefs.setString(AuthUtils.tokenType, null);
		prefs.setString(AuthUtils.authTokenKey, null);
		prefs.setInt(AuthUtils.userIdKey, null);
		prefs.setString(AuthUtils.nameKey, null);
		Navigator.of(context).pushReplacementNamed('/');
	}

	static showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
		scaffoldKey.currentState.showSnackBar(
			new SnackBar(
				content: new Text(message ?? 'You are offline'),
			)
		);
	}

	static fetch(var accessToken, var client, var uid, var expiry, var endPoint) async {
		var uri = host + endPoint;
		try {
			final response = await http.get(
				uri,
				headers: {
          'access-token': accessToken,
          'client': client,
          'uid': uid,
          'expiry': expiry,
          'expires': 'Fri, 01 Jan 1970 00:00:00 GMT',
          'Content-Type': 'application/json',
          'token-type': 'bearer'
				},
			);

			final responseJson = json.decode(response.body);
			return responseJson;

		} catch (exception) {
			print(exception);
			if(exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}

  static post(var accessToken, var client, var uid, var expiry, var endPoint, var body) async {
		var uri = host + endPoint;
		try {
			final response = await http.post(
				uri,
				headers: {
          'access-token': accessToken,
          'client': client,
          'uid': uid,
          'expiry': expiry,
          'expires': 'Fri, 01 Jan 1970 00:00:00 GMT',
          'Content-Type': 'application/json',
          'token-type': 'bearer'
				},
        body: json.encode(body)
			);

			final responseJson = json.decode(response.body);
			return responseJson;

		} catch (exception) {
			print(exception);
			if(exception.toString().contains('SocketException')) {
				return 'NetworkError';
			} else {
				return null;
			}
		}
	}
}