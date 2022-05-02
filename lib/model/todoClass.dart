class TodoClass {
  int? id;
  String title;
 
  TodoClass({ this.id, required this.title});
 
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title};
  }
}