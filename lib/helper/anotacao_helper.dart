import 'package:anotacoes/model/anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//conexoes como bd

class AnotacaoHelper {
  //atributo
  static final  nomeTabela = 'anotacao';
  static final colunaId = 'id';
  static final colunaTitulo = 'titulo';
  static final colunaDescricao = 'descricao';
  static final colunaData = 'data';
  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();

  Database? _db;
  factory AnotacaoHelper() {
    return _anotacaoHelper;
  }
//o construtor
  AnotacaoHelper._internal(); 

  //metodo get para acessar o db
  get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await _inicializarDB();
      return _db;
    }
  }

  //aqui o metodo q cria o bd de fato
  _onCreate(Database db, int version) async {
    String sql =
        'CREATE TABLE $nomeTabela($colunaId INTEGER PRIMARY KEY AUTOINCREMENT, $colunaTitulo VARCHAR, $colunaDescricao TEXT, $colunaData DATETIME)';
    await db.execute(sql);
  }

  //metodo responsavel por inicializar o banco dados
  _inicializarDB() async {
    final caminhosBancoDados = await getDatabasesPath();
    final localBancoDados =
        join(caminhosBancoDados, 'banco_minhas_anotacoes.db');

    var db =
        await openDatabase(localBancoDados, version: 1, onCreate: _onCreate);
    return db;
  }

  //metodo para salvar no bd
  Future<int> salvarAnotacao(Anotacao anotacao) async {
    var bancoDados = await db;
    int resultado = await bancoDados.insert(nomeTabela, anotacao.toMap());
    return resultado;
  }

  recuperarAnotacaoes() async {
    var bancoDados = await db;
    String sql = 'SELECT * FROM $nomeTabela ORDER BY $colunaId DESC';
    List anotacoes = await bancoDados.rawQuery(sql);
    return anotacoes;
  }

  Future<int> atualizarAnotacao(Anotacao anotacao) async {
    var bancoDados = await db;
    return await bancoDados.update(nomeTabela, anotacao.toMap(),
        where: 'id = ?', whereArgs: [anotacao.id]);
  }
  Future<int> removerAnotacoes(int id)async{
    var bancoDados = await db;
    return await bancoDados.delete(nomeTabela,
        where: 'id = ?', whereArgs: [id]);
  }
}
