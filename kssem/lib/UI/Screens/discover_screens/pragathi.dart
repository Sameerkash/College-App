// import 'package:flutter/material.dart';
// import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

// class PragathiPage extends StatefulWidget {
//   @override
//   _PragathiPageState createState() => _PragathiPageState();
// }

// class _PragathiPageState extends State<PragathiPage> {
//   bool _isLoading = true;
//   PDFDocument document;
//   final http = "http://www.pdf995.com/samples/pdf.pdf";

//   @override
//   void initState() {
//     super.initState();
//     _loadDocument();
//   }

//   _loadDocument() async {
//     final doc = await PDFDocument.fromURL(http);

//     setState(() {
//       document = doc;
//       _isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Text(
//           "Pragathi",
//           style: TextStyle(fontStyle: FontStyle.italic, fontSize: 25),
//         ),
//       ),
//       body: Center(
//         child: _isLoading
//             ? Center(child: CircularProgressIndicator())
//             : PDFViewer(
//                 document: document,
//                 showNavigation: false,
//                 showPicker: false,
//               ),
//       ),
//     );
//   }
// }
