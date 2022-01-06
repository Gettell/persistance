import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

void main() {
  runApp(const MyPathProvider());
}

class MyPathProvider extends StatelessWidget {
  const MyPathProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(
          storage: LoginStorage()),
    );
  }
}

class LoginStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/login.txt');
  }

  Future<String> readLogin() async {
    try {
      final file = await _localFile;

      final contents = await file.readAsString();

      return contents;
    } catch (e) {

      return "";
    }
  }

  Future<File> writeLogin(String login) async {
    final file = await _localFile;

    return file.writeAsString('$login');
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.storage}) : super(key: key);

  final LoginStorage storage;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _login = ' ';

  @override
  void initState() {
    super.initState();
    widget.storage.readLogin().then((value) {
      setState(() {
        _login = value;
        myController.text = _login;
      });
    });
  }

  Future<File> _setLogin() {
    setState(() {});

    _login = myController.text;
   showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Добро пожаловать, ${myController.text}'),
          );}
    );

    return widget.storage.writeLogin(_login);
  }

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Path Provider Demo'),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 60,),
              const Text('Введите логин'),
              SizedBox(height: 20,),
              SizedBox(
                width: 224,
                child: TextField(controller: myController),
              ),
              SizedBox(height: 20,),
              SizedBox(height: 28,),
              SizedBox(
                  width: 154,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: _setLogin,
                    child: Text('Войти'),
                  )),
              //SizedBox(height: 32,),
              //InkWell(child: const Text('Регистрация',
              //  style: linkTextStyle,
              //),
              //    onTap: () {}),
              //SizedBox(height: 20,),
              //InkWell(child: const Text('Забыли пароль?',
              //  style: linkTextStyle,
              //), onTap: () {}),
            ],
          ),
        ));
  }
}