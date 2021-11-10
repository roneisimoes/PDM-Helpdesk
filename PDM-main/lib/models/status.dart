import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// id name     email              phone    img
final String statusTable = "statusTable";
final String idStatus = "idStatus";
final String nomeStatus = "nomeStatus";

class StatusConnect {
  static final StatusConnect _instance = StatusConnect.internal();

  factory StatusConnect() => _instance;

  StatusConnect.internal();

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
          "CREATE TABLE $statusTable($idStatus INTEGER PRIMARY KEY, $nomeStatus TEXT)");
    });
  }

  Future<Status> saveStatus(Status status) async {
    Database dbchamado = await db;
    status.id = await dbchamado.insert(statusTable, status.toMap());
    return status;
  }

  Future<Status> getStatus(int id) async {
    Database dbchamado = await db;
    List<Map> maps = await dbchamado.query(statusTable,
        columns: [idStatus, nomeStatus],
        where: "$idStatus = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Status.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deletestatus(int id) async {
    Database dbchamado = await db;
    return await dbchamado
        .delete(statusTable, where: "$idStatus = ?", whereArgs: [id]);
  }

  Future<int> updatestatus(Status status) async {
    Database dbchamado = await db;
    return await dbchamado.update(statusTable, status.toMap(),
        where: "$idStatus = ?", whereArgs: [status.id]);
  }

  Future<List> getAllStatus() async {
    Database dbchamado = await db;
    List listMap = await dbchamado.rawQuery("SELECT * FROM $statusTable");
    List<Status> liststatus = [];

    for (Map m in listMap) {
      liststatus.add(Status.fromMap(m));
    }
    return liststatus;
  }

  Future<int> getNumber() async {
    Database dbchamado = await db;
    return Sqflite.firstIntValue(
        await dbchamado.rawQuery("SELECT COUNT(*) FROM $statusTable"));
  }

  Future<void> dropTable() async {
    Database dbchamado = await db;
    return await dbchamado.rawQuery("DROP TABLE $statusTable");
  }

  Future<void> createTable() async {
    Database dbchamado = await db;
    return await dbchamado.rawQuery(
        "CREATE TABLE $statusTable($idStatus INTEGER PRIMARY KEY, $nomeStatus TEXT)");
  }

  Future close() async {
    Database dbchamado = await db;
    dbchamado.close();
  }
}

class Status {
  int id;
  String nome;

  Status(this.id, this.nome);

  Status.fromMap(Map map) {
    id = map[idStatus];
    nome = map[nomeStatus];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      idStatus: id,
      nomeStatus: nome,
    };

    if (id != null) {
      map[idStatus] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Status(id: $id, nome: $nome )";
  }
}
