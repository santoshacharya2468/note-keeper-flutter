import 'dart:io';
import 'package:flutter/material.dart';
import 'models/database_helper.dart';
import 'models/Note.dart';
import 'add_notes.dart';
void main(){
  runApp(
    new MaterialApp(
      home: new HomeScreen(),
    )
  );
}
class Navbar extends StatefulWidget {
final String title;
final Widget body;
final Widget leading;
  Navbar({
    this.title,
    this.body,
    this.leading,
  });
  @override
  _NavbarState createState() => _NavbarState();
}
class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: new AppBar(
        backgroundColor: Colors.redAccent,
        title: new Text(widget.title), 
        leading: widget.leading,

      ),
    body:new Container(
      padding: EdgeInsets.all(5.0),
      child:widget.body),  
    floatingActionButton: new FloatingActionButton(
      onPressed: (){
        Navigator.push(context, new MaterialPageRoute(
          builder: (BuildContext context)=>new AddNote()
        ));
      },
      child: new Icon(Icons.add),
      backgroundColor: Colors.blue[600],
    ), 
    );
  }
}
class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}
class HomeScreenState extends State<HomeScreen> {
DatabaseHelper databaseHelper=new DatabaseHelper();
  List<Note>allNotes=[];
  @override
  void initState(){
    super.initState();
    getAllNotes();
  }
  void getAllNotes() async{
    var result=await databaseHelper.getAllNotes();
    setState(() {
     allNotes=result; 
     
    });
  }
  deleteNote(Note note) async{
 await databaseHelper.deleteNote(note);
getAllNotes();
  }
  @override
  Widget build(BuildContext context) {
    return Navbar(
      title: 'Mynotes',
      leading: new IconButton(onPressed: (){
        getAllNotes();
      },icon: Icon(Icons.refresh),),
      body: new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemCount:allNotes==null ?0: allNotes.length,
        itemBuilder: (BuildContext context,int index){
          return new ListTile(
            onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                builder: (BuildContext context)=>new DetailScreen(allNotes[index])
              ));
            },
            title: new Text(allNotes[index].title),
            subtitle: new Text(allNotes[index].body),
           leading: setImage(allNotes[index].photo),
           trailing: new GestureDetector(
             child: new Icon(Icons.delete),
             onTap: (){
               deleteNote(allNotes[index]);
             },
           )
           
          );
        },
      )
      ),   
    );
  }
  Widget setImage(String path){
    if(path==null){
      return new CircleAvatar(
        child: new Icon(Icons.broken_image),
      );
    }
    File file=new File(path);
    Image img=new Image.file(file);
    return img;
   
  }
}
class DetailScreen extends StatefulWidget {
  final Note note;
  DetailScreen(this.note);
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
    Widget setImage(String path){
    if(path==null){
      return new CircleAvatar(
        child: new Icon(Icons.broken_image),
      );
    }
    File file=new File(path);
    Image img=new Image.file(file);
    return img;
   
  }
  @override
  Widget build(BuildContext context) {
    return Navbar(
      title: 'Detail Page',
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Container(
              child: setImage(widget.note.photo),
            ),
           new Card(
             child: new Column(children: <Widget>[
                new Text(widget.note.title),
                new Text(widget.note.body),
                
             ],),
           )
          ],
        )
        
      ),
      
    );
  }
}