import 'package:flutter/material.dart';
import 'package:kssem/Utilities/size_config.dart';

class ImagePreview extends StatelessWidget {
  final String imageUrl;

  ImagePreview({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: SizeConfig.screenWidth,
            maxHeight: SizeConfig.screenHeight),
        child: Hero(
          tag: "$imageUrl",
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              // border: Border(: BorderSide(color: Colors.black)),
              image: DecorationImage(
                  image: NetworkImage(imageUrl), fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }
}
