import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kssem/Models/post.dart';
import 'package:kssem/Notifiers/profile_notifier.dart';
import 'package:kssem/Notifiers/timeline_notifier.dart';
import 'package:kssem/Services/database.dart';
import 'package:kssem/UI/Widgets/platform_exceptoin_alert.dart';
import 'package:kssem/UI/Widgets/progress_bars.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class TimelineForm extends StatefulWidget {
  TimelineForm({Key key, this.isUpdating, this.scaffoldContext})
      : super(key: key);
  final bool isUpdating;
  final BuildContext scaffoldContext;

  @override
  _TimelineFormState createState() => _TimelineFormState();
}

class _TimelineFormState extends State<TimelineForm>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  bool get wantKeepAlive => true;

  bool _isLoading = false;

  final snackBar = SnackBar(
      duration: Duration(seconds: 4),
      content: Text(
        "Posted Successfully!",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.red);

  String _content;
  String _title;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.color,
      ),
      backgroundColor: Colors.grey[250],
      body: _isLoading
          ? Center(
              child: Container(
                // height: ,
                child: ColorLoader3(
                  radius: 16,
                  dotRadius: 6,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(5),
                            child: TextFormField(
                              decoration: InputDecoration(
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      style: BorderStyle.solid,
                                      color: Colors.red,
                                      width: 2),
                                ),
                                hintText: "Title",
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              validator: (value) {
                                if (value.length > 25) {
                                  return "Title should be less than 25 characters";
                                } else if (value.isEmpty) {
                                  return "Title cannot be empty";
                                } else
                                  return null;
                              },
                              onSaved: (value) {
                                _title = value;
                              },
                              maxLines: 2,
                            ),
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "What's on your mind?",
                              hintStyle: TextStyle(fontSize: 25),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Content canot be empty";
                              } else if (value.contains("fuck") ||
                                  value.contains("sex") ||
                                  value.contains("porn") ||
                                  value.contains("FUCK") ||
                                  value.contains("SEX") ||
                                  value.contains("PORN") ||
                                  value.contains("asshole") ||
                                  value.contains("Asshole") ||
                                  value.contains("Motherfuck") ||
                                  value.contains("motherfuck") ||
                                  value.contains("Fuck") ||
                                  value.contains("Sex") ||
                                  value.contains("Porn")) {
                                return "Remove inappropraite langauge";
                              } else if (value.length < 30) {
                                return "Try adding some more information";
                              } else
                                return null;
                            },
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            onSaved: (value) {
                              _content = value;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: _isLoading
          ? Container()
          : FloatingActionButton(
            heroTag: 'timeline',
              splashColor: Colors.indigo,
              child: Icon(
                Octicons.check,
                color: Colors.white,
              ),
              backgroundColor: Theme.of(context).iconTheme.color,
              hoverColor: Colors.purple,
              onPressed: () {
                _submit(context);
              },
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

  Future<void> _submit(BuildContext context) async {
    final db = Provider.of<Database>(context, listen: false);
    final profile = Provider.of<ProfileNotifier>(context, listen: false);
    final timeline = Provider.of<TimelineNotifer>(context, listen: false);
    if (_validateAndSaveForm()) {
      try {
        // String dateTime = DateTime.now().toIso8601String();
        // Timestamp timeStamp = Timestamp.now();
        Post post = Post(
          uid: db.userId,
          userName: profile.student.displayName,
          photoUrl: db.photoUrl,
          title: _title,
          content: _content,
        );
        setState(() {
          _isLoading = true;
        });
        // await db.setTimeline(post, widget.isUpdating);
        await db.setPost(widget.isUpdating, post: post);
        await db.getTimeline(timeline);
        await db.getPosts(profile);

        setState(() {
          _isLoading = false;
        });

        Scaffold.of(widget.scaffoldContext).showSnackBar(snackBar);

        Navigator.pop(context);
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }
}
