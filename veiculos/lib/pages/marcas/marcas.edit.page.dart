import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:veiculos/requests/models/marca.model.dart';
import 'package:veiculos/requests/urls.dart';

class MarcasEditPage extends StatefulWidget {
  final int id;

  MarcasEditPage({Key key, this.id}) : super(key: key);

  @override
  _MarcasEditPage createState() => _MarcasEditPage();
}

class _MarcasEditPage extends State<MarcasEditPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final codigoController = new TextEditingController();
  final descricaoController = new TextEditingController();

  @override
  void initState() {
    if (widget.id != null)
      fetch(widget.id).then((value) {
        descricaoController.text = value.descricao;
        codigoController.text = value.codigo;
      }).catchError((e) => _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text('Erro ao obter marca! $e'))));
    super.initState();
  }

  Future<MarcaItem> fetch(int id) async {
    if (id != null) {
      var response = await http.get("$URL_MARCAS/$id");
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var _item = new MarcaItem.fromJson(jsonResponse);
        return _item;
      } else {
        throw Exception('${response.reasonPhrase}');
      }
    }

    return MarcaItem();
  }

  Future salvar() async {
    if (!_formKey.currentState.validate()) return null;

    MarcaItem marca;
    if (widget.id == null)
      marca = MarcaItem(
          descricao: descricaoController.text, codigo: codigoController.text);
    else
      marca = MarcaItem(
          id: widget.id,
          descricao: descricaoController.text,
          codigo: codigoController.text);

    var headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var body = json.encode(marca);
    http.Response response;
    if (widget.id != null)
      response = await http
          .put("$URL_MARCAS", headers: headers, body: body)
          .timeout(Duration(seconds: 10));
    else
      response = await http
          .post("$URL_MARCAS", headers: headers, body: body)
          .timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Erro ao salvar marca! ${response.reasonPhrase}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
              widget.id == null ? 'Adição de Marca' : 'Alteração de marca'),
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
                  hintText: 'Código da marca',
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
                  hintText: 'Nome da marca',
                  labelText: 'Marca *'),
            ),
          ])),
    );
  }
}
