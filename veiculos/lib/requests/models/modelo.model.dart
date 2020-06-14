import 'package:flutter/material.dart';
import 'package:veiculos/requests/models/marca.model.dart';

class ModeloItem {
  final int id;
  final String codigo;
  final String descricao;
  final MarcaItem marca;

  ModeloItem({this.id, this.codigo, this.descricao, this.marca});

  factory ModeloItem.fromJson(Map<String, dynamic> json) {
    return ModeloItem(
        id: json['id'],
        codigo: json['codigo'],
        descricao: json['descricao'],
        marca: MarcaItem.fromJson(json['marca']));
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'codigo': codigo,
        'descricao': descricao,
        'marca': marca?.toJson()
      };
}
