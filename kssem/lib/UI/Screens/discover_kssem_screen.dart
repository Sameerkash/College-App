import 'package:flutter/material.dart';
import 'package:kssem/UI/Screens/discover_screens/pragathi.dart';
import 'package:kssem/Utilities/size_config.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class DiscoverKssemScreen extends StatefulWidget {
  @override
  _DiscoverKssemScreenState createState() => _DiscoverKssemScreenState();
}

class _DiscoverKssemScreenState extends State<DiscoverKssemScreen> {
  List<String> images = [
    "assets/prajathi.png",
    "assets/studentclubs.jpg",
    "assets/mat1.jpg",
    "assets/mat2.jpg",
    "assets/mat4.png",
    "assets/aboutus.jpg"
  ];

  List<String> tileNames = [
    "Pragathi",
    "Departments",
    "Student Clubs",
    "Highlights",
    "About KSSEM",
    "Pay Online",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.color,
          title: Text(
            "Discover KSSEM",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body:
            // child:
            StaggeredGridView.countBuilder(
          // physics: NeverScrollableScrollPhysics(),
          // shrinkWrap: ,
          crossAxisCount: 4,
          itemCount: 6,
          itemBuilder: (BuildContext context, int index) => Padding(
            padding: const EdgeInsets.all(2.0),
            child: Stack(children: <Widget>[
              InkWell(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Container())),
                child: Container(
                  foregroundDecoration:
                      BoxDecoration(color: Colors.black.withOpacity(.5)),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(images[index]), fit: BoxFit.cover),
                  ),

                  // color: Colors.green,
                ),
              ),
              Center(
                  child: Text(
                tileNames[index],
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w900),
              ))
            ]),
          ),
          staggeredTileBuilder: (int index) =>
              StaggeredTile.count(2, index.isEven ? 3 : 2),
          mainAxisSpacing: 0.5,
          crossAxisSpacing: SizeConfig.blockSizeVertical * 0.01,
          // ),
        ));
  }
}
