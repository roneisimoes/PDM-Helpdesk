import 'dart:async';

import 'package:path/path.dart';
import 'package:projeto_banco/models/categoria.dart';
import 'package:projeto_banco/models/status.dart';
import 'package:sqflite/sqflite.dart';

final String chamadosTable = "chamadosTable";
final String idChamado = "idChamado";
final String tituloChamado = "tituloChamado";
final String responsavelChamado = "responsavelChamado";
final String interacaoChamado = "interacaoChamado";
final String idCategoriaChamado = "idCategoriaChamado";
final String idStatusChamado = "idStatusChamado";
final String imgChamado = "imgChamado";
final String relatorChamado = "relatorChamado";

class ChamadoConnect {
  static final ChamadoConnect _instance = ChamadoConnect.internal();

  factory ChamadoConnect() => _instance;

  ChamadoConnect.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "chamados.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $chamadosTable($idChamado INTEGER PRIMARY KEY, $tituloChamado TEXT,"
          "$responsavelChamado TEXT, $interacaoChamado TEXT, $idCategoriaChamado INTEGER, $idStatusChamado TEXT,"
          "$relatorChamado TEXT,  $imgChamado TEXT,"
          "FOREIGN KEY($idCategoriaChamado) REFERENCES $idCategoriaChamado($idCategoria),"
          "FOREIGN KEY($idStatusChamado) REFERENCES $idStatusChamado($idStatus))");
    });
  }

  Future<Chamado> saveChamado(Chamado chamado) async {
    Database dbchamado = await db;
    chamado.id = await dbchamado.insert(chamadosTable, chamado.toMap());
    return chamado;
  }

  Future<Chamado> getChamado(int id) async {
    Database dbchamado = await db;
    List<Map> maps = await dbchamado.query(chamadosTable,
        columns: [
          idChamado,
          tituloChamado,
          responsavelChamado,
          interacaoChamado,
          idCategoriaChamado,
          idStatusChamado,
          relatorChamado,
          imgChamado
        ],
        where: "$idChamado = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Chamado.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deletechamado(int id) async {
    Database dbchamado = await db;
    return await dbchamado
        .delete(chamadosTable, where: "$idChamado = ?", whereArgs: [id]);
  }

  Future<int> updatechamado(Chamado chamado) async {
    Database dbchamado = await db;
    return await dbchamado.update(chamadosTable, chamado.toMap(),
        where: "$idChamado = ?", whereArgs: [chamado.id]);
  }

  Future<List> getAllChamados() async {
    Database dbchamado = await db;
    List listMap = await dbchamado.rawQuery(
        "SELECT * FROM $chamadosTable LEFT JOIN $categoriasTable on $idCategoriaChamado = $idCategoria LEFT JOIN $statusTable on $idStatusChamado = $idStatus;");
    List<Chamado> listChamado = [];

    for (Map m in listMap) {
      listChamado.add(Chamado.fromMap(m));
    }
    return listChamado;
  }

  Future<int> getNumber() async {
    Database dbchamado = await db;
    return Sqflite.firstIntValue(
        await dbchamado.rawQuery("SELECT COUNT(*) FROM $chamadosTable"));
  }

  Future<void> dropTable() async {
    Database dbchamado = await db;
    return await dbchamado.rawQuery("DROP TABLE $chamadosTable");
  }

  Future<void> createTable() async {
    Database dbchamado = await db;
    await dbchamado.rawQuery(
        "CREATE TABLE $chamadosTable($idChamado INTEGER PRIMARY KEY, $tituloChamado TEXT,"
        "$responsavelChamado TEXT, $interacaoChamado TEXT, $idCategoriaChamado INTEGER, $idStatusChamado TEXT,"
        "$relatorChamado TEXT,  $imgChamado TEXT,"
        "FOREIGN KEY($idCategoriaChamado) REFERENCES $idCategoriaChamado($idCategoria),"
        "FOREIGN KEY($idStatusChamado) REFERENCES $idStatusChamado($idStatus))");
  }

  Future close() async {
    Database dbchamado = await db;
    dbchamado.close();
  }
}

class Chamado {
  int id;
  String titulo;
  String responsavel;
  String interacao;
  Categoria categoria = Categoria(null, null);
  Status status = Status(null, null);
  String relator;
  String img;

  Chamado();

  Chamado.fromMap(Map map) {
    id = map[idChamado];
    titulo = map[tituloChamado];
    responsavel = map[responsavelChamado];
    interacao = map[interacaoChamado];
    categoria = Categoria.fromMap(map);
    status = Status.fromMap(map);
    relator = map[relatorChamado];
    img = map[imgChamado];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      tituloChamado: titulo,
      responsavelChamado: responsavel,
      interacaoChamado: interacao,
      idCategoriaChamado: categoria.id,
      idStatusChamado: status.id,
      relatorChamado: relator,
      imgChamado: img,
    };

    if (id != null) {
      map[idChamado] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Chamado(id: $id, titulo: $titulo, responsavel: $responsavel, interacao: $interacao, categoria: $categoria, status: $status, relator: $relator, img: $img )";
  }
}
