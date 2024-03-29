import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; //facilita para files

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _toDoController = TextEditingController();
  List _toDoList = [];

  void __addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _toDoController.text;
      _toDoController.text = ""; //depois q clicar zera o botao
      newToDo["ok"] = false;
      _toDoList.add(newToDo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  //deixa ele no tamanho maximo possivel e o botao pequeno
                  child: TextField(
                    controller: _toDoController,
                    decoration: InputDecoration(
                        labelText: "Nova Tarefa",
                        labelStyle: TextStyle(color: Colors.blueAccent)),
                  ),
                ),
                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text("ADD"),
                  textColor: Colors.white,
                  onPressed: __addToDo,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: _toDoList.length,
                itemBuilder: (context, index) {
                  //index -> elemento q esta desenhando no momento
                  return CheckboxListTile(
                    title: Text(_toDoList[index]["title"]),
                    value: _toDoList[index]["ok"],
                    secondary: CircleAvatar(
                      child: Icon(
                          _toDoList[index]["ok"] ? Icons.check : Icons.error),
                    ),
                    onChanged: (c){
                      setState(() {
                        _toDoList[index]["ok"] = c;
                      });
                    },
                  );
                }),
          )
        ],
      ),
    );
  }

  Future<File> _getFile() async {
    //pegar dados
    final directory = await getApplicationDocumentsDirectory();
    return File(
        "${directory.path}/data.json"); //data = nome do arquivo (peguei o local onde pego os documentos + nomequalquer.json)
  }

  Future<File> _saveData() async {
    //salvar dados
    String data = json.encode(
        _toDoList); // pegando lista e transformando em JSON e logo depois armazenando em string
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file =
          await _getFile(); //pegar arquivo e tentar ler o arquivo como string

      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
