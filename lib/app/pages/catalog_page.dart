import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_auth_flow/app/utils/auth_utils.dart';
import 'package:flutter_auth_flow/app/utils/network_utils.dart';
import 'package:flutter_auth_flow/app/models/member.dart';
import 'package:flutter_auth_flow/app/pages/order_detail_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
/// The screen which displays the full catalog of members in library.
class CatalogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catalog'),
      ),
      body: Center(
        child: CatalogList(),
      ),
    );
  }
}

/// The list of members and its search bar.
class CatalogList extends StatefulWidget {
  @override
  _CatalogListState createState() => _CatalogListState();
}

class _CatalogListState extends State<CatalogList> {
  /// All members in the catalog.
  List<Member> members;

  /// Members currently being displayed in the list.
  List<Member> displayedMembers;

  /// The controller to keep track of search field content and changes.
  final TextEditingController searchController = TextEditingController();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

	SharedPreferences _sharedPreferences;
  var _accessToken, _client, _uid, _expiry;
  /// Kicks off API fetch on creation.
  _CatalogListState() {
    _fetchMemberList();
    _fetchAuthDetails();
    searchController.addListener(_search);
  }

  _fetchAuthDetails() async {
    _sharedPreferences = await _prefs;
		String accessToken = AuthUtils.getToken(_sharedPreferences);
		String client = AuthUtils.getClient(_sharedPreferences);
		String uid = AuthUtils.getUid(_sharedPreferences);
		String expiry = AuthUtils.getExpiry(_sharedPreferences);

		// _fetchItem(accessToken, client, uid, expiry, widget.itemId);
    _fetchMemberList();
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

  /// Fetches the list of members and updates state.
  void _fetchMemberList() async {
    var responseJson = await NetworkUtils.fetch(_accessToken, _client, _uid, _expiry, '/api/v1/members');
    Iterable newMembersRaw = responseJson;
    List<Member> newMembers = newMembersRaw.map((memberData) => Member.fromJson(memberData)).toList();
    setState(() {
      members = newMembers;
      displayedMembers = members;
    });
  }

  /// Performs a case insensitive search.
  void _search() {
    if (searchController.text == '') {
      setState(() {
        displayedMembers = members;
      });
    } else {
      List<Member> filteredMembers = members
          .where((member) => member.name
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
      setState(() {
        displayedMembers = filteredMembers;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return displayedMembers != null
        ? Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: TextField(
                  decoration: InputDecoration(hintText: 'Search for titles...'),
                  controller: searchController,
                ),
              ),
              new Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) => Card(
                          elevation: 2.0,
                          child: ListTile(
                              title: Text(
                                displayedMembers[index].name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                displayedMembers[index].orders.join(' | ')
                              ),
                              // subtitle: displayedMembers[index].orders.map((bo) {
                              //   return Text(
                              //     displayedMembers[index].orders.join(' | ')
                              //   );
                              // }).toList(),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return OrderDetailPage(displayedMembers[index].id.toString());
                                }));
                              }),
                        ),
                    itemCount: displayedMembers.length,
                  ),
                ),
              ),
            ],
          )
        : Center(child: CircularProgressIndicator());
  }
}