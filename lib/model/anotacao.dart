import 'package:anotacoes/helper/anotacao_helper.dart';

class Anotacao {
  int? id;
  String? titulo;
  String? descricao;
  String? data;

  Anotacao(this.titulo, this.descricao, this.data);

  //contrutuor q eu passo um map e ele retorna um objeto
  Anotacao.fromMap(Map map) {
    this.id = map[AnotacaoHelper.colunaId];
    this.titulo = map[AnotacaoHelper.colunaTitulo];
    this.descricao = map[AnotacaoHelper.colunaDescricao];
    this.data = map[AnotacaoHelper.colunaData];
  }
//metodo q retorna um map
  Map? toMap() {
    Map<String, dynamic> map = {
      'Titulo': this.titulo,
      'descricao': this.descricao,
      'data': this.data,
    };
    if (this.id != null) {
      map['id'] = this.id;
    }
    return map;
  }
}
