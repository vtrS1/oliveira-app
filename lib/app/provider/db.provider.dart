import 'dart:async';
import 'dart:io';
import 'package:oliveira_fotos/app/utils/consts.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database? _database;
  int version = 1;
  List<String> tables = [
    Constants.DB_IMAGES,
    Constants.DB_OS,
    Constants.DB_CONTATOS,
    Constants.DB_PARCELAS,
    Constants.DB_FORMA_PAGAMENTOS,
    Constants.DB_BOLETOS,
    Constants.DB_RESPONSAVEL,
    Constants.DB_NEGATIVADOS,
    Constants.DB_ESTADOS,
    Constants.DB_CIDADES
  ];

  FutureOr<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  get convert => null;

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + "oliveira.db";
    return await openDatabase(path,
        version: version, onOpen: (db) {}, onCreate: _createDb);
  }

  Future<String> getDbLocation() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = documentsDirectory.path + "oliveira.db";
    return path;
  }

  Future<String?> getDbBKPLocation() async {
    Directory? documentsDirectory = await getExternalStorageDirectory();
    if (documentsDirectory != null) {
      return documentsDirectory.path + "oliveira.db";
    }
    return null;
  }

  Future resetDb() async {
    print("RESET DB");
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS ${Constants.DB_IMAGES}');
    await db.execute('DROP TABLE IF EXISTS ${Constants.DB_OS}');
    await db.execute('DROP TABLE IF EXISTS ${Constants.DB_CONTATOS}');
    await db.execute('DROP TABLE IF EXISTS ${Constants.DB_PARCELAS}');
    await db.execute('DROP TABLE IF EXISTS ${Constants.DB_FORMA_PAGAMENTOS}');
    await db.execute('DROP TABLE IF EXISTS ${Constants.DB_BOLETOS}');
    await db.execute('DROP TABLE IF EXISTS ${Constants.DB_RESPONSAVEL}');
    await db.execute('DROP TABLE IF EXISTS ${Constants.DB_NEGATIVADOS}');
    await db.execute('DROP TABLE IF EXISTS ${Constants.DB_ESTADOS}');
    await db.execute('DROP TABLE IF EXISTS ${Constants.DB_CIDADES}');
  }

  Future<void> clearTables() async {
    final db = await database;
    await db.execute('DELETE FROM ${Constants.DB_IMAGES} WHERE 1');
    await db.execute('DELETE FROM ${Constants.DB_OS} WHERE 1');
    await db.execute('DELETE FROM ${Constants.DB_CONTATOS} WHERE 1');
    await db.execute('DELETE FROM ${Constants.DB_PARCELAS} WHERE 1');
    await db.execute('DELETE FROM ${Constants.DB_FORMA_PAGAMENTOS} WHERE 1');
    await db.execute('DELETE FROM ${Constants.DB_BOLETOS} WHERE 1');
    await db.execute('DELETE FROM ${Constants.DB_RESPONSAVEL} WHERE 1');
    await db.execute('DELETE FROM ${Constants.DB_NEGATIVADOS} WHERE 1');
    await db.execute('DELETE FROM ${Constants.DB_ESTADOS} WHERE 1');
    await db.execute('DELETE FROM ${Constants.DB_CIDADES} WHERE 1');
  }

  Future<void> _createDb(Database db, int version) async {
    print('Criando tabela ${Constants.DB_IMAGES}');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${Constants.DB_IMAGES} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_lista_aluno INTEGER NULL,
        id_ficha INTEGER NOT NULL,
        contrato TEXT NOT NULL,
        numero TEXT NOT NULL,
        tipo TEXT NOT NULL,
        tipo_imagem NOT NULL,
        src TEXT NOT NULL,
        status INTEGER DEFAULT 0
      )
    ''');

    print('Criando tabela ${Constants.DB_OS}');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${Constants.DB_OS} (
        id INTEGER PRIMARY KEY,
        listas_id INTEGER,
        listas_data_inicio TEXT NULL,
        listas_data_conclusao TEXT NULL,
        listas_id_vendedor INTEGER,
        pessoas_id INTEGER,
        pessoas_nome TEXT NULL,
        testemunha1_nome TEXT NULL,
        testemunha2_nome TEXT NULL,
        pessoas_nome_pai TEXT NULL,
        pessoas_nome_mae TEXT NULL,
        pessoas_logradouro TEXT NULL,
        pessoas_numero TEXT NULL,
        pessoas_referencia TEXT NULL,
        pessoas_cep TEXT NULL,
        end_estados_nome TEXT NULL,
        end_cidades_nome TEXT NULL,
        end_bairros_nome TEXT NULL,
        fichas_id INTEGER,
        fichas_contrato TEXT,
        fichas_numero TEXT,
        fichas_qtd_foto INTEGER,
        instituicoes_nome TEXT NULL,
        instituicoes_logradouro TEXT NULL,
        instituicoes_cep TEXT NULL,
        tipos_nome TEXT NULL,
        obs TEXT NULL,
        motivo TEXT NULL,
        status INTEGER DEFAULT 0
      )
    ''');

    print('Criando tabela ${Constants.DB_RESPONSAVEL}');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${Constants.DB_RESPONSAVEL} (
        id INTEGER PRIMARY KEY,
        os INTEGER,
        nome TEXT NULL,
        cpf TEXT NULL,
        logradouro TEXT NULL,
        numero TEXT NULL,
        referencia TEXT NULL,
        cep TEXT NULL
      )
    ''');

    print('Criando tabela ${Constants.DB_CONTATOS}');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${Constants.DB_CONTATOS} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        id_contato INTEGER NULL,
        id_pessoa INTEGER NULL,
        os INTEGER,
        contato TEXT,
        id_tipo_contato INTEGER NULL,
        status INTEGER DEFAULT 1,
        tipo_contatos_nome TEXT
      )''');

    print('Criando tabela ${Constants.DB_FORMA_PAGAMENTOS}');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${Constants.DB_FORMA_PAGAMENTOS} (
        id INTEGER PRIMARY KEY,
        entrada INTEGER NULL,
        nome TEXT,
        parcela INTEGER,
        status INTEGER DEFAULT 1
      )''');

    print('Criando tabela ${Constants.DB_PARCELAS}');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${Constants.DB_PARCELAS} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      id_boleto INTEGER NULL,
      nosso_numero INTEGER NULL,
      os INTEGER,
      parcela INTEGER,
      valor TEXT,
      valorUnitario TEXT,
      valorEntrada TEXT,
      dataInicial TEXT NULL,
      dataNascimento TEXT NULL,
      qtdParcela INTEGER,
      nome TEXT,
      cpf TEXT,
      rg TEXT,
      id_forma_pagamento INTEGER)
    ''');

    print('Criando tabela ${Constants.DB_BOLETOS}');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${Constants.DB_BOLETOS} (
      id INTEGER PRIMARY KEY,
      os INTEGER,
      nosso_numero INTEGER,
      id_venda INTEGER,
      id_venda_parcela INTEGER,
      status INTEGER DEFAULT 1)
    ''');

    print('Criando tabela ${Constants.DB_NEGATIVADOS}');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${Constants.DB_NEGATIVADOS} (
      id INTEGER PRIMARY KEY,
      cpf TEXT)
    ''');

    print('Criando tabela ${Constants.DB_ESTADOS}');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${Constants.DB_ESTADOS} (
      id INTEGER PRIMARY KEY,
      sigla TEXT,
      nome TEXT)
    ''');

    print('Criando tabela ${Constants.DB_CIDADES}');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${Constants.DB_CIDADES} (
      id INTEGER PRIMARY KEY,
      id_estado INTEGER,
      nome TEXT)
    ''');

    print('Criando tabela ${Constants.DB_PARAMETROS}');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${Constants.DB_PARAMETROS} (
      id INTEGER PRIMARY KEY,
      grupo TEXT NULL,
      subgrupo TEXT NULL,
      valor TEXT NULL,
      detalhe TEXT NULL,
      status INTEGER DEFAULT 1,
      updated_at TEXT NULL,
      created_at TEXT NULL)
    ''');

    print('Criando tabela ${Constants.DB_TIPO_CONTATOS}');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS ${Constants.DB_TIPO_CONTATOS} (
      id INTEGER PRIMARY KEY,
      nome TEXT,
      mascara TEXT NULL,
      status INTEGER DEFAULT 1,
      updated_at TEXT NULL,
      created_at TEXT NULL)
    ''');
  }

  Future initTables(int version) async {
    final db = await database;
    await this._createDb(db, version);
  }

  FutureOr<List<Map>> selectById(String table, int id) async {
    final db = await database;
    List<Map<String, dynamic>> res =
        await db.query(table, where: "id = ?", whereArgs: [id]);
    return res;
  }

  FutureOr<List<Map>> searchOs(String table, String key) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.query(table,
        where:
            'pessoas_nome LIKE "%$key%" OR id = "$key" OR fichas_id = "$key"');
    return res;
  }

  FutureOr<List<Map>> selectByCpf(String table, String cpf) async {
    final db = await database;
    List<Map<String, dynamic>> res =
        await db.query(table, where: "cpf = ?", whereArgs: [cpf]);
    return res;
  }

  FutureOr<List<Map>> selectByLista(String table, int id) async {
    final db = await database;
    List<Map<String, dynamic>> res =
        await db.query(table, where: "listas_id = ?", whereArgs: [id]);
    return res;
  }

  FutureOr<List<Map>> selectByContrato(
      String table, int id, String tipo) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.query(table,
        where: "contrato = ? AND tipo = ?", whereArgs: [id, tipo]);
    return res;
  }

  FutureOr<List<Map>> selectByOs(String table, int os) async {
    final db = await database;
    List<Map<String, dynamic>> res =
        await db.query(table, where: "os = ?", whereArgs: [os]);
    return res;
  }

  FutureOr<List<Map>> selectImagesByOs(String table, int os) async {
    final db = await database;
    List<Map<String, dynamic>> res =
        await db.query(table, where: "id_lista_aluno = ?", whereArgs: [os]);
    return res;
  }

  FutureOr<List<Map>> selectByContratoNumeroTipo(
      String table, int contrato, int numero, String tipo) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.query(table,
        where: "contrato = ? AND numero = ? AND tipo = ?",
        whereArgs: [contrato, numero, tipo]);
    return res;
  }

  FutureOr<List<Map>> selectOsByContratoNumeroTipo(
      String table, int contrato, String numero, String tipo) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.query(table,
        where: "contrato = ? AND numero = ? AND tipo = ?",
        whereArgs: [contrato, numero, tipo]);
    return res;
  }

  FutureOr<List<Map>> selectByContratoNumeroTipoTipoImagem(String table,
      String? contrato, String? numero, String? tipo, String tipoImagem) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.query(table,
        where: "contrato = ? AND numero = ? AND tipo = ? AND tipo_imagem = ?",
        whereArgs: [contrato, numero, tipo, tipoImagem]);
    return res;
  }

  FutureOr<List<Map>> selectContratosValidos(String table) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db
        .rawQuery('SELECT * FROM $table GROUP BY contrato, numero, tipo');
    return res;
  }

  FutureOr<List<Map>> selectByTipo(String table, String tipo) async {
    final db = await database;
    List<Map<String, dynamic>> res =
        await db.query(table, where: "tipo = ?", whereArgs: [tipo]);
    return res;
  }

  FutureOr<List<Map>> selectByStatus(String table, int status) async {
    final db = await database;
    List<Map<String, dynamic>> res =
        await db.query(table, where: "status = ?", whereArgs: [status]);
    return res;
  }

  FutureOr<List<Map>> selectByTipoImagem(String table, String tipo) async {
    final db = await database;
    List<Map<String, dynamic>> res =
        await db.query(table, where: "tipo_imagem = ?", whereArgs: [tipo]);
    return res;
  }

  FutureOr<List<Map>> selectByTipoAndTipoImagem(
      String table, String tipo, String tipoImagem) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.query(table,
        where: "tipo = ? AND tipo_imagem = ?", whereArgs: [tipo, tipoImagem]);
    return res;
  }

  FutureOr<List<Map>> selectAll(String table) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.query(table);
    return res;
  }

  FutureOr<int> qtd(String table) async {
    final db = await database;
    List<Map<String, dynamic>> res = await db.query(table);
    return res.length;
  }

  Future deleteById(String table, int? id) async {
    final db = await database;
    return db.delete(table, where: "id = ?", whereArgs: [id]);
  }

  Future deleteByContratoNumeroAndTipo(
      String table, String? contrato, String? numero, String tipo) async {
    final db = await database;
    return db.delete(table,
        where: "contrato = ? AND numero = ? AND tipo = ?",
        whereArgs: [contrato, numero, tipo]);
  }

  Future deleteByStatus(String table, int status) async {
    final db = await database;
    return db.delete(table, where: "status = ?", whereArgs: [status]);
  }

  Future deleteByOs(String table, int os) async {
    final db = await database;
    return db.delete(table, where: "os = ?", whereArgs: [os]);
  }

  Future deleteByIdListaAluno(String table, int os) async {
    final db = await database;
    return db.delete(table, where: "id_lista_aluno = ?", whereArgs: [os]);
  }

  Future deleteByContratoNumeroTipoAndTipoImagem(String table, String? contrato,
      String? numero, String? tipo, String tipoImagem) async {
    final db = await database;
    return db.delete(table,
        where: "contrato = ? AND numero = ? AND tipo = ? AND tipo_imagem = ?",
        whereArgs: [contrato, numero, tipo, tipoImagem]);
  }

  Future deleteAll(String table) async {
    final db = await database;
    return await db.delete(table);
  }

  insert(String table, dynamic object, {bool replace = false}) async {
    final db = await database;
    try {
      var raw = await db.insert(
        table,
        object.toDb(),
        conflictAlgorithm:
            replace ? ConflictAlgorithm.replace : ConflictAlgorithm.ignore,
      );
      return raw;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return 0;
    }
  }

  FutureOr<int> update(String table, dynamic object) async {
    Database db = await database;
    int count = await db
        .update(table, object.toDb(), where: 'id=?', whereArgs: [object.id]);
    return count;
  }

  FutureOr<int> updateStatus(String table, int id, int status) async {
    Database db = await database;
    int count = await db.update(table, {'status': status},
        where: 'id=?', whereArgs: [id]);
    return count;
  }

  Future<String?> generateBackup() async {
    String path = await getDbLocation();
    return path;
  }
}
