import 'package:flutter/material.dart';
import 'package:todos_app/models/todo.dart';
import 'package:todos_app/screens/todolist.dart';
import 'package:todos_app/utils/dbhelper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Todo',
      theme: ThemeData(

        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(title: 'Todo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: TodoList(),
    );

  }
}
