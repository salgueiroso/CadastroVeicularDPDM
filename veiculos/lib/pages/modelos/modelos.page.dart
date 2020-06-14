import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:veiculos/pages/marcas/marcas.edit.page.dart';
import 'package:veiculos/pages/modelos/modelos.edit.page.dart';
import 'package:veiculos/requests/models/marca.model.dart';
import 'package:veiculos/requests/models/modelo.model.dart';
import 'package:veiculos/requests/urls.dart';

class ModelosPage extends StatefulWidget {
  final String title = "Modelos";

  @override
  _ModelosPage createState() => _ModelosPage();
}

class _ModelosPage extends State<ModelosPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<ModeloItem> modelos;

  @override
  void initState() {
    modelos = [];

    loadAll();

    super.initState();
  }

  void loadAll(){
    fetchModelos().then((value) => setState(() => modelos = value)).catchError(
            (e) => _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text('Erro ao obter modelos! $e'))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: modelos.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onLongPress: () => showDialogDeleteAction(modelos[index].id),
                onTap: ()=>goToEditPage(id: modelos[index].id),
                title: Text(modelos[index].descricao, style: Theme.of(context).textTheme.headline5),
                subtitle: Text(modelos[index].marca.descricao, style: Theme.of(context).textTheme.headline6),
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
      builder: (context) => ModelosEditPage(
        id: id,
      ))).then((value) => loadAll());

  Future<List<ModeloItem>> fetchModelos() async {
    var response = await http.get(URL_MODELOS).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      var _items = jsonResponse.map((a) => new ModeloItem.fromJson(a)).toList();
      return _items;
    } else {
      throw Exception('${response.reasonPhrase}');
    }
  }

  Future deleteModelo(int id) async {
    var response =
        await http.delete('$URL_MODELOS/$id').timeout(Duration(seconds: 10));
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
                  deleteModelo(id)
                      .then((value) => loadAll())
                      .catchError((e) => _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                              content: Text('Erro ao remover modelo! $e'))));
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
