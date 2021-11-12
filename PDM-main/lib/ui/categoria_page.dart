import 'package:projeto_banco/models/categoria.dart';
import 'package:flutter/material.dart';

class CategoriaPage extends StatefulWidget {
  final Categoria categorias;
  CategoriaPage({this.categorias});

  @override
  _CategoriaPageState createState() => _CategoriaPageState();
}

class _CategoriaPageState extends State<CategoriaPage> {
  final _nomeController = TextEditingController();

  final _nomeFocus = FocusNode();

  bool _userEdited = false;
  Categoria _editedCategoria;

  @override
  void initState() {
    super.initState();

    if (widget.categorias == null) {
      _editedCategoria = Categoria(0, '_nomeController');
    } else {
      _editedCategoria = Categoria.fromMap(widget.categorias.toMap());

      _nomeController.text = _editedCategoria.nome;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.greenAccent,
            title: Text(_editedCategoria.nome ?? "Nova Categoria"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_editedCategoria.nome == null ||
                  _editedCategoria.nome.isEmpty) {
                FocusScope.of(context).requestFocus(_nomeFocus);
                return;
              }
              //if (_editedCategoria.categorias.nome == null ||
              //    _editedCategoria.categorias.nome.isEmpty) {
              // FocusScope.of(context).requestFocus(_statusFocus);
              //return;
              //}
              Navigator.pop(context, _editedCategoria);
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.greenAccent,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextField(
                  controller: _nomeController,
                  focusNode: _nomeFocus,
                  decoration: InputDecoration(labelText: "Nome"),
                  onChanged: (text) {
                    _userEdited = true;
                    setState(() {
                      _editedCategoria.nome = text;
                    });
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
