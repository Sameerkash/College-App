import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import '../../Models/post.dart';
import '../../Models/users.dart';
import '../../Services/database.dart';
import '../Widgets/feed_item.dart';
import '../Widgets/progress_bars.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  final Users user;
  UserProfile(this.user);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  var format = DateFormat('dd MMM yy | h:mm a');

  int likeCount = 0;
  // bool isLikedGlobal = false;

  handleLikePost(Post post) {
    final db = Provider.of<Database>(context, listen: false);
    // print(post.likes);

    bool isLiked = post.likes[db.userId] == true;

    if (isLiked) {
      db.unLikePost(post);
      setState(() {
        likeCount -= 1;
        isLiked = false;
        post.likes[db.userId] = false;
      });
    } else if (!isLiked) {
      db.likePost(post);

      setState(() {
        likeCount += 1;
        isLiked = true;
        post.likes[db.userId] = true;
      });
    }
  }

  getLikeCount(Post post) {
    if (likeCount == null) {
      return 0;
    }
    int count = 0;
    post.likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildCard(deviceSize,
                photoUrl: widget.user.photoUrl,
                name: widget.user.displayName,
                branch: widget.user.branch),
            FutureBuilder(
                future: db.getUserProfilePosts(widget.user),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ColorLoader3(
                      radius: 16,
                      dotRadius: 6,
                    );
                  }
                  List<Post> _posts = [];
                  snapshot.data.documents.forEach((doc) {
                    Post post = Post.fromMap(doc.data);
                    _posts.add(post);
                  });

                  if (_posts.isEmpty) {
                    return Center(
                      child: Text("No Posts to Show"),
                    );
                  }

                  return Flexible(
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        bool isLiked = _posts[index].likes[db.userId] == true;

                        return buildFeedCard(context, onLiked: () {
                          handleLikePost(_posts[index]);
                        },
                            isLiked: isLiked,
                            likeCount: getLikeCount(_posts[index]),
                            photoUrl: _posts[index].photoUrl,
                            name: _posts[index].userName,
                            timestamp: _posts[index].updatedAt == null
                                ? format
                                    .format(_posts[index].createdAt.toDate())
                                    .toString()
                                : '✏️ ' +
                                    format
                                        .format(
                                            _posts[index].updatedAt.toDate())
                                        .toString(),
                            content: _posts[index].content,
                            title: _posts[index].title);
                      },
                      itemCount: _posts.length,
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  Card buildCard(Size devicesize,
      {String name, String photoUrl, String branch}) {
    return Card(
      margin: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 30),
      child: Container(
        child: Padding(
          padding:
              EdgeInsets.only(top: devicesize.height * .04, left: 8, right: 8),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(photoUrl),
                    backgroundColor: Colors.blue,
                  ),
                  SizedBox(
                    width: devicesize.height * .03,
                  ),
                  Column(
                    children: <Widget>[
                      AutoSizeText(
                        // snapshot.data.name,
                        name,
                        // "Sameer Kashayp",
                        maxFontSize: 23,
                        minFontSize: 20,
                        maxLines: 2,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      SizedBox(
                        height: devicesize.height * .019,
                      ),
                      AutoSizeText(
                        branch,
                        // snapshot.data.branch,
                        // " 1KG17CS070",
                        minFontSize: 23,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: devicesize.height * .025,
              ),
              Text(
                " flutter developer, deep learning ,game development",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(
                height: devicesize.height * .025,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      MaterialCommunityIcons.github_box,
                      size: 30,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(MaterialCommunityIcons.linkedin_box, size: 30),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(MaterialCommunityIcons.stack_overflow, size: 30),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(MaterialCommunityIcons.link_box, size: 30),
                  )
                ],
              )
            ],
          ),
        ),
        height: 300,
      ),
      elevation: 3.0,
    );
  }
}
