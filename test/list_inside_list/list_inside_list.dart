import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  List<Student> rowlist = [
    Student(name: 'John', age: 12),
    Student(name: 'Kity', age: 13),
    Student(name: 'Micle', age: 14),
    Student(name: 'Jack', age: 12),
    Student(name: 'Cha', age: 13),
    Student(name: 'Duc', age: 13),
    Student(name: 'Ran', age: 12),
  ];

  List<List<Student>> result = [[]];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  TextEditingController c = TextEditingController();
  String name = "";
  var age = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(
              width: 100,
              height: 50,
              child: TextField(
                controller: c,
                onChanged: (value) {
                  name = value;
                  age = 16;
                  print(name);
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    // result.add([Student(name: 'Abu', age: 13)]);
                    rowlist.add(Student(name: name, age: age));
                  });

                  result = rowlist
                      .groupListsBy((student) => student.name)
                      .values
                      .toList();

                  // result = rowlist
                  //     .groupListsBy((student) => student.age)
                  //     .values
                  //     .toList();
                },
                child: Text('title')),
          ],
        ),
      ),
      body: ListView.builder(
          itemCount: result.length,
          itemBuilder: (context, index) {
            return Container(
              width: 100,
              height: 30,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                  itemCount: result[index].length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) {

                   
                    return   Text(result[index][i].name.toString())
                    ;
                  }),
            );
          }),
    );
  }
}

class Student {
  final String name;
  final int age;
  const Student({required this.name, required this.age});
  @override
  String toString() => 'Student(name: $name, age: $age)';
}
