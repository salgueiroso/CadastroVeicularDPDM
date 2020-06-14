import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:veiculos/pages/marcas/marcas.page.dart';
import 'package:veiculos/requests/models/marca.model.dart';
import 'package:veiculos/requests/models/modelo.model.dart';
import 'package:veiculos/requests/urls.dart';

class ModelosEditPage extends StatefulWidget {
  final int id;

  ModelosEditPage({Key key, this.id}) : super(key: key);

  @override
  _ModelosEditPage createState() => _ModelosEditPage();
}

class _ModelosEditPage extends State<ModelosEditPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final codigoController = new TextEditingController();
  final descricaoController = new TextEditingController();

  List<MarcaItem> marcas;
  int marcaId;

  @override
  void initState() {
    marcas = [];
    fetchMarcas().then((value) {
      setState(() {
        marcas = value;
      });
    }).then((value) {
      if (widget.id != null)
        fetch(widget.id).then((value) {
          descricaoController.text = value.descricao;
          codigoController.text = value.codigo;
          setState(() {
            marcaId = value.marca.id;
          });

        }).catchError((e) => _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text('Erro ao obter modelo! $e'))));
    }).catchError((e) => _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text('Erro ao obter marcas! $e'))));

    super.initState();
  }

  Future<List<MarcaItem>> fetchMarcas() async {
    var response = await http.get("$URL_MARCAS");
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      var _items = jsonResponse.map((a) => new MarcaItem.fromJson(a)).toList();
      return _items;
    } else {
      throw Exception('${response.reasonPhrase}');
    }
  }

  Future<ModeloItem> fetch(int id) async {
    if (id != null) {
      var response = await http.get("$URL_MODELOS/$id");
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var _item = new ModeloItem.fromJson(jsonResponse);
        return _item;
      } else {
        throw Exception('${response.reasonPhrase}');
      }
    }

    return ModeloItem();
  }

  Future salvar() async {
    if (!_formKey.currentState.validate()) return null;

    ModeloItem modelo;
    if (widget.id == null)
      modelo = ModeloItem(
          descricao: descricaoController.text,
          codigo: codigoController.text,
          marca: MarcaItem(id: marcaId));
    else
      modelo = ModeloItem(
          id: widget.id,
          descricao: descricaoController.text,
          codigo: codigoController.text,
          marca: MarcaItem(id: marcaId));

    var headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var body = json.encode(modelo);
    http.Response response;
    if (widget.id != null)
      response = await http
          .put("$URL_MODELOS", headers: headers, body: body)
          .timeout(Duration(seconds: 10));
    else
      response = await http
          .post("$URL_MODELOS", headers: headers, body: body)
          .timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Erro ao salvar modelo! ${response.reasonPhrase}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
              widget.id == null ? 'Adição de Modelo' : 'Alteração de Modelo'),
        ),
        body: formularioWidget(),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.save), onPressed: () => salvar()));
  }

  Widget formularioWidget() {
    return Form(
      autovalidate: true,
      key: _formKey,
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(children: [
            TextFormField(
              controller: codigoController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                LengthLimitingTextInputFormatter(6),
                BlacklistingTextInputFormatter.singleLineFormatter,
              ],
              validator: (value) {
                if (value.isEmpty) return "Informe um código válido";
                if (value.length < 6) return "Código deve possuir 6 caracteres";
                return null;
              },
              decoration: const InputDecoration(
                  //icon: Icon(Icons.edit),
                  hintText: 'Código do modelo',
                  labelText: 'Código *'),
            ),
            TextFormField(
              controller: descricaoController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              inputFormatters: [
                LengthLimitingTextInputFormatter(32),
                BlacklistingTextInputFormatter.singleLineFormatter,
              ],
              validator: (value) {
                if (value.isEmpty) return "Informe um nome válido";
                if (value.length <= 3)
                  return "Nome deve ser maior que 3 caracteres";
                return null;
              },
              decoration: const InputDecoration(
                  //icon: Icon(Icons.edit),
                  hintText: 'Nome do modelo',
                  labelText: 'Modelo *'),
            ),
            DropdownButtonFormField<int>(
              value: marcaId,
              items: marcas
                  .map((e) => DropdownMenuItem<int>(
                        child: Text(e.descricao),
                        value: e.id,
                      ))
                  .toList(),
              onChanged: (newVal) {
                setState(() {
                  marcaId = newVal;
                });
              },
              validator: (value) {
                if (value == null) return "Informa uma marca";
                return null;
              },
              decoration: const InputDecoration(
                  //icon: Icon(Icons.edit),
                  hintText: 'Marca do modelo',
                  labelText: 'Marca *'),
            )
          ])),
    );
  }
}
