import 'dart:io';
import 'dart:async';
import 'package:projeto_banco/models/categoria.dart';
import 'package:projeto_banco/models/status.dart';
import 'package:projeto_banco/models/chamados.dart';
import 'package:projeto_banco/ui/chamado_page.dart';
import 'package:flutter/material.dart';
//import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ChamadoConnect chamadoConnect = ChamadoConnect();
  CategoriaConnect categoriaConnect = CategoriaConnect();
  StatusConnect statusConnect = StatusConnect();

  List<Chamado> listaChamados = [];

  @override
  void initState() {
    super.initState();

    resetarBanco();

    _getAllChamados();
  }

  void resetarBanco() async {
    categoriaConnect.dropTable();
    categoriaConnect.createTable();

    statusConnect.dropTable();
    statusConnect.createTable();

    chamadoConnect.dropTable();
    chamadoConnect.createTable();

    Categoria categoria = Categoria(null, 'categoria');
    categoria = await categoriaConnect.saveCategoria(categoria);

    Status status = Status(null, 'status');
    status = await statusConnect.saveStatus(status);

    Chamado chamado = Chamado();
    chamado.id = null;
    chamado.titulo = 'titulo';
    chamado.responsavel = 'responsavel';
    chamado.interacao = 'interacao';
    chamado.categoria = categoria;
    chamado.status = status;
    chamado.relator = 'relator';
    chamado.img = '';

    chamado = await chamadoConnect.saveChamado(chamado);

    _getAllChamados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chamados"),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("pressionou");
          _showChamadoPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: listaChamados.length,
          itemBuilder: (context, index) {
            return _chamadoCard(context, index);
          }),
    );
  }

  Widget _chamadoCard(BuildContext context, int index) {
    return GestureDetector(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(listaChamados[index].titulo ?? "",
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold)),
                      Text(listaChamados[index].responsavel ?? "",
                          style: TextStyle(fontSize: 18.0)),
                      Text(listaChamados[index].relator ?? "",
                          style: TextStyle(fontSize: 18.0)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        onTap: () {
          _showChamadoPage(chamado: listaChamados[index]);
        });
  }

  void _showChamadoPage({Chamado chamado}) async {
    final Chamado recChamado = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChamadoPage(
                  chamado: chamado,
                )));
    if (recChamado != null) {
      if (chamado != null) {
        await categoriaConnect.updatecategoria(recChamado.categoria);
        await statusConnect.updatestatus(recChamado.status);
        await chamadoConnect.updatechamado(recChamado);
      } else {
        await categoriaConnect.saveCategoria(recChamado.categoria);
        await statusConnect.saveStatus(recChamado.status);
        await chamadoConnect.saveChamado(recChamado);
      }
      _getAllChamados();
    }
  }

  void _getAllChamados() {
    chamadoConnect.getAllChamados().then((list) {
      setState(() {
        listaChamados = list;
      });
      //print(list);
    });
  }
}
