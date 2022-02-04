import 'package:anotacoes/helper/anotacao_helper.dart';
import 'package:anotacoes/model/anotacao.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  var _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = [];
  //=============================================
  _ExibirTelaCadastro({Anotacao? anotacao}) {

    String textoSalvarAtualizar = '';
    if(anotacao == null){//salvando
_tituloController.text='';
_descricaoController.text='';
textoSalvarAtualizar = 'Salvar';
    }else{//atualizando
    _tituloController.text=anotacao.titulo!;
_descricaoController.text=anotacao.descricao!;
textoSalvarAtualizar = 'Atualizar';

    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('$textoSalvarAtualizar anotação'),
            content: Column(
              mainAxisSize: MainAxisSize.min, //define tam min para a coluna
              children: [
                TextField(
                  controller: _tituloController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    hintText: 'Digite o título...',
                  ),
                ),
                TextField(
                  controller: _descricaoController,
                  autofocus: true,
                  decoration: const InputDecoration(
                      labelText: 'Descrição',
                      hintText: 'Digite a descrição...'),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text(textoSalvarAtualizar),
                onPressed: () {
                  _salvarAtualizarAnotacao(anotacaoSelecionada: anotacao);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  //___metodo para mostrar os dados q estao salvos
  _recuperarAnotacaes() async {
    // _anotacoes.clear(); //se nao tivesse a lista tempororai adicionaria direto no anotaçoes dentro do setState e usar esse
    List _anotacoesRecuperadas = await _db.recuperarAnotacaoes();
    List<Anotacao> _listaTemporaria = [];
    for (var item in _anotacoesRecuperadas) {
      Anotacao anotacao = Anotacao.fromMap(item);
      _listaTemporaria.add(anotacao);
    }
    setState(() {
      _anotacoes = _listaTemporaria;
    });
    _listaTemporaria = [];
    print('Lista recuperadas:  ' + _anotacoesRecuperadas.toString());
  }

  //___metodo para reuperar dados digitados_______
  _salvarAtualizarAnotacao({Anotacao? anotacaoSelecionada}) async {
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;

if(anotacaoSelecionada ==null){//salvar
Anotacao anotacao = Anotacao(titulo, descricao, DateTime.now().toString());
    int resultado = await _db.salvarAnotacao(anotacao);
}else{//atualizar
anotacaoSelecionada.titulo = titulo;
anotacaoSelecionada.descricao= descricao;
anotacaoSelecionada.data= DateTime.now().toString();//se quiser atualizar a data
int resultado =await _db.atualizarAnotacao(anotacaoSelecionada);

}

    //===========================
    _tituloController.clear();
    _descricaoController.clear();
    _recuperarAnotacaes();
  }

  //[[[[[[metodo para formatar data]]]]]]
  _formatarData(String data) {
    initializeDateFormatting('pt_BR');
    var formatador = DateFormat('d/MM/y');
//var formatador = DateFormat.yMMMMd('pt_BR');
//var formatador = DateFormat('d-MMM-y H:m:s');
    DateTime dataConvertida =
        DateTime.parse(data); //conerte String para DateTime
    String dataFormatada = formatador.format(dataConvertida);
    return dataFormatada;
  }
  //[[[[[[[[[remover/deletar]]]]]]]]]
_removerAnotacao(int id)async{
await _db.removerAnotacoes(id);
_recuperarAnotacaes();
}
  //{{{{{{recuperar as anotacoes usando o initState}}}}}}
  @override
  void initState() {
    super.initState();
    _recuperarAnotacaes();
  }
  //==============================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anotações'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _anotacoes.length,
              itemBuilder: (context, index) {
                final anotacao = _anotacoes[index];
                return Card(
                  child: ListTile(
                    leading: Text(anotacao.id.toString()),
                    title: Text(anotacao.titulo!),
                    subtitle: Text(
                        '${_formatarData(anotacao.data!)} - ${anotacao.descricao!}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //(((((((((EDITAR)))))))))
                        GestureDetector(
                          onTap: (){
                            _ExibirTelaCadastro(anotacao: anotacao);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Icon(
                              Icons.edit,
                              color: Theme.of(context).primaryColor,
                              ),
                            ),
                        ),
                        //[[[[[[[[[[REMOVER]]]]]]]]]]
                        GestureDetector(
                          onTap: (){
                           _removerAnotacao(anotacao.id!);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 0),
                            child: Icon(
                              Icons.remove_circle,
                              color: Theme.of(context).errorColor,
                              ),
                            ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton(        
               child: const Icon(Icons.add),
        onPressed: () {
          _ExibirTelaCadastro();
        },
      ),
    );
  }
}
