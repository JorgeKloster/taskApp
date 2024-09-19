import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:primeiro_projeto/views/form_view_tasks.dart';
import 'package:primeiro_projeto/views/list_view_tasks.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => AppTeste(),
        "listaDeTarefas": (content) => ListViewTasks(),
        "formDeTarefas": (content) => FormViewTasks(),
      },
      //home: const AppTeste(),
    );
  }
}

class AppTeste extends StatefulWidget {
  const AppTeste({super.key});

  @override
  State<AppTeste> createState() => _AppTesteState();
}

class _AppTesteState extends State<AppTeste> {
  File? _image;
  ImagePicker _picker = ImagePicker();

  pickImage() async {
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (pickedFile != null) {
      prefs.setString('image_path', pickedFile.path);
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('image_path');
    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  @override
  void initState() {
    loadImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
                accountName: Text("Jorge"),
                accountEmail: Text("jfkloster@gmail.com"),
                currentAccountPicture: ClipOval(
                  child: Container(
                    height: 100,
                    width: 100,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Image.asset('assets/tasks.png'),
                    ),
                  ),
                )),
            ListTile(
              title: Text(
                "Lista de Tarefas",
              ),
              leading: Icon(Icons.list),
              onTap: () {
                Navigator.pushNamed(context, "listaDeTarefas");
              },
            ),
            Divider(
              thickness: 2,
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Image.network(
                  'https://www.creativefabrica.com/wp-content/uploads/2021/07/06/Tasks-To-Do-icon-Graphics-14354205-1.jpg'),
              _image != null
                  ? Image.file(
                      _image!,
                      fit: BoxFit.cover,
                      width: 300,
                      height: 300,
                    )
                  : Container(),
              ElevatedButton(
                onPressed: () {
                  pickImage();
                },
                child: Text('Selecionar Imagem da Galeria'),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20, right: 10),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, "formDeTarefas");
                },
                child: Icon(Icons.add),
              ),
            ),
          )
        ],
      ),
    );
  }
}
