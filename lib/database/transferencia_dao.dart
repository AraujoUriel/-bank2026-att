import 'package:sqflite/sqflite.dart';
import '../models/transferencia.dart';
import 'database_helper.dart';

class TransferenciaDao {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> inserir(Transferencia transferencia) async {
    final Database db = await _dbHelper.database;
    return await db.insert(
      'transferencias',
      transferencia.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Transferencia>> buscarTodas() async {
    final Database db = await _dbHelper.database;
    
    final List<Map<String, dynamic>> maps = await db.query('transferencias');
    
    return List.generate(maps.length, (i) {
      return Transferencia.fromMap(maps[i]);
    });
  }

  Future<int> deletar(int id) async {
    final Database db = await _dbHelper.database;
    return await db.delete(
      'transferencias',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}