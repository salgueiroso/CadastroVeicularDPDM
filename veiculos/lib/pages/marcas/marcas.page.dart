import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:veiculos/pages/marcas/marcas.edit.page.dart';
import 'package:veiculos/requests/models/marca.model.dart';
import 'package:veiculos/requests/urls.dart';

class MarcasPage extends StatefulWidget {
  final String title = "Marcas";

  @override
  _MarcasPage createState() => _MarcasPage();
}

class _MarcasPage extends State<MarcasPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<MarcaItem> marcas;

  @override
  void initState() {
    marcas = [];

    loadAll();

    super.initState();
  }

  void loadAll(){
    fetchMarcas().then((value) => setState(() => marcas = value)).catchError(
            (e) => _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text('Erro ao obter marcas! $e'))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: marcas.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onLongPress: () => showDialogDeleteAction(marcas[index].id),
                onTap: ()=>goToEditPage(id: marcas[index].id),
                title: Text(marcas[index].descricao, style: Theme.of(context).textTheme.headline5),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>goToEditPage(),
        tooltip: 'Novo',
        child: Icon(Icons.add),
      ),
    );
  }

  void goToEditPage({int id})
  => Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MarcasEditPage(
        id: id,
      ))).then((value) => loadAll());

  Future<List<MarcaItem>> fetchMarcas() async {
    var response = await http.get(URL_MARCAS).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      var _items = jsonResponse.map((a) => new MarcaItem.fromJson(a)).toList();
      return _items;
    } else {
      throw Exception('${response.reasonPhrase}');
    }
  }

  Future deleteMarca(int id) async {
    var response =
        await http.delete('$URL_MARCAS/$id').timeout(Duration(seconds: 10));
    if (response.statusCode == 200) {
    } else {
      throw Exception('${response.reasonPhrase}');
    }
  }

  void showDialogDeleteAction(int id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmação'),
            content: Text('Deseja remover este item?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Excluir'),
                onPressed: () {
                  deleteMarca(id)
                      .then((value) => loadAll())
                      .catchError((e) => _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                              content: Text('Erro ao remover marcas! $e'))));
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
