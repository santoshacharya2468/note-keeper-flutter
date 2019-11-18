class Note{
  String title;
  String body;
  String photo;
 int id;
  Note({
    this.title,
    this.body,
    this.photo
  });
  Note.fromMap(Map<String,dynamic>map){
    this.title=map['title'];
    this.body=map['body'];
    this.photo=map['photo'];
    this.id=map['id'];
  }
  Map<String,dynamic>toJson(){
    Map<String,dynamic>newmap={
      'id':this.id,
      'title':this.title,
      'body':this.body,
      'photo':this.photo
    };
    return newmap;
  }
}