import 'package:emdad/data/model/response/cart_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DBHelper {

  static Database _db;

  Future<Database> get db async {
    if(_db != null) {
      return _db;
    }
    _db = await initDataBase();
    return _db;
  }

  initDataBase() async{
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'cartModel.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate,);
    return db;
  }
  _onCreate(Database db, int version) async{
      await db.execute(
        'CREATE TABLE cartModel(id INTEGER PRIMARY KEY, name TEXT, imageUrl TEXT, price TEXT, quantity INTEGER, totalPrice TEXT, shippingCharge TEXT, vendorId TEXT)'
      );
  }

  Future<CartModel> insert(CartModel cartData) async{
    var dbClient = await db;
    await dbClient.insert('cartModel', cartData.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return cartData;
  }

  Future<List<CartModel>> getCartList() async{
    var dbClient = await db;
    final List<Map<String, Object>> quaryResult = await dbClient.query('cartModel') ;
    return quaryResult.map((e) => CartModel?.fromMap(e)).toList();

  }
  Future<int> delete(int id)async{
    var dbClient = await db ;
    return await dbClient.delete(
        'cartModel',
        where: 'id = ?',
        whereArgs: [id]
    );
  }

  Future<int> updateQuantity(CartModel cart)async{
    var dbClient = await db ;
    return await dbClient.update(
        'cart',
        cart.toMap(),
        where: 'id = ?',
        whereArgs: [cart.id]
    );
  }
}
