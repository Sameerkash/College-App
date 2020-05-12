import 'package:async/async.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:kssem/Utilities/size_config.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:kssem/Notifiers/notification_notifier.dart';
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

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  getUserProfile(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    return _memoizer.runOnce(() async {
      final res = await db.getUserProfilePosts(widget.user);
      return res;
    });
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
      body: RefreshIndicator(
        onRefresh: () {
          return db.getUserProfilePosts(widget.user);
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildCard(deviceSize,
                  photoUrl: widget.user.photoUrl,
                  name: widget.user.displayName,
                  branch: widget.user.branch,
                  dept: widget.user.department,
                  descripcion: widget.user.links.description,
                  githubUrl: widget.user.links.github,
                  linkedInUrl: widget.user.links.linkedIn,
                  linkUrl: widget.user.links.link),
              FutureBuilder(
                  future: getUserProfile(context),
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
                              imageUrl: _posts[index].imageUrl,
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
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("cant launch url");
    }
  }

  Card buildCard(Size devicesize,
      {String name,
      String photoUrl,
      String branch,
      String dept,
      String descripcion,
      String githubUrl,
      String linkedInUrl,
      String linkUrl}) {
    return Card(
      color: Theme.of(context).colorScheme.background,
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
                            fontWeight: FontWeight.bold, ),
                      ),
                      SizedBox(
                        height: devicesize.height * .019,
                      ),
                      branch == null
                          ? AutoSizeText(
                              dept,
                              // snapshot.data.branch,
                              // " 1KG17CS070",
                              minFontSize: 23,
                              // style: TextStyle(color: Colors.black),
                            )
                          : AutoSizeText(
                              branch,
                              // snapshot.data.branch,
                              // " 1KG17CS070",
                              minFontSize: 23,
                              // style: TextStyle(color: Colors.black),
                            ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: devicesize.height * .025,
              ),
              descripcion == null
                  ? Text(
                      "No Description",
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 5),
                    )
                  : Text(
                      descripcion,
                      // "Flutter developer| Deep learning |Game development developer| Deep Learning ",
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 5,
                          // color: Colors.grey[800],
                          fontWeight: FontWeight.bold),
                    ),
              SizedBox(
                height: devicesize.height * .020,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      _launchURL(githubUrl);
                    },
                    icon: Icon(
                      MaterialCommunityIcons.github_box,
                      size: 30,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _launchURL(linkedInUrl);
                    },
                    icon: Icon(MaterialCommunityIcons.linkedin_box, size: 30),
                  ),
                  IconButton(
                    onPressed: () {
                      _launchURL(linkUrl);
                    },
                    icon: Icon(MaterialCommunityIcons.link_box, size: 30),
                  )
                ],
              )
            ],
          ),
        ),
        height: SizeConfig.blockSizeHorizontal * 73,
      ),
      elevation: 3.0,
    );
  }
}
