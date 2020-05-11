import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kssem/Models/notification.dart';
import 'package:kssem/Notifiers/profile_notifier.dart';
import 'package:kssem/Notifiers/timeline_notifier.dart';
import '../../Models/post.dart';
import '../../Services/database.dart';
import '../Widgets/platform_exceptoin_alert.dart';
import '../Widgets/progress_bars.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class TimelineForm extends StatefulWidget {
  TimelineForm(
      {Key key,
      this.isUpdating,
      this.isCollegeNotification,
      this.isDepartmentnotification,
      this.selectedDept,
      this.scaffoldContext})
      : super(key: key);
  final bool isUpdating;
  final bool isDepartmentnotification;
  final bool isCollegeNotification;
  final String selectedDept;
  final BuildContext scaffoldContext;

  @override
  _TimelineFormState createState() => _TimelineFormState();
}

class _TimelineFormState extends State<TimelineForm>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  bool get wantKeepAlive => true;

  bool _isLoading = false;
  String _imageUrl;
  File _imageFile;
  String _content;
  String _title;

  final snackBar = SnackBar(
      duration: Duration(seconds: 4),
      content: Text(
        "Posted  Successfully!",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.red);

  _showImage() {
    if (_imageFile == null && _imageUrl == null) {
      return Container();
      // return Text("image placeholder");
    } else if (_imageFile != null) {
      // print("showing image from local file ");
      return Stack(children: [
        Container(
          color: Colors.grey[200],
          height: 500,
          width: 400,
          child: Image.file(
            _imageFile,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          top: 420,
          left: 40,
          child: FlatButton(
            color: Colors.white,
            onPressed: () {
              _getLocalImage();
            },
            child: Text(
              "Change Image",
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
        ),
        Positioned(
          top: 420,
          left: 220,
          child: FlatButton(
            color: Colors.white,
            onPressed: () {
              setState(() {
                _imageFile = null;
              });
            },
            child: Text(
              "Remove Image",
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
        )
      ]);
    }
  }

  _getLocalImage() async {
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
        maxWidth: 400,
        maxHeight: 500);
    if (imageFile != null) {
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: widget.isDepartmentnotification &&
                widget.isCollegeNotification == false
            ? Text("Sending to Department")
            : Text("Sending to College"),
        // actions: <Widget>[
        //   IconButton(
        //       icon: Icon(MaterialCommunityIcons.image),
        //       onPressed: () {
        //         _getLocalImage();
        //       }),
        //   IconButton(
        //     icon: Icon(MaterialCommunityIcons.arrow_up_bold_circle),
        //     onPressed: () {},
        //   ),
        // ],
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
                          (widget.isDepartmentnotification == true ||
                                  widget.isCollegeNotification == true)
                              ? Container(
                                  height: 0,
                                )
                              : Container(
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
                          Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 20),
                            child: _imageFile == null
                                ? Container(
                                    width: 400,
                                    child: FlatButton(
                                      color: Colors.black,
                                      child: Text(
                                        "Add Image",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        _getLocalImage();
                                      },
                                    ),
                                  )
                                : _showImage(),
                          ),
                          (widget.isDepartmentnotification ||
                                  widget.isCollegeNotification)
                              ? TextFormField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Enter the notification",
                                    hintStyle: TextStyle(fontSize: 25),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Content canot be empty";
                                    } else if (value.length > 350) {
                                      return "Should be less than 350 characters";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  onSaved: (value) {
                                    _content = value;
                                  },
                                )
                              : TextFormField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "What's on your mind?",
                                    hintStyle: TextStyle(fontSize: 25),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Content canot be empty";
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
              splashColor: Colors.indigo,
              child: Icon(
                Octicons.check,
                color: Colors.white,
              ),
              backgroundColor: Colors.black,
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
    final faculty = Provider.of<ProfileNotifier>(context, listen: false);
    final timelinePosts = Provider.of<TimelineNotifer>(context, listen: false);
    final posts = Provider.of<ProfileNotifier>(context, listen: false);
    if (_validateAndSaveForm()) {
      try {
        // String dateTime = DateTime.now().toIso8601String();
        // Timestamp timeStamp = Timestamp.now();
        Notifications notifiy = Notifications(
            uid: db.userId,
            facultyName: db.displayName,
            content: _content,
            storedDepartment: faculty.currentFaculty.department,
            isCollegeNotification: widget.isCollegeNotification
            // department: widget.selectedDept
            );
        setState(() {
          _isLoading = true;
        });
        if (widget.isDepartmentnotification == true &&
            widget.isCollegeNotification == false) {
          // print(widget.selectedDept);

          await db.setNotificationImage(
              localFile: _imageFile,
              notification: notifiy,
              currentdepartment: widget.selectedDept,
              isCollegeNotify: widget.isCollegeNotification,
              isDetNotify: widget.isDepartmentnotification);
        } else if (widget.isDepartmentnotification == false &&
            widget.isCollegeNotification == true) {
          await db.setNotificationImage(
              localFile: _imageFile,
              notification: notifiy,
              currentdepartment: widget.selectedDept,
              isCollegeNotify: widget.isCollegeNotification,
              isDetNotify: widget.isDepartmentnotification);
        } else {
          Post post = Post(
            uid: db.userId,
            userName: faculty.currentFaculty.displayName,
            photoUrl: db.photoUrl,
            title: _title,
            content: _content,
          );
          // setState(() {
          //   _isLoading = true;
          // });
          // await db.setTimeline(post, widget.isUpdating);
          await db.setPostImage(
            widget.isUpdating,
            post: post,
            localFile: _imageFile,
          );
          setState(() {
            _isLoading = false;
          });

          await db.getTimeline(timelinePosts);
          await  db.getPosts(posts);
          Scaffold.of(widget.scaffoldContext).showSnackBar(snackBar);
        }

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
