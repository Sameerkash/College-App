import 'package:flutter/material.dart';
import 'package:shape_of_view/shape_of_view.dart';

class AcademicScreen extends StatefulWidget {
  static const route = '/academics';

  @override
  _AcademicScreenState createState() => _AcademicScreenState();
}

class _AcademicScreenState extends State<AcademicScreen>
    with AutomaticKeepAliveClientMixin {
  get wantKeepAlive => true;
  buildRows(
      String subject, String attend, int ia1, int ia2, int ia3, int total) {
    return DataRow(cells: <DataCell>[
      DataCell(
        Text(
          subject,
          style: TextStyle(fontSize: 17),
        ),
        // onTap: () {},
      ),
      DataCell(
        Text(
          attend,
          style: TextStyle(fontSize: 17),
        ),
        // onTap: () {},
      ),
      DataCell(
        Text(
          ia1.toString(),
          style: TextStyle(fontSize: 17),
        ),
        // onTap: () {},
      ),
      DataCell(
        Text(
          ia2.toString(),
          style: TextStyle(fontSize: 17),
        ),
        // onTap: () {},
      ),
      DataCell(
        Text(
          ia3.toString(),
          style: TextStyle(fontSize: 17),
        ),
        // onTap: () {},
      ),
      DataCell(
        Text(
          total.toString(),
          style: TextStyle(fontSize: 17),
        ),
        // onTap: () {},
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final _deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Academics ",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.cyan[300],
                Colors.cyan[200],
                // Colors.cyan[100]
              ], begin: Alignment.topLeft),
            ),
            // width: _deviceSize.width*.9,
            padding: EdgeInsets.only(bottom: 10),
            child: ShapeOfView(
              shape: ArcShape(
                  direction: ArcDirection.Outside,
                  height: 35,
                  position: ArcPosition.Bottom),
              child: Container(
                height: 140,
                width: double.infinity,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/sam.jpg'),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Sameer Kashyap ",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "1KG17CS070",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: _deviceSize.width * 0.03,
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          right: _deviceSize.width * 0.01,
                          top: _deviceSize.width * 0.06),
                      child: Text(
                        "V 'B' 17",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.cyan[300],
                  Colors.cyan[200],
                  Colors.cyan[100]
                ], begin: Alignment.topLeft),
              ),
              height: _deviceSize.height * 0.70,
              width: _deviceSize.width * 1.9,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    DataTable(
                      rows: [
                        buildRows("ATC", "85", 35, 35, 38, 37),
                        buildRows("DBMS", "80", 38, 25, 35, 34),
                        buildRows("CN", "80", 38, 25, 35, 34),
                        buildRows("JAVA", "80", 38, 25, 35, 34),
                        buildRows("C#", "80", 38, 25, 35, 34),
                        buildRows("ME", "80", 38, 25, 35, 34),
                        buildRows("DBMS LAB", "80", 38, 25, 35, 34),
                        buildRows("CN LAB", "80", 38, 25, 35, 34),
                        buildRows("DBMS LAB", "80", 38, 25, 35, 34),
                        buildRows("CN LAB", "80", 38, 25, 35, 34),
                        buildRows("ME", "80", 38, 25, 35, 34),
                        buildRows("DBMS LAB", "80", 38, 25, 35, 34),
                        buildRows("CN LAB", "80", 38, 25, 35, 34),
                        buildRows("DBMS LAB", "80", 38, 25, 35, 34),
                        buildRows("CN LAB", "80", 38, 25, 35, 34),
                      ],
                      columns: [
                        buildDataColumn("Subject"),
                        buildDataColumn("Attendance"),
                        buildDataColumn("IA1"),
                        buildDataColumn("IA2"),
                        buildDataColumn("IA3"),
                        buildDataColumn("Total"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Container(
          //   height: 490,
          //   width: double.infinity,
          // )
        ],
      ),
    );
  }

  DataColumn buildDataColumn(String name) {
    return DataColumn(
      label: Text(
        name,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
