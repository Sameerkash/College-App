class ClassRoom {
  final String className;
  final String batch;
  final String department;
  final String classKey;

  ClassRoom({this.className, this.department, this.batch, this.classKey});

  factory ClassRoom.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String className = data['className'];
    final String batch = data['batch'];
    final String department = data['department'];
    final String classKey = data['classKey'];
    return ClassRoom(
      className: className,
      batch: batch,
      department: department,
      classKey: classKey,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'className': className,
      'batch': batch,
      'department': department,
      'classkey': classKey
    };
  }
}
