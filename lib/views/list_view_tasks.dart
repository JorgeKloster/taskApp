import 'package:flutter/material.dart';
import 'package:primeiro_projeto/services/task_service.dart';
import 'package:primeiro_projeto/views/form_view_tasks.dart';

import '../models/task_model.dart';

class ListViewTasks extends StatefulWidget {
  const ListViewTasks({super.key});

  @override
  State<ListViewTasks> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ListViewTasks> {
  TaskService TasksService = TaskService();
  List<Task> tasks = [];

  getAllTasks() async {
    tasks = await TasksService.getTasks();

    setState(() {});
  }

  @override
  void initState() {
    getAllTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de Tarefas'),
        ),
        body: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              bool localIsDone = tasks[index].isDone ?? false;
              return Card(
                  color: Colors.grey[300],
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tasks[index].title.toString(),
                              style: TextStyle(
                                  decoration: localIsDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                  decorationColor:
                                      localIsDone ? Colors.red : null,
                                  color: localIsDone
                                      ? Colors.grey
                                      : Colors.green[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28),
                            ),
                            Checkbox(
                                value: tasks[index].isDone ?? false,
                                onChanged: (value) {
                                  if (value != null) {
                                    TasksService.editTaskIsDone(index, value);
                                  }

                                  setState(() {
                                    tasks[index].isDone = value;
                                  });
                                }),
                          ],
                        ),
                        Text(tasks[index].description.toString()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () async {
                                if (localIsDone) {
                                  return;
                                }
                                await TasksService.deleteTask(index);
                                getAllTasks();
                              },
                              icon: Icon(Icons.delete),
                            ),
                            localIsDone
                                ? new Container()
                                : IconButton(
                                    onPressed: () async {
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FormViewTasks(
                                                        tasks: tasks[index],
                                                        index: index,
                                                      )))
                                          .then((value) => getAllTasks());
                                    },
                                    icon: Icon(Icons.edit))
                          ],
                        ),
                        Text("Prioridade: " + tasks[index].priority.toString())
                      ],
                    ),
                  ));
            }));
  }
}
