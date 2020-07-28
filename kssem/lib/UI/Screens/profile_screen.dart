import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:kssem/Models/faculty.dart';
import 'package:kssem/Models/post.dart';
import 'package:kssem/Notifiers/profile_notifier.dart';
import 'package:kssem/Notifiers/timeline_notifier.dart';
import 'package:kssem/Services/authentication.dart';
import 'package:kssem/Services/database.dart';
import 'package:kssem/UI/Screens/edit_timeline_form.dart';
import 'package:kssem/UI/Widgets/feed_item.dart';
import 'package:kssem/UI/Widgets/platform_alert_dialog.dart';
// import 'package:kssem/UI/Widgets/progress_bars.dart';
import 'package:kssem/UI/Widgets/shimmer_widgets.dart';
import 'package:kssem/Utilities/size_config.dart';
// import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';.
import 'package:lazy_load_refresh_indicator/lazy_load_refresh_indicator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  // ScrollController _scrollController = ScrollController();

  final snackBar = SnackBar(
      duration: Duration(seconds: 4),
      content: Text(
        "Profile Updated Sucessfully!",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.red);

  BuildContext scaffoldContext;

  var format = DateFormat('dd MMM yy | h:mm a');
  @override
  void initState() {
    ProfileNotifier posts =
        Provider.of<ProfileNotifier>(context, listen: false);
    final db = Provider.of<Database>(context, listen: false);
    db.getStudentProfile(posts);
    db.getPosts(posts);

    // _scrollController.addListener(() {
    //   double maxScroll = _scrollController.position.maxScrollExtent;
    //   double cureentScroll = _scrollController.position.pixels;
    //   double delta = MediaQuery.of(context).size.height * 0.20;
    //   if (maxScroll - cureentScroll <= delta) {
    //     db.getMoreProfilePosts(posts);
    //   }
    // });
    super.initState();
  }

  @override
  void dispose() {
    // _scrollController.dispose();
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
          backgroundColor: Theme.of(context).appBarTheme.color,
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
        body: Builder(
          builder: (BuildContext context) {
            scaffoldContext = context;
            return posts.student == null
                ? ShimmerProfile()
                // : LazyLoadScrollView(
                //     onEndOfPage: () {
                //       db.getMoreProfilePosts(posts);
                //     },
                //     child: RefreshIndicator(
                //       color: Colors.indigo,
                //       onRefresh: () {
                //         return db.getStudentProfile(posts);
                //       },
                //       child: RefreshIndicator(
                //         color: Colors.purple,
                //         onRefresh: () {
                //           return db.getPosts(posts);
                //           // db.getStudentProfile(posts);
                //         },
                : LazyLoadRefreshIndicator(
                    // isLoading: lazyload,
                    onRefresh: () {
                      db.getPosts(posts);
                      return db.getStudentProfile(posts);
                    },
                    onEndOfPage: () => db.getMoreProfilePosts(posts),
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      // controller: _scrollController,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          buildCard(devicesize,
                              description: posts.student.links.description,
                              githubUrl: posts.student.links.github,
                              linkedInUrl: posts.student.links.linkedIn,
                              linkUrl: posts.student.links.link,
                              photoUrl: posts.student.photoUrl,
                              name: posts.student.displayName ?? "name",
                              branch: posts.student.branch, onEdit: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: buildBottomsheet,
                            );
                          }),
                          (posts.posts.isEmpty)
                              ? Container(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "There's not much to show here",
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.blockSizeVertical *
                                                    2.5),
                                      ),
                                      SizedBox(
                                        height:
                                            SizeConfig.blockSizeVertical * 3,
                                      ),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxWidth:
                                                SizeConfig.safeBlockHorizontal *
                                                    70),
                                        child: Image.asset('assets/cat.gif',
                                            fit: BoxFit.contain),
                                      ),
                                      SizedBox(
                                        height:
                                            SizeConfig.blockSizeVertical * 8,
                                      ),
                                      Text(
                                        "Try writing your first post!",
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.blockSizeVertical *
                                                    2),
                                      ),
                                    ],
                                  ),
                                  // decoration: BoxDecoration(
                                  // image: DecorationImage(
                                  //   fit: BoxFit.contain,
                                  //   alignment: Alignment.center,
                                  //   image: AssetImage('assets/cat.gif'),
                                  // ),
                                  // ),
                                )
                              : Flexible(
                                  // fit: FlexFit.loose,

                                  child: ListView.separated(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            Divider(
                                      height: 15,
                                      thickness: 15,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                    itemBuilder: (context, i) {
                                      // if (posts.posts.isEmpty) {
                                      //   return ProfileShimmer();
                                      // }
                                      bool isLiked =
                                          posts.posts[i].likes[db.userId] ==
                                              true;

                                      return buildProfileFeedCard(context,
                                          onLiked: () {
                                            handleLikePost(posts.posts[i]);
                                          },
                                          isLiked: isLiked,
                                          likeCount:
                                              getLikeCount(posts.posts[i]),
                                          onPressedEdit: () {
                                            posts.currentProfilePost =
                                                posts.posts[i];
                                            // print(posts.currentPost.title);
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditTimelineForm(
                                                  isUpdating: true,
                                                  scaffoldContext:
                                                      scaffoldContext,
                                                ),
                                              ),
                                            );
                                          },
                                          onPressedDelete: () async {
                                            final didRequestSignOut =
                                                await PlatformAlertDialog(
                                              title:
                                                  'Are you sure you want to delete this?',
                                              content:
                                                  'This action cannot be undone',
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
                                          timestamp:
                                              posts.posts[i].updatedAt == null
                                                  ? format
                                                      .format(posts
                                                          .posts[i].createdAt
                                                          .toDate())
                                                      .toString()
                                                  : '✏️ ' +
                                                      format
                                                          .format(posts.posts[i]
                                                              .updatedAt
                                                              .toDate())
                                                          .toString(),
                                          content: posts.posts[i].content,
                                          title: posts.posts[i].title);
                                    },
                                    itemCount: posts.posts.length == 0
                                        ? 1
                                        : posts.posts.length,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    // ),
                    // ),
                  );
          },
        ));
    // });
    //       },
    //     ),
    //   );
  }

  final _formKey = GlobalKey<FormState>();

  String _description;
  String _github;
  String _stackOverflow;
  String _linkedIn;
  String _link;
  String _username;
  Widget buildBottomsheet(BuildContext context) {
    ProfileNotifier student =
        Provider.of<ProfileNotifier>(context, listen: false);
    return Container(
      // color: Color(0xff3757575),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: EdgeInsets.only(top: 12, left: 25, right: 25, bottom: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Edit your profile",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                SizedBox(
                  height: 7,
                ),
                TextFormField(
                  initialValue: student.student.displayName,
                  decoration: InputDecoration(
                    icon: Icon(MaterialCommunityIcons.face_profile),
                    hintText: "User Name",
                  ),
                  validator: (val) {
                    if (val.isEmpty) {
                      return "User Name cannot be empty";
                    } else if (val.length > 20) {
                      return "Cannot be more than 20 characters";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _username = val;
                  },
                ),
                TextFormField(
                  maxLines: 2,
                  decoration: InputDecoration(
                    icon: Icon(MaterialCommunityIcons.text),
                    hintText: "Description",
                  ),

                  // maxLength: 10,
                  initialValue: student.student.links.description,
                  onSaved: (val) {
                    _description = val;
                  },
                  validator: (val) {
                    print(val.length);
                    if (val.length > 90) {
                      return "Should be < 90 characters";
                    } else if (val.contains("fuck") ||
                        val.contains("sex") ||
                        val.contains("porn") ||
                        val.contains("FUCK") ||
                        val.contains("SEX") ||
                        val.contains("PORN") ||
                        val.contains("asshole")) {
                      return "Remove inappropraite langauge";
                    } else
                      return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(
                      MaterialCommunityIcons.github_box,
                      size: 25,
                    ),
                    hintText: "Github Profile",
                  ),
                  initialValue: student.student.links.github,
                  onSaved: (val) {
                    _github = val;
                  },
                  validator: (val) {
                    if (val.contains("https://") || val.isEmpty) {
                      return null;
                    }
                    return "Enter a valid URL";
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(
                      MaterialCommunityIcons.linkedin,
                      size: 25,
                    ),
                    hintText: "LinkedIn Profile",
                  ),
                  initialValue: student.student.links.linkedIn,
                  onSaved: (val) {
                    _linkedIn = val;
                  },
                  validator: (val) {
                    if (val.contains("https://") || val.isEmpty) {
                      return null;
                    }
                    return "Enter a valid URL";
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(
                      MaterialCommunityIcons.link_box,
                      size: 25,
                    ),
                    hintText: "Other links (Website or Email)",
                  ),
                  initialValue: student.student.links.link,
                  onSaved: (val) {
                    _link = val;
                  },
                  validator: (val) {
                    if (val.contains(".com") || val.isEmpty) {
                      return null;
                    }
                    return "Enter a valid URL";
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ClipOval(
                  child: Material(
                    child: Container(
                      height: 50,
                      width: 50,
                      color: Theme.of(context).iconTheme.color,
                      child: IconButton(
                        splashColor: Colors.indigo,
                        icon: Icon(Icons.check),
                        color: Colors.white,
                        onPressed: () {
                          _submitFome(context);
                        },
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

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _submitFome(BuildContext context) async {
    final db = Provider.of<Database>(context, listen: false);
    ProfileNotifier student =
        Provider.of<ProfileNotifier>(context, listen: false);

    if (_validateAndSaveForm()) {
      try {
        print(_description);
        ProfileLinks links = ProfileLinks(
          description: _description,
          github: _github,
          stackOverflow: _stackOverflow,
          linkedIn: _linkedIn,
          link: _link,
        );
        await db.updateProfileLinks(student.student, links, _username);
        await db.getStudentProfile(student);
        Scaffold.of(scaffoldContext).showSnackBar(snackBar);
        Navigator.pop(context);
      } catch (e) {
        throw '$e';
      }
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("cant launch");
    }
  }

  Card buildCard(Size devicesize,
      {String name,
      String photoUrl,
      String branch,
      Function onEdit,
      String description,
      String githubUrl,
      String linkedInUrl,
      String linkUrl}) {
    return Card(
      color: Theme.of(context).colorScheme.background,
      margin: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 30),
      child: Container(
        child: Padding(
          padding:
              EdgeInsets.only(top: devicesize.height * .02, left: 15, right: 5),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CachedNetworkImage(
                      imageUrl: photoUrl,
                      imageBuilder: (_, imageprovider) {
                        return CircleAvatar(
                          radius: SizeConfig.blockSizeHorizontal * 12,
                          backgroundImage: imageprovider,
                          backgroundColor: Colors.blue,
                        );
                      }),
                  SizedBox(
                    width: devicesize.height * .03,
                  ),
                  Column(
                    children: <Widget>[
                      AutoSizeText(
                        // snapshot.data.name,
                        name,
                        // "Tanzeela Fathima",
                        // "Sameer Kashayp",
                        maxFontSize: 23,
                        minFontSize: 18,
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: devicesize.height * .019,
                      ),
                      AutoSizeText(
                        branch,
                        // snapshot.data.branch,
                        // " 1KG17CS070",
                        minFontSize: 22,
                        // style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: devicesize.height * .027,
              ),
              description == null
                  ? Text(
                      "Update your Profile",
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 5),
                    )
                  : Text(
                      description,
                      // "Flutter developer| Deep learning |Game development developer| Deep Learning ",
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeHorizontal * 5,
                          // color: Colors.grey[800],
                          fontWeight: FontWeight.bold),
                    ),
              SizedBox(
                height: devicesize.height * .025,
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
                      size: 28,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _launchURL(linkedInUrl);
                    },
                    icon: Icon(MaterialCommunityIcons.linkedin_box, size: 28),
                  ),
                  IconButton(
                    onPressed: () {
                      _launchURL(linkUrl);
                    },
                    icon: Icon(MaterialCommunityIcons.link_box, size: 28),
                  ),
                  // SizedBox(
                  //   width: 25,
                  // ),
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
        height: SizeConfig.blockSizeHorizontal * 73,
      ),
      elevation: 3.0,
    );
  }
}
