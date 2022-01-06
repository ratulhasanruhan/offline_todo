import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController todoControler = TextEditingController();
  TextEditingController updateController = TextEditingController();

  var box = Hive.box('box');

  Future<void> addData() async {
    int num = box.length;

    if (todoControler.text != '') {
      num++;
      setState(() {
        box.put(num, todoControler.text);
      });

      todoControler.clear();
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: 'Write Something ....');
    }

    if (kDebugMode) {
      print(box.keys.last);
      print(box.keys.first);
      print(box.keys.length);
      print(box.keys);
    }
  }

  void editTodo(int index) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Update ToDo'),
          content: TextFormField(
            controller: updateController,
            autofocus: true,
            enableSuggestions: true,
            decoration: InputDecoration(
                hintText: box.getAt(index),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(10),
                )),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (updateController.text != '') {
                  setState(() {
                    box.putAt(index, updateController.text);
                  });
                  updateController.clear();
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                  Fluttertoast.showToast(msg: 'Write Something to Update');
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Hive0'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
          reverse: true,
          itemCount: box.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    onTap: () => editTodo(index),
                    trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          box.deleteAt(index);
                        });
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    tileColor:
                        Colors.primaries[index % Colors.primaries.length],
                    title: Text(box.getAt(index)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Text(
                        'Add ToDo',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.primaries[
                              Random().nextInt(Colors.primaries.length)],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        onEditingComplete: addData,
                        autofocus: true,
                        enableSuggestions: true,
                        controller: todoControler,
                        decoration: InputDecoration(
                            labelText: 'Write Something',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          height: 45,
                          color: Colors.primaries[
                              Random().nextInt(Colors.primaries.length)],
                          onPressed: () {
                            addData();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              Text(
                                'Add your Data',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
        backgroundColor:
            Colors.primaries[Random().nextInt(Colors.primaries.length)],
        child: Icon(Icons.add),
      ),
    );
  }
}
