import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:kssem/Models/post.dart';
import 'package:kssem/Notifiers/profile_notifier.dart';
import 'package:kssem/Notifiers/search_notifier.dart';
import 'package:kssem/Notifiers/timeline_notifier.dart';
import 'package:kssem/Services/database.dart';
import 'package:kssem/UI/Screens/discover_screens/departments.dart';
import 'package:kssem/UI/Screens/home_screen.dart';
import 'package:kssem/UI/Screens/search_screen.dart';
import 'package:kssem/UI/Screens/timeline_form.dart';
import 'package:kssem/UI/Widgets/app_drawer.dart';
import 'package:kssem/UI/Widgets/feed_item.dart';
import 'package:kssem/UI/Widgets/progress_bars.dart';
import 'package:kssem/UI/Widgets/shimmer_widgets.dart';
import 'package:lazy_load_refresh_indicator/lazy_load_refresh_indicator.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
// import 'package:flutter/animation.dart';
import 'package:animations/animations.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with AutomaticKeepAliveClientMixin<FeedScreen> {
  get wantKeepAlive => true;

  // ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    TimelineNotifer timelinePosts =
        Provider.of<TimelineNotifer>(context, listen: false);
    final db = Provider.of<Database>(context, listen: false);
    ProfileNotifier profile =
        Provider.of<ProfileNotifier>(context, listen: false);

    db.getTimeline(timelinePosts);
    // db.getTimelineFixPosts(timelinePosts);
    db.getStudentProfile(profile);

    super.initState();
  }

  @override
  void dispose() {
    // _scrollController.dispose();
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

  bool lazyload = false;
  lazyloadposts(TimelineNotifer timelinePosts, BuildContext context) async {
    final db = Provider.of<Database>(context, listen: false);
    setState(() {
      lazyload = true;
    });
    await db.getMoreTimeline(timelinePosts);
    setState(() {
      lazyload = false;
    });
  }

  bool isLoading = false;

  BuildContext scaffoldContext;
  @override
  Widget build(BuildContext context) {
    TimelineNotifer timelinePosts = Provider.of<TimelineNotifer>(context);
    SearchNotifier searchNotifier =
        Provider.of<SearchNotifier>(context, listen: false);
    ProfileNotifier profile =
        Provider.of<ProfileNotifier>(context, listen: false);
    final db = Provider.of<Database>(context, listen: false);
    var format = DateFormat('dd MMM yy | h:mm a');
    // var _widgetIndex = 0;
    super.build(context);
    return
        //  IndexedStack(
        //   index: _widgetIndex,
        //   children: <Widget>[
        Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("News Feed"),
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
        backgroundColor: Theme.of(context).appBarTheme.color,
      ),
      drawer: profile.student == null
          ? TimlineShimmer()
          : AppDrawer(profile.student.displayName),
      body: Builder(
        builder: (BuildContext context) {
          scaffoldContext = context;

          return timelinePosts.timelinePosts.isEmpty
              ? TimlineShimmer()
              :
              // LazyLoadScrollView(
              //     // isLoading: lazyload,
              //     onEndOfPage: () {
              //       db.getMoreTimeline(timelinePosts);
              //       // lazyloadposts(timelinePosts, context);
              //     },
              //     child: RefreshIndicator(
              //       onRefresh: () {
              //         return db.getTimeline(timelinePosts);
              //         // db.getTimelineFixPosts(timelinePosts);
              //       },
              LazyLoadRefreshIndicator(
                isLoading: lazyload,
                  onEndOfPage: () => lazyloadposts(timelinePosts, context),
                  //  db.getMoreTimeline(timelinePosts),
                  onRefresh: ()=> db.getTimeline(timelinePosts),
                  child: ListView.separated(
                    physics: AlwaysScrollableScrollPhysics(),
                    // controller: _scrollController,
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
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                            height: 15,
                            thickness: 15,
                            color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                  // ),
                  // ),
                );
        },
      ),
      floatingActionButton: OpenContainer(
        closedShape: CircleBorder(),
        transitionDuration: const Duration(milliseconds: 400),
        closedBuilder: (context, action) {
          return FloatingActionButton(
            heroTag: 'feed',
            child: Icon(
              Octicons.pencil,
              color: Colors.white,
            ),
            backgroundColor: Theme.of(context).iconTheme.color,
            hoverColor: Colors.purple,
            onPressed: action,
          );
        },
        openBuilder: (context, action) {
          return TimelineForm(
            isUpdating: false,
            scaffoldContext: scaffoldContext,
          );
        },
      ),
      // OpenContainer(

      //   openBuilder: (context, action) {
      //     return TimelineForm(
      //       isUpdating: false,
      //       scaffoldContext: scaffoldContext,
      //     );
      //   },
      //   closedBuilder: (context, action) {
      // return
      // FloatingActionButton(
      //     child: Icon(
      //       Octicons.pencil,
      //       color: Colors.white,
      //     ),
      //     backgroundColor: Colors.black,
      //     hoverColor: Colors.purple,
      //     onPressed: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) {
      //             return TimelineForm(
      //               isUpdating: false,
      //               scaffoldContext: scaffoldContext,
      //             );
      //           },
      //         ),
      //         // ),
      //       );
      // });
      // },
      // ),
    );
  }
}
