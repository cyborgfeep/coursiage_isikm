import 'package:coursiage_isikm/models/favorite_contacts.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:sqflite/sqflite.dart';

class ContactProvider {
  late Database db;

  Future open(String path) async {
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
create table $tableContact ( 
  $columnId integer primary key autoincrement, 
  $columnName text not null,
  $columnPhone text not null)
''');
      },
    );
  }

  Future<FavoriteContact> insert(FavoriteContact contact) async {
    FavoriteContact? c = await getContact(contact.phone!);
    if (c == null) {
      contact.id = await db.insert(tableContact, contact.toMap());
    }
    return contact;
  }

  Future<List<FavoriteContact>> getFavoriteList() async {
    List<FavoriteContact> fav = [];
    List<Map> maps = await db.query(tableContact);
    if (maps.isNotEmpty) {
      for (var map in maps) {
        fav.add(FavoriteContact.fromMap(map));
      }
      return fav;
    }
    return [];
  }

  Future<int> delete(int id) async {
    return await db.delete(
      tableContact,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> update(FavoriteContact contact) async {
    return await db.update(
      tableContact,
      contact.toMap(),
      where: '$columnId = ?',
      whereArgs: [contact.id],
    );
  }

  Future<FavoriteContact?> getContact(String phone) async {
    List<Map> maps = await db.query(
      tableContact,
      columns: [columnId],
      where: '$columnPhone = ?',
      whereArgs: [phone],
    );
    if (maps.isNotEmpty) {
      return FavoriteContact.fromMap(maps.first);
    }
    return null;
  }

  Future close() async => db.close();
}
