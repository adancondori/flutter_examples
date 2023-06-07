import 'package:flutter/material.dart';
import 'package:flutter_examples/conection/database.dart';
import 'package:flutter_examples/models/person.dart';
import 'package:flutter_examples/ui/edit_person.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void didUpdateWidget(MyHomePage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter SQLite"),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              PersonDatabaseProvider.db.deleteAllPersons();
              setState(() {});
            },
            child: Text('Delete all'),
          ),
        ],
      ),
      body: FutureBuilder<List<Person>>(
        future: PersonDatabaseProvider.db.getAllPersons(),
        builder: (BuildContext context, AsyncSnapshot<List<Person>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                Person item = snapshot.data![index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    PersonDatabaseProvider.db.deletePersonWithId(item.id);
                  },
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text(item.phone),
                    leading: CircleAvatar(child: Text(item.id.toString())),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditPerson(
                                true,
                                person: item,
                              )));
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditPerson(
                      false,
                      person: Person(
                          id: 0,
                          name: "test",
                          phone: "phone",
                          code: "code",
                          state: "state"),
                    )));
          }),
    );
  }
}
