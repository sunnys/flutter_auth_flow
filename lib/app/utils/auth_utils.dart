import 'package:shared_preferences/shared_preferences.dart';

class AuthUtils {

	static final String endPoint = '/api/v1/auth/sign_in';

	// Keys to store and fetch data from SharedPreferences
	static final String authTokenKey = 'auth_token';
	static final String userIdKey = 'user_id';
	static final String nameKey = 'name';
	static final String roleKey = 'role';
  static final String accessToken = 'access-token';
  static final String client = 'client';
  static final String expiry = 'expiry';
  static final String expires = 'expires';
  static final String tokenType = 'token-type';
  static final String uid = 'uid';

	static String getToken(SharedPreferences prefs) {
		return prefs.getString(accessToken);
	}

	static String getClient(SharedPreferences prefs) {
		return prefs.getString(client);
	}

	static String getUid(SharedPreferences prefs) {
		return prefs.getString(uid);
	}

	static String getExpiry(SharedPreferences prefs) {
		return prefs.getString(expiry);
	}

	static String getExpires(SharedPreferences prefs) {
		return prefs.getString(expires);
	}

	static String getTokenType(SharedPreferences prefs) {
		return prefs.getString(tokenType);
	}

	static insertDetails(SharedPreferences prefs, var headers, var response) {
		prefs.setString(accessToken, headers['access-token']);
		prefs.setString(client, headers['client']);
		prefs.setString(uid, headers['uid']);
		prefs.setString(expiry, headers['expiry']);
		prefs.setString(expires, headers['expires']);
		prefs.setString(tokenType, headers['token-type']);

    var user = response['data'];
		prefs.setInt(userIdKey, user['id']);
		prefs.setString(nameKey, user['f_name']);
	}
	
}