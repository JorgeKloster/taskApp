import 'package:flutter/material.dart';
import 'package:primeiro_projeto/services/task_service.dart';

import '../models/task_model.dart';

class FormViewTasks extends StatefulWidget {
  final Task? tasks;
  final int? index;

  const FormViewTasks({super.key, this.tasks, this.index});

  @override
  State<FormViewTasks> createState() => _FormViewTasksState();
}

class _FormViewTasksState extends State<FormViewTasks> {
  final _formKey = GlobalKey<FormState>();
  final TaskService TasksService = TaskService();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool _isEdit = false;
  String _priority = "Baixa";

  @override
  void initState() {
    if (widget.tasks != null) {
      _titleController.text = widget.tasks!.title!;
      _descriptionController.text = widget.tasks!.description!;
      _priority =
          widget.tasks!.priority != null ? widget.tasks!.priority! : "Baixa";
      _isEdit = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isEdit ? Text("Criar Nova Tarefa") : Text("Criar Nova Tarefa"),
      ),
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Título Obrigatório";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  decoration: InputDecoration(
                      labelText: "Tarefa",
                      hintText: "Digite o nome da tarefa",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  controller: _titleController,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  decoration: InputDecoration(
                      labelText: "Descrição da Tarefa",
                      hintText: "Digite a descrição da tarefa",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  controller: _descriptionController,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  children: [
                    Text(
                      "Prioridade:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Radio<String>(
                                value: 'Baixa',
                                groupValue: _priority,
                                onChanged: (String? value) {
                                  setState(() {
                                    _priority = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: Text('Baixa'),
                              )
                            ],
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Radio<String>(
                                value: 'Média',
                                groupValue: _priority,
                                onChanged: (String? value) {
                                  setState(() {
                                    _priority = value!;
                                  });
                                },
                              ),
                              Expanded(child: Text('Média'))
                            ],
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Radio<String>(
                                value: 'Alta',
                                groupValue: _priority,
                                onChanged: (String? value) {
                                  setState(() {
                                    _priority = value!;
                                  });
                                },
                              ),
                              Expanded(child: Text('Alta'))
                            ],
                          ),
                          flex: 1,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 130),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String title = _titleController.text;
                    String description = _descriptionController.text;
                    String priority = _priority;

                    if (widget.tasks != null && widget.index != null) {
                      await TasksService.editTask(widget.index!, title,
                          description, widget.tasks!.isDone!, priority);
                    } else {
                      await TasksService.saveTask(
                          title, description, false, priority);
                    }

                    Navigator.pop(context);
                  }
                },
                child: Text(
                  "Salvar Tarefa",
                ),
              )
            ],
          )),
    );
  }
}
