import 'package:projeto_banco/models/status.dart';
import 'package:flutter/material.dart';

class StatusPage extends StatefulWidget {
  final Status status;
  StatusPage({this.status});

  @override
  _StatusPageState createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  final _nomeController = TextEditingController();

  final _nomeFocus = FocusNode();

  bool _userEdited = false;
  Status _editedStatus;

  @override
  void initState() {
    super.initState();

    if (widget.status == null) {
      _editedStatus = Status(0, '_nomeController');
    } else {
      _editedStatus = Status.fromMap(widget.status.toMap());

      _nomeController.text = _editedStatus.nome;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.greenAccent,
            title: Text(_editedStatus.nome ?? "Novo Status"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_editedStatus.nome == null || _editedStatus.nome.isEmpty) {
                FocusScope.of(context).requestFocus(_nomeFocus);
                return;
              }
              //if (_editedStatus.status.nome == null ||
              //    _editedStatus.status.nome.isEmpty) {
              // FocusScope.of(context).requestFocus(_statusFocus);
              //return;
              //}
              Navigator.pop(context, _editedStatus);
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
                      _editedStatus.nome = text;
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
