import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:notes/models/Note.dart';
class DatabaseHelper{
String id='id';
String title='title';
String body='body';
String photo='photo';
Database _db;
  final String dbtable='notes';
  Future<Database> get database async{
    if(_db==null){
    Database db=await setupDatabase();
    _db=db;
    }
    return _db;
  }
   void createDb(Database db,int verison) async {
      
       await db.execute('CREATE TABLE $dbtable($id INTEGER PRIMARY KEY AUTOINCREMENT,$title TEXT,$body TEXT,$photo TEXT)');
        }
 Future<Database> setupDatabase() async {
    Directory directory=await getApplicationDocumentsDirectory();
    final String dbname='mynotes.db';
    String dbpath=directory.path+'/$dbname';
    var databasenote=await openDatabase(
      dbpath,version: 1,onCreate: createDb
    );
    return databasenote;
  }
  Future<List<Note>> getAllNotes() async {
    List<Note>notes=[];
    var dbs=await database;
   var queryresult=await  dbs.rawQuery('SELECT * FROM $dbtable ORDER BY id DESC');
   for(var result in queryresult){
     Note n=new Note.fromMap(result);
     notes.add(n);
   }
   return notes;
  }
  Future<int> addNote(Note note) async{
     var dbs=await database;
     int id=await dbs.insert(dbtable, note.toJson());
     return id;
  }
  Future<bool> deleteNote(Note note) async{
     var dbs=await database;
     try{
      await  dbs.delete(dbtable,where:'$id=?',whereArgs:[note.id]);
        File existingfile=new File(note.photo);
        if(await existingfile.exists()){
          existingfile.deleteSync();
        }
        else{
          

        }
      //await dbs.rawQuery('DELETE * FROM $dbtable WHERE $id=$note.id ');
      return true;
     }
     catch(Exception){
        return false;
     }
  }
}