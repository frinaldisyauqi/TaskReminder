import 'package:get/get.dart';
import 'package:todo/db/db_helper.dart';
import '../models/task.dart';

class TaskController extends GetxController {
  final taskList = [].obs;

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task!);
  }

  Future<void> getTask() async {
    // get Date from DB
    final List<Map<String, dynamic>> tasks = await DBHelper.query();

    // ادخال البيانات المجلوبه من الداتا بيز و تخزينها في متغير لاستخدامها
    taskList.assignAll(tasks.map((item) => Task.fromJson(item)).toList());
  }

  void deleteTask(Task task) async {
    await DBHelper.delete(task);
    getTask();
  }
  
  void deleteAllTasks() async {
    await DBHelper.deleteAll();
    getTask();
  }

  void markTaskComplete(int id) async {
    await DBHelper.updateCompelete(id);
    getTask();
  }

  void markTasktodo(int id) async {
    await DBHelper.updatetodo(id);
    getTask();
  }
}
