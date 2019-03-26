class Todo {
  // "_" show their access is private
  int _id;
  String _title;
  String _description;
  int _periority;
  String _date;

  /*
   * Constructor
   *
   * Note that you have only one constructor without name if you want
   * to add more constructor create a name constructor
   */
  Todo(this._title, this._description, this._periority, this._date);

  /*
   * Name Constructor
   */
  Todo.withId(this._id, this._title, this._description, this._periority,
      this._date);

  //getters

  String get date => _date;

  int get periority => _periority;

  String get description => _description;

  String get title => _title;

  int get id => _id;

  //setters

  set date(String value) {
    _date = value;
  }

  set periority(int value) {
    if(value > 0 && value <= 3)
      _periority = value;
  }

  set description(String value) {
    if(value.length <= 255)
      _description = value;
  }

  set title(String value) {
    if(value.length <= 255)
      _title = value;
  }

  /*
   * Convert the todos into map which is used to store in db
   */
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["title"] = _title;
    map["description"] = _description;
    map["periority"] = _periority;
    map["date"] = _date;
    if(_id != null) {
      map["id"] = _id;
    }

    return map;
  }

  /*
   * Convert the dynamic into todos
   */
  Todo.fromObject(dynamic o) {
    this._id = o["id"];
    this._title = o["title"];
    this._description = o["description"];
    this._periority = o["periority"];
    this._date = o["date"];
  }












}