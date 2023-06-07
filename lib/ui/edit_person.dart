import 'package:flutter/material.dart';
import 'package:flutter_examples/conection/database.dart';
import 'package:flutter_examples/models/person.dart';

class EditPerson extends StatefulWidget {
  final bool edit;
  final Person person;

  const EditPerson(this.edit, {super.key, required this.person});
  //: assert(edit == true);

  @override
  _EditPersonState createState() => _EditPersonState();
}

class _EditPersonState extends State<EditPerson> {
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController cityEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.edit == true) {
      nameEditingController.text = widget.person.name;
      cityEditingController.text = widget.person.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.edit ? "Edit Person" : "Add person"),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlutterLogo(
                    size: 300,
                  ),
                  textFormField(nameEditingController, "Name", "Enter Name",
                      Icons.person, widget.edit ? widget.person.name : "s"),
                  textFormField(cityEditingController, "City", "Enter City",
                      Icons.place, widget.edit ? widget.person.phone : "jk"),
                  ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                      } else if (widget.edit == true) {
                        PersonDatabaseProvider.db.updatePerson(Person(
                            name: nameEditingController.text,
                            phone: cityEditingController.text,
                            id: widget.person.id,
                            code: '',
                            state: ''));
                        Navigator.pop(context);
                      } else {
                        await PersonDatabaseProvider.db.addPersonToDatabase(
                            Person(
                                id: 0,
                                name: nameEditingController.text,
                                phone: cityEditingController.text,
                                code: cityEditingController.text,
                                state: cityEditingController.text));
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  textFormField(TextEditingController t, String label, String hint,
      IconData iconData, String initialValue) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
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
