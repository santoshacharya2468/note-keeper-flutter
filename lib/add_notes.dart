import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:notes/main.dart';
import 'package:notes/models/Note.dart';
import 'models/database_helper.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  String noteTitle;
  String noteBody;
  String notePhoto;
  File _image;
  bool imagepickererror = false;
  TextEditingController titlecontroller = new TextEditingController();
  TextEditingController bodycontroller = new TextEditingController();
  DatabaseHelper databaseHelper = new DatabaseHelper();
  void getImageFromPhone() async {
    File image;
    try {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        imagepickererror = true;
      } else {
        setState(() {
          _image = image;
          imagepickererror = false;
        });
      }
    } catch (Exception) {
      imagepickererror = true;
    }
  }

  void getImageFromCamera() async {
    File image;
    try {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
      if (image == null) {
        imagepickererror = true;
      } else {
        setState(() {
          _image = image;
          imagepickererror = false;
        });
      }
    } catch (Exception) {
      imagepickererror = true;
    }
  }

  setNoteImage() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String filename = DateTime.now().toString() + '.jpg';
    File newphoto = new File(directory.path + '/$filename');

    try {
      newphoto.writeAsBytesSync(_image.readAsBytesSync());
      setState(() {
        notePhoto = directory.path + '/$filename';
      });
    } catch (Exception) {}
  }

  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Navbar(
        title: 'Add a note',
        body: new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new TextFormField(
                controller: titlecontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Title',
                    hintText: 'Enter the title for note'),
                validator: (String data) {
                  if (data.isEmpty) {
                    return 'Title canot be empty';
                  } else {
                    return null;
                  }
                },
                onChanged: (String data) {
                  setState(() {
                    this.noteTitle = data;
                  });
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              new TextFormField(
                controller: bodycontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Descriptions',
                    hintText: 'Enter descriptions of the note'),
                validator: (String data) {
                  if (data.isEmpty) {
                    return 'Description  canot be empty';
                  } else {
                    return null;
                  }
                },
                onChanged: (String data) {
                  setState(() {
                    this.noteBody = data;
                  });
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              imagepickererror == true
                  ? new Text(
                      'Error taking image',
                      style: new TextStyle(color: Colors.red),
                    )
                  : new Text(
                      'Take a picture',
                      style: new TextStyle(fontSize: 20.0),
                    ),
              new Row(
                children: <Widget>[
                  new Expanded(
                      child: new RaisedButton(
                    onPressed: () {
                      getImageFromPhone();
                    },
                    child: new Text('Choose from gallery'),
                    color: Colors.red,
                  )),
                  SizedBox(
                    width: 5.0,
                  ),
                  new Expanded(
                    child: new RaisedButton(
                      onPressed: () {
                        getImageFromCamera();
                      },
                      child: new Text('Take a new'),
                      color: Colors.red,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              new RaisedButton(
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    if (_image != null) {
                      await setNoteImage();
                      Note newNote = new Note(
                          title: this.noteTitle,
                          body: this.noteBody,
                          photo: this.notePhoto);
                      await databaseHelper.addNote(newNote);
                      titlecontroller.text = '';
                      bodycontroller.text = '';
                    } else {
                      setState(() {
                        imagepickererror = true;
                      });
                    }
                  } else {}
                },
                color: Colors.lightBlue,
                elevation: 4.0,
                child: new Text('Save'),
              )
            ],
          ),
        ));
  }
}
