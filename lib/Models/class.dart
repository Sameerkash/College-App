// class ClassRoom {
//   final String className;
//   final String batch;
//   final String department;
//   final String classKey;

//   ClassRoom({this.className, this.department, this.batch, this.classKey});

//   factory ClassRoom.fromMap(Map<String, dynamic> data) {
//     if (data == null) {
//       return null;
//     }
//     final String className = data['className'];
//     final String batch = data['batch'];
//     final String department = data['department'];
//     final String classKey = data['classKey'];
//     return ClassRoom(
//       className: className,
//       batch: batch,
//       department: department,
//       classKey: classKey,
//     );
//   }
//   Map<String, dynamic> toMap() {
//     return {
//       'className': className,
//       'batch': batch,
//       'department': department,
//       'classkey': classKey
//     };
//   }
// }

// class Subject {
//   final String department;
//   final String scheme;
//   final String subjectCode;
//   final String name;
//   final String displayName;
//   final String credits;
//   final String hours;

//   Subject({
//     this.department,
//     this.scheme,
//     this.subjectCode,
//     this.name,
//     this.displayName,
//     this.credits,
//     this.hours,
//   });

//   factory Subject.fromMap(Map<String, dynamic> data) {
//     if (data == null) {
//       return null;
//     }
//     final String department = data['department'];
//     final String scheme = data['scheme'];
//     final String subjectCode = data['subjectCode'];
//     final String name = data['name'];
//     final String displayName = data['displayName'];
//     final String credits = data['credits'];
//     final String hours = data['hours'];
//     return Subject(
//         department: department,
//         scheme: scheme,
//         subjectCode: subjectCode,
//         name: name,
//         displayName: displayName,
//         credits: credits,
//         hours: hours);
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'department': department,
//       'scheme': scheme,
//       'subjectCode': subjectCode,
//       'name': name,
//       'displayName': displayName,
//       'credits': credits,
//       'hours': hours
//     };
//   }
// }

// // class Marks {
// //   final String uid;
// //   final String usn;
// //   final String name;
// //   final String classKey;
// //   final String department;
// //   final String batch;
// //   final Map<String, dynamic> subejctsMarks;

// //   Marks({
// //     this.uid,
// //     this.usn,
// //     this.name,
// //     this.classKey,
// //     this.department,
// //     this.batch,
// //     this.subejctsMarks,
// //   });

// //   factory Marks.fromMap(Map<String, dynamic> data) {
// //     if (data == null) {
// //       return null;
// //     }
// //     final String uid = data['uid'];
// //     final String usn = data['usn'];
// //     final String name = data['name'];
// //     final String classKey = data['classKey'];
// //     final String department = data['department'];
// //     final String batch = data['batch'];
// //     final Map<String, dynamic> subejctsMarks = data['subjectMarks'];

// //     return Marks(
// //       uid: uid,
// //       usn: usn,
// //       name: name,
// //       classKey: classKey,
// //       department: department,
// //       batch: batch,
// //       subejctsMarks: subejctsMarks,
// //     );
// //   }

// //   Map<String, dynamic> toStudentMap() {
// //     return {
// //       'uid': uid,
// //       'usn': usn,
// //       'name': name,
// //       'classKey': classKey,
// //       'department': department,
// //       'batch': batch,
// //     };
// //   }
// //    Map<String, dynamic> toMarksMap() {
// //      return{
      
// //      };
// // }
// // }