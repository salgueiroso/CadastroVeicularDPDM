import 'package:flutter/material.dart';

class MarcaItem {
  final int id;
  final String codigo;
  final String descricao;

  MarcaItem({this.id, this.codigo, this.descricao});

  factory MarcaItem.fromJson(Map<String, dynamic> json) {
    return MarcaItem(
        id: json['id'], codigo: json['codigo'], descricao: json['descricao']);
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'codigo': codigo, 'descricao': descricao};
}
