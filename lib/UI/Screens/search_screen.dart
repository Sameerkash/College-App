import 'package:flutter/material.dart';
import '../../Notifiers/search_notifier.dart';
import '../../Services/database.dart';
import '../Screens/user_profile_screen.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    final searchNotifier = Provider.of<SearchNotifier>(context);
    String query;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          controller: _textEditingController,
          style: TextStyle(color: Colors.white),
          onSubmitted: (value) {
            query = value;
            db.handleSearch(query, searchNotifier);
          },
          autofocus: true,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
              size: 25.0,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: clearSearch,
            ),
            focusColor: Colors.white,
            border: InputBorder.none,
            hintText: "Search Users",
            hintStyle: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: searchNotifier.querySuccessstatus == false
          ? Center(
              child: Text("No Such User"),
            )
          :
          //  Container(),
          ListView.builder(
              itemBuilder: (context, index) {
                return buildListTile(
                    searchNotifier.users[index].photoUrl,
                    searchNotifier.users[index].displayName,
                    searchNotifier.users[index].branch, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfile(
                        searchNotifier.users[index],
                      ),
                    ),
                  );
                });
              },
              itemCount: searchNotifier.users.length,
            ),
    );
  }

  buildListTile(
      String photoUrl, String displayName, String branch, Function onTap) {
    return Column(children: [
      ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(photoUrl),
        ),
        title: Text(
          displayName,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(branch),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
      Divider(
        height: 2.0,
        color: Colors.grey,
      ),
    ]);
  }

  clearSearch() {
    _textEditingController.clear();
  }
}
