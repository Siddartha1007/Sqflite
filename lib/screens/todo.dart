import 'package:flutter/material.dart';
import '../model/todoClass.dart';
import '../db/dBase.dart';

class Todo extends StatefulWidget {
  const Todo({ Key? key, required this.title }) : super(key: key);
  final String title;
  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {

  TextEditingController textController = new TextEditingController();
  List<TodoClass> taskList = [];
  
  @override
  void initState() {
    super.initState();
 
    Dbase.instance.queryAllRows().then((value) {
      setState(() {
        value?.forEach((element) {
          taskList.add(TodoClass(id: element['id'], title: element["title"]));
        });
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(hintText: "Enter a task"),
                    controller: textController,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addToDb,
                )
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                child: taskList.isEmpty
                    ? Container()
                    : ListView.builder(
                      itemCount: taskList.length,
                      itemBuilder: (ctx, index) {
                        if (index == taskList.length) return Container();
                        return ListTile(
                          title: Text(taskList[index].title),
                          // leading: Text(taskList[index].id.toString()),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteTask(taskList[index].id),
                          ),
                        );
                      }),
              ),
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){
      //           Navigator.push(
      //             context, 
      //             MaterialPageRoute(
      //               builder: (_) => Fun()
      //             )
      //           );
      //         },
      //   child: Icon(Icons.add,),
      // ),

    );
  }
  void _deleteTask(int? id) async {
    await Dbase.instance.delete(id!);
    setState(() {
      taskList.removeWhere((element) => element.id == id);
    });
  }
 
  void _addToDb() async {
    String task = textController.text;
    var id = await Dbase.instance.insert(TodoClass(title: task));
    setState(() {
      taskList.insert(0, TodoClass(id: id, title: task));
    });
  }
}