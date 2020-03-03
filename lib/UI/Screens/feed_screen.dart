import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:kssem/Notifiers/profile_notifier.dart';
import '../../Models/post.dart';
import '../../Notifiers/search_notifier.dart';
import '../../Notifiers/timeline_notifier.dart';
import '../../Services/database.dart';
import '../Screens/search_screen.dart';
import '../Screens/timeline_form.dart';
import '../Widgets/app_drawer.dart';
import '../Widgets/feed_item.dart';
import '../Widgets/progress_bars.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with AutomaticKeepAliveClientMixin<FeedScreen> {
  get wantKeepAlive => true;

  ScrollController _scrollController = ScrollController();

 

  BuildContext scaffoldContext;

  @override
  void initState() {
    TimelineNotifer timelinePosts =
        Provider.of<TimelineNotifer>(context, listen: false);
    ProfileNotifier profile =
        Provider.of<ProfileNotifier>(context, listen: false);
    final db = Provider.of<Database>(context, listen: false);
    db.getTimeline(timelinePosts);
    db.getFacultyProfile(profile);

    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double cureentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - cureentScroll <= delta) {
        db.getMoreTimeline(timelinePosts);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

    // });
  }
  // bool isLiked ;

  @override
  Widget build(BuildContext context) {
    TimelineNotifer timelinePosts = Provider.of<TimelineNotifer>(context);
    SearchNotifier searchNotifier =
        Provider.of<SearchNotifier>(context, listen: false);

    final db = Provider.of<Database>(context, listen: false);
    var format = DateFormat('dd MMM yy | h:mm a');
    // var _widgetIndex = 0;
    super.build(context);
    return
        //  IndexedStack(
        //   index: _widgetIndex,
        //   children: <Widget>[
        Scaffold(
      appBar: AppBar(
        title: Text("News Feed"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                searchNotifier.usersList = [];
                searchNotifier.querySuccess = true;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                  ),
                );
              },
            ),
          )
        ],
        backgroundColor: Colors.black,
      ),
      drawer: AppDrawer(db.displayName),
      body: Builder(
        builder: (BuildContext context) {
          scaffoldContext = context;
          return timelinePosts.timelinePosts.isEmpty
              ? Center(
                  child: ColorLoader3(
                    radius: 16,
                    dotRadius: 6,
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () {
                    return db.getTimeline(timelinePosts);
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: timelinePosts.timelinePosts.length,
                    itemBuilder: (BuildContext context, int index) {
                      bool isLiked =
                          timelinePosts.timelinePosts[index].likes[db.userId] ==
                              true;

                      return buildFeedCard(
                        context,
                        imageUrl: timelinePosts.timelinePosts[index].imageUrl,
                        isLiked: isLiked,
                        likeCount:
                            getLikeCount(timelinePosts.timelinePosts[index]),
                        onLiked: () {
                          handleLikePost(timelinePosts.timelinePosts[index]);
                        },
                        photoUrl: timelinePosts.timelinePosts[index].photoUrl,
                        name: timelinePosts.timelinePosts[index].userName,
                        content: timelinePosts.timelinePosts[index].content,
                        title: timelinePosts.timelinePosts[index].title,
                        timestamp:
                            timelinePosts.timelinePosts[index].updatedAt == null
                                ? '  ' +
                                    format
                                        .format(timelinePosts
                                            .timelinePosts[index].createdAt
                                            .toDate())
                                        .toString()
                                : '✏️ ' +
                                    format
                                        .format(timelinePosts
                                            .timelinePosts[index].updatedAt
                                            .toDate())
                                        .toString(),
                      );
                    },
                  ),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
          heroTag: 'timelinePost',
          child: Icon(
            Octicons.pencil,
            color: Colors.white,
          ),
          backgroundColor: Colors.black,
          hoverColor: Colors.purple,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TimelineForm(
                  isUpdating: false,
                  isCollegeNotification: false,
                  isDepartmentnotification: false,
                  scaffoldContext: scaffoldContext,
                ),
              ),
            );
          }
          // () => setState(() => _widgetIndex = 1),
          ),
    );
    // ],
  }
}
