class TodoModel {
  String id, title;
  bool status;
  int dTime;

  TodoModel(this.id, this.title, this.status, this.dTime);

  factory TodoModel.fromMap(Map data) => TodoModel(
        data['id'] ?? "000",
        data['title'] ?? "undefined",
        data['status'] ?? false,
        data['d_time'] ?? 111,
      );

  Map<String, dynamic> get toMap => {
        'id': id,
        'title': title,
        'status': status,
        'd_time': dTime,
      };
}
