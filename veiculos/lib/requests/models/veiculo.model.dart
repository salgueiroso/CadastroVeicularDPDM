import 'package:flutter/material.dart';
import 'package:veiculos/requests/models/marca.model.dart';
import 'package:veiculos/requests/models/modelo.model.dart';

class VeiculoItem {
  final int id;
  final String descricao;
  final int ano;
  final String cor;
  final MarcaItem marca;
  final ModeloItem modelo;

  VeiculoItem(
      {this.id, this.descricao, this.ano, this.cor, this.marca, this.modelo});

  factory VeiculoItem.fromJson(Map<String, dynamic> json) {
    return VeiculoItem(
        id: json['id'],
        descricao: json['descricao'],
        ano: int.parse(json['ano'].toString()),
        cor: json['cor'],
        marca: MarcaItem.fromJson(json['marca']),
        modelo: ModeloItem.fromJson(json['modelo']));
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'descricao': descricao,
        'ano': ano,
        'cor': cor,
        'marca': marca.toJson(),
        'modelo': modelo.toJson()
      };
}
