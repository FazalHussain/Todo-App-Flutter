import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todos_app/models/todo.dart';

class DbHelper {

    static final DbHelper _dbHelper = DbHelper._internal();
    static final DBVersion = 1;
    static Database _db;

    String tblTodo = "todo";
    String colId = "id";
    String colTitle = "title";
    String coldescription = "description";
    String colPeriority = "periority";
    String colDate = "date";

    /*
     * Named Constructor
     */
    DbHelper._internal();

    /*
     * Factory Constructor
     *
     * Use factory to always return the same instance
     */
    factory DbHelper() {
      return _dbHelper;
    }

    /*
     * Fetch the db instance. if it is null initialize it
     */
    Future<Database> get db async {
      if(_db == null) {
        _db = await initializeDB();
      }
      return _db;
    }

    /*
     * initialize db in secondary thread (Worker thread) by using async
     * which will return Future of type DbHelper.
     *
     * await is used for long running operation
     */
    Future<Database> initializeDB() async {
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path + 'todos.db';
      var dbTodos = await openDatabase(path, version: DBVersion, onCreate: _onCreate);
      return dbTodos;
    }

    /*
     * Create table todos
     */
    void _onCreate(Database db, int version) async {
      await db.execute(
        "CREATE TABLE $tblTodo($colId INTEGER PRIMARY KEY, $colTitle TEXT, "
            "$coldescription TEXT, $colPeriority INTEGER, $colDate TEXT)"
      );
    }


    //CRUD OPERATION

    /*
     * Convert todos to map and insert it into db
     */
    Future<int> todoInsert(Todo todo) async {
      Database db = await this.db;
      var result = db.insert(tblTodo, todo.toMap());
      return result;
    }

    /*
     * Retrive todos data from database
     */
    Future<List> getTodo() async {
      Database db = await this.db;
      var result = db.rawQuery("SELECT * FROM $tblTodo ORDER BY $colPeriority ASC");
      return result;
    }

    /*
     * Fetch the count of the records
     */
    Future<int> getCount() async {
      Database db = await this.db;
      var result = Sqflite.firstIntValue(
        await db.rawQuery("select count (*) from $tblTodo")
      );
      return result;
    }

    /*
     * Update the record in the table
     */
    Future<int> update(Todo todo) async {
      Database db = await this.db;
      var result = await db.update(tblTodo, todo.toMap(), where: "$colId = ?",
        whereArgs: [todo.id]);
      return result;
    }

    /*
     * Update the record in the table
     */
    Future<int> delete(Todo todo) async {
      Database db = await this.db;
      var result = await db.delete(tblTodo, where: "$colId = ?",
          whereArgs: [todo.id]);
      return result;
    }
    


}