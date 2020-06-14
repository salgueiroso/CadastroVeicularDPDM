import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:veiculos/pages/marcas/marcas.edit.page.dart';
import 'package:veiculos/pages/marcas/marcas.page.dart';
import 'package:veiculos/pages/modelos/modelos.edit.page.dart';
import 'package:veiculos/pages/modelos/modelos.page.dart';
import 'package:veiculos/pages/veiculos/veiculos.edit.page.dart';
import 'package:veiculos/requests/models/marca.model.dart';
import 'package:veiculos/requests/models/modelo.model.dart';
import 'package:veiculos/requests/models/veiculo.model.dart';
import 'package:veiculos/requests/urls.dart';
import 'package:veiculos/widgets/floating_buttons.dart';

class VeiculosPage extends StatefulWidget {
  final String title = "Veiculos";

  @override
  _VeiculosPage createState() => _VeiculosPage();
}

class _VeiculosPage extends State<VeiculosPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<VeiculoItem> veiculos;

  @override
  void initState() {
    veiculos = [];

    loadAll();

    super.initState();
  }

  void loadAll() {
    fetchVeiculos()
        .then((value) => setState(() => veiculos = value))
        .catchError((e) => _scaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text('Erro ao obter veiculos! $e'))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: veiculos.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onLongPress: () => showDialogDeleteAction(veiculos[index].id),
                onTap: () => goToEditPage(id: veiculos[index].id),
                title: Text(veiculos[index].descricao,
                    style: Theme.of(context).textTheme.headline5),
                subtitle: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Marca: ${veiculos[index].marca.descricao}',
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Modelo: ${veiculos[index].modelo.descricao}',
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Ano: ${veiculos[index].ano}',
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Modelo: ${veiculos[index].cor}',
                      ),
                    ),
                  ],
                ),
                isThreeLine: true,
              ),
            );
          }),
      floatingActionButton: FloatingButtons(
        actions: [
          FloatButtonItem(
              icon: Icon(Icons.directions_car),
              label: 'Adicionar Veículo',
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => VeiculosEditPage()))
                  .then((value) => loadAll())),
          FloatButtonItem(
              icon: Icon(Icons.contacts),
              label: 'Modelos',
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ModelosPage()))
                  .then((value) => loadAll())),
          FloatButtonItem(
              icon: Icon(Icons.group),
              label: 'Marcas',
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MarcasPage()))
                  .then((value) => loadAll())),
        ],
      ),
    );
  }

  void goToEditPage({int id}) => Navigator.of(context)
      .push(MaterialPageRoute(
          builder: (context) => VeiculosEditPage(
                id: id,
              )))
      .then((value) => loadAll());

  Future<List<VeiculoItem>> fetchVeiculos() async {
    var response = await http.get(URL_VEICULOS).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      var _items =
          jsonResponse.map((a) => new VeiculoItem.fromJson(a)).toList();
      return _items;
    } else {
      throw Exception('${response.reasonPhrase}');
    }
  }

  Future deleteVeiculo(int id) async {
    var response =
        await http.delete('$URL_VEICULOS/$id').timeout(Duration(seconds: 10));
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
                  deleteVeiculo(id).then((value) => loadAll()).catchError((e) =>
                      _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('Erro ao remover veiculo! $e'))));
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
