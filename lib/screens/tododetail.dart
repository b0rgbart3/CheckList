import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:todos/model/todo.dart';
import 'package:todos/util/dbhelper.dart';
import 'package:intl/intl.dart';

List<String> choices = const <String>[
  'Save Todo & Back',
  'Delete Todo',
  'Back to List'
];

DbHelper helper = DbHelper();
const mnuSave = 'Save Todo & Back';
const mnuDelete = 'Delete Todo';
const mnuBack = 'Back to List';

class TodoDetail extends StatefulWidget {
  final Todo todo;
  TodoDetail(this.todo);

  @override
  State<StatefulWidget> createState() => TodoDetailState(todo);
}

class TodoDetailState extends State {
  Todo todo;
  TodoDetailState(this.todo);
  final _priorities = ["High", "Medium", "Low"];
  String _priority = "Low";
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = todo.title;
    descriptionController.text = todo.description;

    TextStyle textStyle = Theme.of(context).textTheme.bodyText1;
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            todo.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
                onSelected: select,
                itemBuilder: (BuildContext context) {
                  return choices.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                }),
          ]),
      body: todoForm(context),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            save();
          },
          tooltip: "Save this Todo",
          child: IconButton(iconSize: 34.0, icon: Icon(Icons.save))),
    );
  }

  void select(String value) async {
    switch (value) {
      case mnuSave:
        save();
        break;
      case mnuDelete:
        deleteItem();
        break;
      case mnuBack:
        Navigator.pop(context, true);
        break;

      default:
        break;
    }
  }

  void deleteItem() async {
    int result;
    Navigator.pop(context, true);
    if (todo.id == null) {
      return;
    }
    result = await helper.deleteTodo(todo.id);
    if (result != 0) {
      AlertDialog alertDialog = AlertDialog(
        title: Text("Delete Item"),
        content: Text("The Checklist Item has been deleted"),
      );
      showDialog(context: context, builder: (_) => alertDialog);
    }
  }

  void save() {
    todo.date = new DateFormat.yMd().format(DateTime.now());
    if (todo.id != null) {
      helper.updateTodo(todo);
    } else {
      helper.insertTodo(todo);
    }
    Navigator.pop(context, true);
  }

  void updatePriority(String value) {
    switch (value) {
      case "High":
        todo.priority = 1;
        break;
      case "Medium":
        todo.priority = 2;
        break;
      case "Low":
        todo.priority = 3;
        break;
      default:
        todo.priority = 3;
        break;
    }
    setState(() {
      _priority = value;
    });
  }

  String retrievePriority(int value) {
    return _priorities[value - 1];
  }

  void updateTitle() {
    todo.title = titleController.text;
  }

  void updateDescription() {
    todo.description = descriptionController.text;
  }

  todoForm(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.bodyText1;
    return Padding(
        padding: EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
        child: ListView(children: <Widget>[
          Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    iconSize: 34.0,
                    icon: Icon(Icons.delete_forever),
                    tooltip: 'Delete this Item',
                    onPressed: () {
                      deleteItem();
                    }),
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
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
                padding: EdgeInsets.all(15.0),
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
                 Padding(
                  padding: EdgeInsets.all(25.0),
                  child: 
              ListTile(
                title: DropdownButton<String>(
                    items: _priorities.map((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    style: textStyle,
                    value: retrievePriority(todo.priority),
                    onChanged: (value) => updatePriority(value)),
              ),
                 )
            ],
            
          )
        ]));
  }
}
