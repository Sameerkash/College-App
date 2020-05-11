import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kssem/Notifiers/timeline_notifier.dart';
import '../../Models/post.dart';
import '../../Notifiers/profile_notifier.dart';
import '../../Services/database.dart';
import '../Widgets/platform_exceptoin_alert.dart';
import '../Widgets/progress_bars.dart';
import 'package:provider/provider.dart';

class EditTimelineForm extends StatefulWidget {
  EditTimelineForm({this.isUpdating});
  final bool isUpdating;
  @override
  _EditTimelineFormState createState() => _EditTimelineFormState();
}

class _EditTimelineFormState extends State<EditTimelineForm> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  String _content;
  String _title;
  Post _currentPost;

  File _imageFile;
  bool _iSimageUpdated = false;
  bool _isImageReomved = false;
  String _imageUrl;

  @override
  void initState() {
    ProfileNotifier posts =
        Provider.of<ProfileNotifier>(context, listen: false);
    if (posts.currentPost != null) {
      _currentPost = posts.currentPost;

      _imageUrl = _currentPost.imageUrl;
    }
    super.initState();
  }

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
              _iSimageUpdated = true;
              _isImageReomved = false;
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
                _isImageReomved = true;
                _iSimageUpdated = false;
              });
            },
            child: Text(
              "Remove Image",
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
        )
      ]);
    } else if (_imageUrl != null) {
      // print('showing image from url');

      return Stack(
        // alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Container(
            color: Colors.grey[200],
            height: 500,
            width: 400,
            child: Image.network(
              _imageUrl,
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
                _iSimageUpdated = true;
                _isImageReomved = false;
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
                  _imageUrl = null;
                  _isImageReomved = true;
                  _iSimageUpdated = false;

                  print("isremoved $_isImageReomved");
                });
              },
              child: Text(
                "Remove Image",
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
          )
        ],
      );
    }
  }

  _getLocalImage() async {
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
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
    // super.build(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
              icon: Icon(MaterialCommunityIcons.image), onPressed: () {}),
          IconButton(
            icon: Icon(MaterialCommunityIcons.arrow_up_bold_circle),
            onPressed: () {},
          ),
        ],
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
                              initialValue: _currentPost.title,
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
                            child: _imageFile == null && _imageUrl == null
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
                          TextFormField(
                            initialValue: _currentPost.content,
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
                MaterialCommunityIcons.content_save,
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
    if (_validateAndSaveForm()) {
      try {
        print("current url ${_currentPost.imageUrl}");
        UpdatePost updatePost = UpdatePost(
          postId: _currentPost.postId,
          imageUrl: _currentPost.imageUrl,
          title: _title,
          content: _content,
        );

        setState(() {
          _isLoading = true;
        });
        await db.setPostImage(widget.isUpdating,
            updatePost: updatePost,
            localFile: _imageFile,
            isImageUpdated: _iSimageUpdated,
            isImageRemoved: _isImageReomved);

              TimelineNotifer timelinePosts =
            Provider.of<TimelineNotifer>(context, listen: false);
        db.getTimeline(timelinePosts);
        ProfileNotifier posts =
            Provider.of<ProfileNotifier>(context, listen: false);
        db.getPosts(posts);


        setState(() {
          _isLoading = false;
        });

      
        Navigator.pop(context);
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
      {}
    }
  }
}
