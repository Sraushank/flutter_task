import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/product/product_model.dart';

class DatabaseHelper extends GetxController {
  RxBool isLoading = false.obs;
  RxList<Product> products = <Product>[].obs;
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'product_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productImage TEXT,
        productName TEXT,
        productPrice REAL,
        token TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE products ADD COLUMN token TEXT
      ''');
    }
  }

  Future<int> insertProduct(Product product) async {
    isLoading.value = true;
    final db = await database;
    int result = await db.insert('products', product.toJson());
    await getProducts();
    isLoading.value = false;
    return result;
  }

  Future<void> getProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');

    products.value = List.generate(maps.length, (i) {
      return Product.fromJson(maps[i]);
    });
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
