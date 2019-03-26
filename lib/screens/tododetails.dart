import 'package:flutter/material.dart';
import 'package:todos_app/utils/dbhelper.dart';
import 'package:todos_app/models/todo.dart';
import 'package:intl/intl.dart';

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

  String _periority = "Low";
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
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: TextField(
                controller: titleController,
                style: textStyle,
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
                decoration: InputDecoration(
                    labelText: "Description",
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            DropdownButton<String>(
              items: _periorities.map((String value) {
                return DropdownMenuItem<String> (
                    value: value, child: Text(value));
              }).toList(),
              style: textStyle,
              value: _periority,
              onChanged: (String val) {
                _onDropDownChanged(val);
              },
            )
          ],
        ),
      ),
    );
  }

  /*
   * Update the dropdown value using setState
   */
  void _onDropDownChanged(String val) {
    setState(() {
      this._periority = val;
    });
  }
}
