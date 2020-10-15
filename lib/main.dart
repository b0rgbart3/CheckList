import 'package:flutter/material.dart';
import 'package:todos/util/dbhelper.dart';
import 'package:todos/model/todo.dart';
import 'package:todos/screens/todolist.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DbHelper helper = DbHelper();

    // List<Todo> todos = List<Todo>();
    // DateTime today = DateTime.now();
    // Todo todo = Todo("Buy Melon", 3, today.toString(), "And make sure they are good" );


      
    // helper.initializeDb().then(
    //   (result) => helper.getTodos().then( (result) => todos=result )
    // );

    // helper.insertTodo(todo);

    return MaterialApp(
      title: 'MY TODOS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'My Todos'),
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
    return Scaffold(appBar: new AppBar(
      title: new Text(widget.title),
      ),

      body: TodoList(),
    );
  }
}
