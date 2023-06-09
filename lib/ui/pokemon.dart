import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_examples/models/pokemon.dart';
import 'package:http/http.dart' as http;

class PokeminAPI extends StatefulWidget {
  @override
  _PokeminAPIState createState() => _PokeminAPIState();
}

class _PokeminAPIState extends State<PokeminAPI> {
  @override
  void didUpdateWidget(PokeminAPI oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    setState(() {});
  }

  Future<Pokemon> getAPIPokemon(int id) async {
    var uri = Uri.https('pokeapi.co', '/api/v2/pokemon/${id.toString()}');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      Pokemon pokemon = Pokemon.fromMap(json.decode(response.body));
      return pokemon;
      //return jsonDecode(respuesta.body);
    } else {
      print("Error con la respusta");
    }
    return Pokemon(id: 1, name: "", base_experience: 0);
  }

  Future<List<Pokemon>> _getListado() async {
    List id_pokemon = [1, 2, 3, 4, 5];
    List<Pokemon> pokemons = [];
    for (var item in id_pokemon) {
      Pokemon pokemon = await getAPIPokemon(item);
      pokemons.add(pokemon);
    }
    return pokemons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter SQLite"),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              // Algo
            },
            child: Text('Delete all API'),
          ),
        ],
      ),
      body: FutureBuilder<dynamic>(
        future: _getListado(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot);
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                Pokemon item = snapshot.data![index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    // TODO
                  },
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text("Exp: ${item.base_experience.toString()}"),
                    leading: CircleAvatar(child: Text(item.id.toString())),
                    onTap: () {
                      //Navigator.of(context).push(MaterialPageRoute(
                      //    builder: (context) => EditPerson(
                      //          true,
                      //          person: item,
                      //        )));
                    },
                  ),
                );
              },
            );
          } else {
            print("No hay información");
            return Text("Sin data");
          }
        },
        // initialData: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  List<Widget> listado(List<Pokemon> info) {
    List<Widget> lista = [];
    info.forEach((elemento) {
      lista.add(Text(elemento.name));
    });
    return lista;
  }
}
