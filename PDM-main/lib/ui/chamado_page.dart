import 'package:projeto_banco/models/chamados.dart';
import 'package:flutter/material.dart';

class ChamadoPage extends StatefulWidget {
  final Chamado chamado;
  ChamadoPage({this.chamado});

  @override
  _ChamadoPageState createState() => _ChamadoPageState();
}

class _ChamadoPageState extends State<ChamadoPage> {
  final _tituloController = TextEditingController();
  final _responsavelController = TextEditingController();
  final _interacaoController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _statusController = TextEditingController();
  final _relatorController = TextEditingController();
  final _imgController = TextEditingController();

  final _tituloFocus = FocusNode();
  final _categoriaFocus = FocusNode();

  bool _userEdited = false;
  Chamado _editedChamado;

  @override
  void initState() {
    super.initState();

    if (widget.chamado == null) {
      _editedChamado = Chamado();
    } else {
      _editedChamado = Chamado.fromMap(widget.chamado.toMap());

      _tituloController.text = _editedChamado.titulo;
      _responsavelController.text = _editedChamado.responsavel;
      _interacaoController.text = _editedChamado.interacao;
      _categoriaController.text = _editedChamado.categoria.nome;
      _statusController.text = _editedChamado.status.nome;
      _relatorController.text = _editedChamado.relator;
      _imgController.text = _editedChamado.img;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.greenAccent,
            title: Text(_editedChamado.titulo ?? "Novo Chamado"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_editedChamado.titulo == null ||
                  _editedChamado.titulo.isEmpty) {
                FocusScope.of(context).requestFocus(_tituloFocus);
                return;
              }
              if (_editedChamado.categoria.nome == null ||
                  _editedChamado.categoria.nome.isEmpty) {
                FocusScope.of(context).requestFocus(_categoriaFocus);
                return;
              }
              Navigator.pop(context, _editedChamado);
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.greenAccent,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextField(
                  controller: _tituloController,
                  focusNode: _tituloFocus,
                  decoration: InputDecoration(labelText: "Título"),
                  onChanged: (text) {
                    _userEdited = true;
                    setState(() {
                      _editedChamado.titulo = text;
                    });
                  },
                ),
                TextField(
                  controller: _responsavelController,
                  decoration: InputDecoration(labelText: "Responsável"),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedChamado.responsavel = text;
                  },
                ),
                TextField(
                  controller: _interacaoController,
                  decoration: InputDecoration(labelText: "Conteudo"),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedChamado.interacao = text;
                  },
                ),
                TextField(
                  controller: _categoriaController,
                  focusNode: _categoriaFocus,
                  decoration: InputDecoration(labelText: "Categoria"),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedChamado.categoria.nome = text;
                  },
                ),
                TextField(
                  controller: _statusController,
                  decoration: InputDecoration(labelText: "Status"),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedChamado.status.nome = text;
                  },
                ),
                TextField(
                  controller: _relatorController,
                  decoration: InputDecoration(labelText: "Relator"),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedChamado.relator = text;
                  },
                ),
              ],
            ),
          ),
        ));
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: [
                FlatButton(
                    child: Text("Cancelar"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                FlatButton(
                    child: Text("Sim"),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    })
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
