import 'package:flutter/material.dart';
import 'package:kssem/Utilities/size_config.dart';
import 'package:shimmer/shimmer.dart';

class TimlineShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
          body: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.white,
        child: ShimmerTimeline(),
        // period: Duration(milliseconds:20 ),
      ),
    );
  }
}

class ShimmerTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 35,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    height: 30,
                    width: SizeConfig.screenWidth - 200,
                    color: Colors.grey,
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 35,
                width: SizeConfig.screenWidth - 100,
                color: Colors.grey,
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                height: 300,
                width: SizeConfig.screenWidth - 20,
                color: Colors.grey,
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        );
      },
    );
  }
}

post() {
  Container(
    padding: EdgeInsets.only(top: 15, left: 15, right: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            CircleAvatar(
              radius: 35,
            ),
            SizedBox(
              width: 15,
            ),
            Container(
              height: 30,
              width: SizeConfig.screenWidth - 200,
              color: Colors.grey,
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          height: 35,
          width: SizeConfig.screenWidth - 100,
          color: Colors.grey,
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          height: 300,
          width: SizeConfig.screenWidth - 20,
          color: Colors.grey,
        ),
        SizedBox(
          height: 30,
        ),
      ],
    ),
  );
}

class ProfileShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.white,
        child: ShimmerProfile(),
        // period: Duration(milliseconds:20 ),
      ),
    );
  }
}

class ShimmerProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
      child: 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Row(
          //   children: <Widget>[
          //     CircleAvatar(
          //       radius: 70,
          //     ),
          //     SizedBox(
          //       width: 15,
          //     ),
          //     Column(
          //       children: <Widget>[
          //         Container(
          //           height: 30,
          //           width: SizeConfig.screenWidth - 200,
          //           color: Colors.grey,
          //         ),
          //         SizedBox(
          //           height: 15,
          //         ),
          //         Container(
          //           height: 25,
          //           width: SizeConfig.screenWidth - 300,
          //           color: Colors.grey,
          //         ),
          //       ],
          //     ),
          //   ],
          // ),
          // SizedBox(
          //   height: 15,
          // ),
          // Container(
          //   height: 35,
          //   width: SizeConfig.screenWidth - 50,
          //   color: Colors.grey,
          // ),
          // SizedBox(
          //   height: 10,
          // ),
          // Container(
          //   height: 35,
          //   width: SizeConfig.screenWidth - 50,
          //   color: Colors.grey,
          // ),
          // SizedBox(
          //   height: 50,
          // ),
          Container(
            padding: EdgeInsets.only(top: 15, left: 15,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 35,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      height: 30,
                      width: SizeConfig.screenWidth - 200,
                      color: Colors.grey,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 35,
                  width: SizeConfig.screenWidth - 100,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 300,
                  width: SizeConfig.screenWidth - 20,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
