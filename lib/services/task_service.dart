import 'dart:convert';

import 'package:primeiro_projeto/models/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskService {
  Future<void> saveTask(
      String title, String description, bool isDone, String priority) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];
    Task task =
        Task(title: title, description: description, priority: priority);
    tasks.add(jsonEncode(task));
    await prefs.setStringList('tasks', tasks);
  }

  getTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskStrings = prefs.getStringList('tasks') ?? [];
    List<Task> tasks =
        taskStrings.map((task) => Task.fromJson(jsonDecode(task))).toList();
    return tasks;
  }

  deleteTask(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskStrings = prefs.getStringList('tasks') ?? [];
    taskStrings.removeAt(index);
    await prefs.setStringList('tasks', taskStrings);
  }

  editTask(int index, String title, String description, bool isDone,
      String priority) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasksString = prefs.getStringList('tasks') ?? [];
    Task updateTask = Task(
        title: title,
        description: description,
        isDone: isDone,
        priority: priority);
    tasksString[index] = jsonEncode(updateTask.toJson());
    await prefs.setStringList('tasks', tasksString);
  }

  editTaskIsDone(int index, bool isDoen) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];

    Task alreadyExistsTask = Task.fromJson(jsonDecode(tasks[index]));

    alreadyExistsTask.isDone = isDoen;

    tasks[index] = jsonEncode(alreadyExistsTask.toJson());
    print("Editou isDone");
  }
}
