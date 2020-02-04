class ClassRoom {
  final String className;
  final String batch;
  final String department;

  ClassRoom({
    this.className,
    this.department,
    this.batch,
  });

  factory ClassRoom.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String className = data['className'];
    final String batch = data['batch'];
    final String department = data['department'];
    return ClassRoom(
      className: className,
      batch: batch,
      department: department,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'className': className,
      'batch': batch,
      'department': department,
    };
  }
}
