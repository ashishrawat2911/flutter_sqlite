import 'package:flutter/material.dart';
import 'package:flutter_sqlite/database.dart';
import 'package:flutter_sqlite/person.dart';

class EditPerson extends StatefulWidget {
  @override
  _EditPersonState createState() => _EditPersonState();
}

class _EditPersonState extends State<EditPerson> {
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController cityEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(key: _formKey,
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(
                size: 300,
              ),
              textFormField(
                  nameEditingController, "Name", "Enter Name", Icons.person),
              textFormField(
                  cityEditingController, "City", "Enter City", Icons.place),
              RaisedButton(
                color: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (!_formKey.currentState.validate()) {
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Processing Data')));
                  } else {
                    await DBProvider.dbProvider.newPerson(new Person(
                        name: nameEditingController.text,
                        city: cityEditingController.text));
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      )),
    );
  }

  textFormField(
      TextEditingController t, String label, String hint, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: TextFormField(validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
      },
        controller: t,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
            prefixIcon: Icon(iconData),
            hintText: hint,
            labelText: label,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}
