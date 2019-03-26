import 'package:flutter/material.dart';
import 'package:todos_app/screens/tododetails.dart';
import 'package:todos_app/utils/dbhelper.dart';
import 'package:todos_app/models/todo.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TodoListState();
}

class TodoListState extends State {
  DbHelper dbHelper = DbHelper();
  List<Todo> todos;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    // Check if the todos collection is null. If it is null instantiate
    // it and fetch the data from db. Todos collection is null first time
    if (todos == null) {
      todos = List();
      getData();
    }

    return Scaffold(
      body: todoListItems(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetails(Todo('','', 3, ''));
        },
        tooltip: "Add new Todo",
        child: Icon(Icons.add),
      ),
    );
  }


  ListView todoListItems() {
   // ListView is constructed with a build method
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          // Card is a sheet of material with a slightly rounded corners
          // ListTile is a row that contains title, leading icon
          // leading attribute provide the feature to place circular icon in a row
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: getColor(todos[position].periority),
                child: Text(todos[position].periority.toString()),
              ),
              title: Text(todos[position].title),
              subtitle: Text(todos[position].date),
              onTap: () {
                debugPrint("Item taped at " + position.toString() +
                    " is " + todos[position].id.toString());
                navigateToDetails(todos[position]);
              },
            ),
          );
        }
    );
  }

  /*
   * Fetch the data from db and map into the list
   */
  void getData() {
    //initialize the db and it return the future
    final dbFuture = dbHelper.initializeDB();
    //then method will be executed only when the database successfully opened
    dbFuture.then((result) {
      //fetch all the record from todos table and it is also a future
      final futureTodos = dbHelper.getTodo();
      futureTodos.then((result) {
        List<Todo> list = new List();
        count = result.length;
        //iterate over each item of the list
        for (int i = 0; i < count; i++) {
          list.add(Todo.fromObject(result[i]));
          debugPrint(list[i].toString());
        }

        //set state to update the list and count
        setState(() {
          todos = list;
          count = count;
        });

        debugPrint("Items count:" + count.toString());
      });
    });
  }

  /*
   * Fetch the color according to the periority
   */
  Color getColor(int periority) {
    switch(periority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.green;

      default:
        return Colors.green;

    }
  }

  /*
   * Navigate to details screen by using navigator push
   */
  void navigateToDetails(Todo todo) async {
    bool check = await Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => TodoDetails(todo))
    );

  }
}
