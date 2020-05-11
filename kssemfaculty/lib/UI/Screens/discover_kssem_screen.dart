import 'package:flutter/material.dart';

class DiscoverKssemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          " Discover KSSEM",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        // foregroundDecoration: BoxDecoration(color: Colors.black38),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/kssem.jpg'),
          
        )),
        child: Padding(
            padding: EdgeInsets.only(top: 50, left: 30),
            child: Text(
              "Coming Soon..",
              style: TextStyle(fontSize: 50, color: Colors.black),
            )),
      ),
    );
  }
}
