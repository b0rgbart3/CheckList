import 'package:flutter/material.dart';
import 'package:todos/model/todo.dart';
import 'package:todos/util/dbhelper.dart';
import 'package:todos/screens/tododetail.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TodoListState();
}

class TodoListState extends State {
  DbHelper helper = DbHelper();

  List<Todo> todos;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    if (todos == null) {
      todos = List<Todo>();
      getData();
    }

    return Scaffold(
        body: todoListItems(),
        floatingActionButton: FloatingActionButton(
            onPressed:  () { navigateToDetail( Todo('',3,'') ); },
            tooltip: "Add new Todo",
            child: IconButton( iconSize: 44.0, icon: Icon( Icons.add ))
            )
            );
  }

  ListView todoListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child:GestureDetector( 
                                      child: Stack (
                                        children: <Widget>[
                                        ListTile(
                                        leading: CircleAvatar(
                                            
                                            backgroundColor: getColor(this.todos[position].priority),
                                            child: Text(this.todos[position].priority.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)
                                            ),
                                        title: Text(this.todos[position].title),
                                        subtitle: Text(this.todos[position].date),
                                        trailing: 
                                        (
                                          this.todos[position].completed == true ?

                                          IconButton(iconSize: 34.0, icon: Icon(Icons.check))
                                          
                                          :

                                          Text('')
                                        )
                                        ,
                                        onTap: () { 
                                          
                                         setState(() {
                                           
                                                  if( this.todos[position].completed == true) {
                                              this.todos[position].completed = false;
                                            } else {
                                              this.todos[position].completed = true;
                                            }
                                               });
                                         },

                                        
                                        
                                        ),
                                  
                                        ]
                                      ),
                      onDoubleTap: () {
                          navigateToDetail( this.todos[position] );
                                        },

          )
        );
      },
    );
  }

  void getData() {
    final dbFuture = helper.initializeDb();
    dbFuture.then((result) {
      final todosFuture = helper.getTodos();
      todosFuture.then((result) {
        List<Todo> todoList = List<Todo>();
        count = result.length;
        for (int i = 0; i < count; i++) {
          todoList.add(Todo.fromObject(result[i]));
          debugPrint(todoList[i].title);
        }
        setState(() {
          todos = todoList;
          count = count;
        });
        debugPrint("Items" + count.toString());
      });
    });
  }

  Color getColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.lightBlue[900];
        break;
      case 2:
        return Colors.lightBlue[700];
        break;
      case 3:
        return Colors.lightBlue[400];
        break;
      default:
        return Colors.green;
    }
  }

  void navigateToDetail(Todo todo) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TodoDetail(todo)));
    // Navigator.of(context).push( 
    //   MaterialPageRoute(builder: (context) => TodoDetail(todo))
      
     // );

     if (result == true) {
       getData();
     }
  }
}
