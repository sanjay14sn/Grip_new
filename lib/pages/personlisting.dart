// SelectionPage.dart
import 'package:flutter/material.dart';

class SelectionPage extends StatelessWidget {
  final List<String> personList;

  const SelectionPage({required this.personList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Person")),
      body: ListView.builder(
        itemCount: personList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(personList[index]),
            onTap: () {
              Navigator.pop(context, personList[index]);
            },
          );
        },
      ),
    );
  }
}
