import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import '../../Models/post.dart';
import '../../Notifiers/profile_notifier.dart';
import '../../Notifiers/timeline_notifier.dart';
import '../../Services/authentication.dart';
import '../../Services/database.dart';
import '../Screens/edit_timeline_form.dart';
import '../Widgets/feed_item.dart';
import '../Widgets/platform_alert_dialog.dart';
import '../Widgets/progress_bars.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  ScrollController _scrollController = ScrollController();

  var format = DateFormat('dd MMM yy | h:mm a');
  @override
  void initState() {
    ProfileNotifier posts =
        Provider.of<ProfileNotifier>(context, listen: false);
    final db = Provider.of<Database>(context, listen: false);
    db.getFacultyProfile(posts);
    db.getPosts(posts);

    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double cureentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - cureentScroll <= delta) {
        db.getMoreProfilePosts(posts);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<UserProvider>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  _deletePost(Post post) {
    ProfileNotifier posts =
        Provider.of<ProfileNotifier>(context, listen: false);
    TimelineNotifer timelinePosts =
        Provider.of<TimelineNotifer>(context, listen: false);
    posts.deletePost(post);
    timelinePosts.deletePost(post);
  }

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
    super.build(context);
    final devicesize = MediaQuery.of(context).size;
    ProfileNotifier posts = Provider.of<ProfileNotifier>(context);

    final db = Provider.of<Database>(context, listen: false);
    // Future<Student> student = db.getStudent();
    // Future post = db.getPosts();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Profile"),
        actions: <Widget>[
          Icon(Icons.exit_to_app),
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              _confirmSignOut(context);
            },
          ),
        ],
      ),
      body: posts.student == null
          ? Center(
              child: ColorLoader3(
                radius: 16,
                dotRadius: 6,
              ),
            )
          : RefreshIndicator(
              color: Colors.indigo,
              onRefresh: () {
                return db.getFacultyProfile(posts);
              },
              child: RefreshIndicator(
                color: Colors.purple,
                onRefresh: () {
                  return db.getPosts(posts);
                  // db.getStudentProfile(posts);
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      buildCard(devicesize,
                          photoUrl: posts.student.photoUrl,
                          name: posts.student.displayName ?? "name",
                          branch: posts.student.department, onEdit: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: buildBottomsheet,
                        );
                      }),
                      Flexible(
                        // child: RefreshIndicator(
                        //   color: Colors.indigo,
                        //   onRefresh: () {
                        //     return db.getFacultyProfile(posts);
                        //   },
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, i) {
                            if (posts.posts.length == 0) {
                              return Center(
                                child: Text("No Posts yet "),
                              );
                            }
                            bool isLiked =
                                posts.posts[i].likes[db.userId] == true;

                            return buildProfileFeedCard(
                              context,
                              onLiked: () {
                                handleLikePost(posts.posts[i]);
                              },
                              isLiked: isLiked,
                              likeCount: getLikeCount(posts.posts[i]),
                              onPressedEdit: () {
                                posts.currentProfilePost = posts.posts[i];
                                // print(posts.currentPost.title);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditTimelineForm(isUpdating: true),
                                  ),
                                );
                              },
                              onPressedDelete: () async {
                                final didRequestSignOut =
                                    await PlatformAlertDialog(
                                  title:
                                      'Are you sure you want to delete this?',
                                  content: 'This action cannot be undone',
                                  cancelActionText: 'Cancel',
                                  defaultActionText: 'Delete',
                                ).show(context);
                                if (didRequestSignOut == true) {
                                  db.deletePost(
                                    posts.posts[i],
                                  );
                                  _deletePost(posts.posts[i]);
                                }
                              },
                              photoUrl: posts.posts[i].photoUrl,
                              name: posts.posts[i].userName,
                              timestamp: posts.posts[i].updatedAt == null
                                  ? format
                                      .format(posts.posts[i].createdAt.toDate())
                                      .toString()
                                  : '✏️ ' +
                                      format
                                          .format(
                                              posts.posts[i].updatedAt.toDate())
                                          .toString(),
                              content: posts.posts[i].content,
                              title: posts.posts[i].title,
                            );
                          },
                          itemCount:
                              posts.posts.length == 0 ? 1 : posts.posts.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget buildBottomsheet(BuildContext context) {
    return Container(
      color: Color(0xff3757575),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Edit your profile",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  maxLines: 2,
                  decoration: InputDecoration(
                    icon: Icon(MaterialCommunityIcons.text),
                    hintText: "Description",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(
                      MaterialCommunityIcons.github_box,
                      size: 30,
                    ),
                    hintText: "Github Profile",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(
                      MaterialCommunityIcons.stack_overflow,
                      size: 30,
                    ),
                    hintText: "Stack Overflow Profile",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(
                      MaterialCommunityIcons.link_box,
                      size: 30,
                    ),
                    hintText: "Otehr links (Website or Email)",
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ClipOval(
                  child: Material(
                    child: Container(
                      height: 60,
                      width: 60,
                      color: Colors.black,
                      child: IconButton(
                        splashColor: Colors.indigo,
                        icon: Icon(Icons.check),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Card buildCard(Size devicesize,
      {String name, String photoUrl, String branch, Function onEdit}) {
    return Card(
      margin: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 30),
      child: Container(
        child: Padding(
          padding:
              EdgeInsets.only(top: devicesize.height * .02, left: 15, right: 5),
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
                height: devicesize.height * .027,
              ),
              Text(
                "Flutter developer| Deep learning |Game development developer| Deep Learning ",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold),
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
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                    ),
                    onPressed: onEdit,
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
