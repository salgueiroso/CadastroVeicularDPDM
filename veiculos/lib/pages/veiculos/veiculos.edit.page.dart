import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:veiculos/pages/marcas/marcas.page.dart';
import 'package:veiculos/requests/models/marca.model.dart';
import 'package:veiculos/requests/models/modelo.model.dart';
import 'package:veiculos/requests/models/veiculo.model.dart';
import 'package:veiculos/requests/urls.dart';

class VeiculosEditPage extends StatefulWidget {
  final int id;

  VeiculosEditPage({Key key, this.id}) : super(key: key);

  @override
  _VeiculosEditPage createState() => _VeiculosEditPage();
}

class _VeiculosEditPage extends State<VeiculosEditPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final descricaoController = new TextEditingController();
  final corController = new TextEditingController();
  final anoController = new TextEditingController();

  List<MarcaItem> marcas;
  List<ModeloItem> modelos;
  int marcaId;
  int modeloId;

  @override
  void initState() {
    modelos = [];
    marcas = [];
    fetchMarcas().then((value) {
      setState(() {
        marcas = value;
      });
    }).then((value) {
      fetchModelos().then((value) => setState(() {
            modelos = value;
          }));
    }).then((value) {
      if (widget.id != null)
        fetch(widget.id).then((value) {
          descricaoController.text = value.descricao;
          corController.text = value.cor;
          anoController.text = value.ano.toString();
          setState(() {
            marcaId = value.marca.id;
            modeloId = value.modelo.id;
          });
        }).catchError((e) => _scaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text('Erro ao obter veiculo! $e'))));
    }).catchError((e) => _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text('Erro ao obter marcas/modelos! $e'))));

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

  Future<List<ModeloItem>> fetchModelos() async {
    var response = await http.get("$URL_MODELOS");
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      var _items = jsonResponse.map((a) => new ModeloItem.fromJson(a)).toList();
      return _items;
    } else {
      throw Exception('${response.reasonPhrase}');
    }
  }

  Future<VeiculoItem> fetch(int id) async {
    if (id != null) {
      var response = await http.get("$URL_VEICULOS/$id");
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var _item = new VeiculoItem.fromJson(jsonResponse);
        return _item;
      } else {
        throw Exception('${response.reasonPhrase}');
      }
    }

    return VeiculoItem();
  }

  Future salvar() async {
    if (!_formKey.currentState.validate()) return null;

    VeiculoItem veiculo;
    if (widget.id == null)
      veiculo = VeiculoItem(
          ano: int.parse(anoController.text),
          cor: corController.text,
          descricao: descricaoController.text,
          marca: MarcaItem(id: marcaId),
          modelo: ModeloItem(id: modeloId));
    else
      veiculo = VeiculoItem(
          id: widget.id,
          ano: int.parse(anoController.text),
          cor: corController.text,
          descricao: descricaoController.text,
          marca: MarcaItem(id: marcaId),
          modelo: ModeloItem(id: modeloId));

    var headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    var body = json.encode(veiculo);
    http.Response response;
    if (widget.id != null)
      response = await http
          .put("$URL_VEICULOS", headers: headers, body: body)
          .timeout(Duration(seconds: 10));
    else
      response = await http
          .post("$URL_VEICULOS", headers: headers, body: body)
          .timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Erro ao salvar veiculo! ${response.reasonPhrase}')));
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
                  hintText: 'Nome do veículo',
                  labelText: 'Veículo *'),
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
            ),
            DropdownButtonFormField<int>(
              value: modeloId,
              items: modelos
                  .where((e) => e.marca.id == marcaId)
                  .map((e) => DropdownMenuItem<int>(
                        child: Text(e.descricao),
                        value: e.id,
                      ))
                  .toList(),
              onChanged: (newVal) {
                setState(() {
                  modeloId = newVal;
                });
              },
              validator: (value) {
                if (value == null) return "Informa um modelo";
                return null;
              },
              decoration: const InputDecoration(
                  //icon: Icon(Icons.edit),
                  hintText: 'Modelo do veículo',
                  labelText: 'Modelo *'),
            ),
            TextFormField(
              controller: corController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              inputFormatters: [
                LengthLimitingTextInputFormatter(32),
                BlacklistingTextInputFormatter.singleLineFormatter,
              ],
              validator: (value) {
                if (value.isEmpty) return "Informe uma cor válida";
                if (value.length <= 3)
                  return "Cor deve ser maior que 3 caracteres";
                return null;
              },
              decoration: const InputDecoration(
                  //icon: Icon(Icons.edit),
                  hintText: 'Cor do veículo',
                  labelText: 'Cor *'),
            ),
            TextFormField(
              controller: anoController,
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.words,
              inputFormatters: [
                LengthLimitingTextInputFormatter(4),
                BlacklistingTextInputFormatter.singleLineFormatter,
              ],
              validator: (value) {
                if (value.isEmpty) return "Informe um ano válido";
                if (value.length < 4) return "Ano deve ter 3 caracteres";
                var anoMaximo = DateTime.now().year + 1;
                if (int.parse(value) > anoMaximo)
                  return "Ano deve ser menos que $anoMaximo";
                return null;
              },
              decoration: const InputDecoration(
                  //icon: Icon(Icons.edit),
                  hintText: 'Ano do veículo',
                  labelText: 'Ano *'),
            ),
          ])),
    );
  }
}
