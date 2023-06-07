class Todo {
  String id;
  String title;
  String description;
  bool completed;
  String created;
  String lastUpdated;

  Todo(
      {required this.id,
      required this.title,
      required this.description,
      required this.completed,
      required this.created,
      required this.lastUpdated});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      completed: json['completed'],
      created: json['created'],
      lastUpdated: json['lastUpdated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed,
      'created': created,
      'lastUpdated': lastUpdated
    };
  }
}
