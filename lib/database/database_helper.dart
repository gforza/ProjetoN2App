import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;
  
  Future<Database> get db async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = await getDatabasesPath();
    path = join(path, 'forca_vendas.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreateDB,
      onUpgrade: _onUpgradeDB,
    );
  }

  Future<void> _onCreateDB(Database db, int version) async {
    // Tabela de Usuários
    await db.execute('''
      CREATE TABLE usuarios(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        senha TEXT NOT NULL,
        ultimaAlteracao TEXT
      )
    ''');

    // Tabela de Clientes
    await db.execute('''
      CREATE TABLE clientes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        tipo TEXT NOT NULL,
        cpfCnpj TEXT,
        email TEXT,
        telefone TEXT,
        cep TEXT,
        endereco TEXT,
        bairro TEXT,
        cidade TEXT,
        uf TEXT,
        ultimaAlteracao TEXT
      )
    ''');

    // Tabela de Produtos
    await db.execute('''
      CREATE TABLE produtos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        unidade TEXT NOT NULL,
        qtdEstoque REAL,
        precoVenda REAL,
        status TEXT,
        custo REAL,
        codigoBarra TEXT,
        ultimaAlteracao TEXT
      )
    ''');

    // Tabela de Pedidos
    await db.execute('''
      CREATE TABLE pedidos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idCliente INTEGER,
        idUsuario INTEGER,
        totalPedido REAL,
        ultimaAlteracao TEXT,
        FOREIGN KEY (idCliente) REFERENCES clientes (id),
        FOREIGN KEY (idUsuario) REFERENCES usuarios (id)
      )
    ''');

    // Tabela de Itens do Pedido
    await db.execute('''
      CREATE TABLE itens_pedido(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idPedido INTEGER,
        idProduto INTEGER,
        quantidade REAL,
        precoUnitario REAL,
        totalItem REAL,
        FOREIGN KEY (idPedido) REFERENCES pedidos (id),
        FOREIGN KEY (idProduto) REFERENCES produtos (id)
      )
    ''');

    // Tabela de Pagamentos
    await db.execute('''
      CREATE TABLE pagamentos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idPedido INTEGER,
        formaPagamento TEXT,
        valor REAL,
        FOREIGN KEY (idPedido) REFERENCES pedidos (id)
      )
    ''');
  }

  Future<void> _onUpgradeDB(Database db, int oldVersion, int newVersion) async {
    // Implementar migrações futuras aqui
  }

  Future<void> close() async {
    final database = await db;
    await database.close();
  }
} 