import 'package:flutter/material.dart';
import 'package:todos_app/utils/dbhelper.dart';
import 'package:todos_app/models/todo.dart';
import 'package:intl/intl.dart';

// To interact with data base create an instance of DbHelper
DbHelper dbHelper = DbHelper();
// Menu Collection
final List<String> choices = const <String> [
  "Save Todo & Back",
  "Delete Todo",
  "Back to List"
];

// Menu Constants
const mnuSave = "Save Todo & Back";
const mnuDelete = "Delete Todo";
const mnuBack = "Back to List";

/*
 * Todos Details Screen
 */
class TodoDetails extends StatefulWidget {
  final Todo todo;

  /*
   * Constructor
   */
  TodoDetails(this.todo);

  @override
  State<StatefulWidget> createState() => TodoDetailsState(todo);
}

/*
 * Todos Detail State Class
 */
class TodoDetailsState extends State {
  Todo todo;

  /*
   * Constructor
   */
  TodoDetailsState(this.todo);

  final _periorities = ["High", "Medium", "Low"];

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    titleController.text = todo.title;
    descriptionController.text = todo.description;
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //hide back navigation on action bar
        title: Text(todo.title),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: selectMenu,
            itemBuilder: (BuildContext context){
              return choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Padding(
          padding: EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
          //When you rotate the device there is no space to show the widget
          // completely when keyboard open flutter will show you the error.
          // To avoid the error we have enclosed the in list view
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: TextField(
                      controller: titleController,
                      style: textStyle,
                      onChanged: (value) => this.updateTitle(),
                      decoration: InputDecoration(
                          labelText: "Title",
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: TextField(
                      controller: descriptionController,
                      style: textStyle,
                      onChanged: (value) => this.updateDescription(),
                      decoration: InputDecoration(
                          labelText: "Description",
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                  // DropDown take the whole width of the screen using ListTile
                  // By default it will take according to the maximum string length
                  ListTile(title:DropdownButton<String>(
                    items: _periorities.map((String value) {
                      return DropdownMenuItem<String>(
                          value: value, child: Text(value));
                    }).toList(),
                    style: textStyle,
                    value: fetchPeriority(todo.periority),
                    onChanged: (String val) {
                      _onDropDownChanged(val);
                    },
                  ))
                ],
              ),
            ],
          )),
    );
  }

  /*
   * Update the dropdown value using setState
   */
  void _onDropDownChanged(String val) {
    switch(val) {
      case "High": {
        todo.periority = 1;
        break;
      }

      case "Medium": {
        todo.periority = 2;
        break;
      }

      case "Low": {
        todo.periority = 3;
        break;
      }
    }
    setState(() {
      this._periority = val;
    });
  }

  /*
   * Fetch the periority
   */
  String fetchPeriority(int value) {
    return _periorities[value - 1];
  }

  /*
   * Update the title of todos
   */
  void updateTitle() {
    todo.title = titleController.text;
  }

  /*
   * Update the description of todos
   */
  void updateDescription() {
    todo.description = descriptionController.text;
  }

  void selectMenu(String value) {

    switch(value) {
      case mnuSave: {
        save();
        break;
      }

      case mnuDelete: {
        delete();
        break;
      }

      case mnuBack:{
        //Pop the detail page from the stack and show to the listing screen
        Navigator.pop(context, true);
        break;
      }

    }
  }
  /*
   * Save the todos in the todos table if it is already exist
   * update it and get back to listing screen.
   */
  void save() {
    todo.date = DateFormat.yMd().format(DateTime.now());
    if(todo.id != null) {
      //already exist just update it.
      dbHelper.update(todo);
    } else {
      // New todos just add it
      dbHelper.todoInsert(todo);
    }
    Navigator.pop(context, true);
  }

  /*
   * Delete the todos from the todos table. If the user come from adding
   * todos and try to delete than simply return to listing screen
   */
  void delete() async {
    int result;
    //Pop the detail page from the stack and show to the listing screen
    Navigator.pop(context, true);
    if(todo.id == null) return; //If the user come from add fab button
    result = await dbHelper.delete(todo.id);
    //Check if delete success than show the alert dialog
    if (result != 0) {
      AlertDialog alertDialog = AlertDialog(
        title: Text("Delete Todo"),
        content: Text("The todo has been deleted"),
      );
      showDialog(
          context: context,
          builder: (_) => alertDialog
      );
    }
  }
}
