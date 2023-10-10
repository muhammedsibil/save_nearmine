import 'package:flutter/material.dart';

enum Category { electrician, plumber,painter,welder, }

class SelectCategory extends StatefulWidget {
  const SelectCategory({super.key});

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  Category? _character = Category.electrician;
  bool seeMore = true;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 199,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                title: const Text('Electrician'),
                leading: Radio(
                  value: Category.electrician,
                  groupValue: _character,
                  onChanged: (Category? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                title: const Text('Plumber'),
                leading: Radio(
                  value: Category.plumber,
                  groupValue: _character,
                  onChanged: (Category? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                title: const Text('Plumber'),
                leading: Radio(
                  value: Category.plumber,
                  groupValue: _character,
                  onChanged: (Category? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                title: const Text('Plumber'),
                leading: Radio(
                  value: Category.plumber,
                  groupValue: _character,
                  onChanged: (Category? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                ),
              ),
            ),
        
          ],
        ),
      ),
    );
  }
}
