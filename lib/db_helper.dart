import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static DBHelper getInstance() => DBHelper._();

  static const String TABLE_NOTE_NAME = "note";
  static const String COLUMN_NOTE_ID = "id";
  static const String COLUMN_NOTE_TITLE = 'title';
  static const String COLUMN_NOTE_DESC = 'desc';

  Database? mDB;

  getDB() async {
    if (mDB != null) {
      return mDB!;
    } else {
      mDB = await openDB();
      return mDB!;
    }
  }

  // create Data Base

  Future<Database> openDB() async {
    var appDir = await getApplicationDocumentsDirectory();
    var dbpath = join(appDir.path, "Note.db");

    return openDatabase(dbpath, version: 1, onCreate: (db, version) {
      db.execute(
          "create table $TABLE_NOTE_NAME ( $COLUMN_NOTE_ID integer primary key autoincrement, $COLUMN_NOTE_TITLE text, $COLUMN_NOTE_DESC text)");
    });
  }

  // insert Table
  Future<bool> addNote({required String title, required String desc}) async {
    var db = await getDB();
    int rowsEffected = await db.insert(
        TABLE_NOTE_NAME, {COLUMN_NOTE_TITLE: title, COLUMN_NOTE_DESC: desc});

    return rowsEffected > 0;
  }

//get Data
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var db = await getDB();

    List<Map<String, dynamic>> mData = await db.query(TABLE_NOTE_NAME);
    return mData;
  }

//Update Data
  Future<bool> updateNote(
      {required String Updatedtitle,
      required String Updateddesc,
      required int id}) async {
    var db = await getDB();
    int rowsEffected = await db.update(TABLE_NOTE_NAME,
        {COLUMN_NOTE_TITLE: Updatedtitle, COLUMN_NOTE_DESC: Updateddesc},
        where: "$COLUMN_NOTE_ID  = $id");

    return rowsEffected > 0;
  }

  Future<bool> deleteNote({required int id}) async {
    var db = await getDB();
    int rowsEffected = await db.delete(TABLE_NOTE_NAME,
        where: /*"$COLUMN_NOTE_ID = $id"*/ "$COLUMN_NOTE_ID= ?",
        whereArgs: ['$id']);
    return rowsEffected > 0;
  }
}
