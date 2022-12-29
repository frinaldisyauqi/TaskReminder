import 'package:flutter/material.dart';
import 'package:todo/controllers/task_controller.dart';

import 'package:todo/models/task.dart';
import 'package:todo/ui/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskTile extends StatelessWidget {
  TaskTile(this.task, {Key? key}) : super(key: key);

  final Task task;
  final _taskController = TaskController();

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Dismissible(
                key: Key('${task.id}'),
                onDismissed: ((direction) => _taskController.deleteTask(task)),
                background: Container(
                  padding: const EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: pinkClr, borderRadius: BorderRadius.circular(15)),
                  child: const Icon(Icons.delete, color: white, size: 40),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: getColor(task.color)),
                  child: Row(children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(task.title!,
                              style: titleStyle.copyWith(color: white)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.timelapse, color: Colors.grey[200]),
                              const SizedBox(width: 7),
                              Text('${task.startTime} - ${task.endTime}',
                                  style: bodyStyle.copyWith(color: white))
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(task.note!,
                              style: body2Style.copyWith(
                                  color: white, fontWeight: FontWeight.normal))
                        ],
                      ),
                    ),
                    RotatedBox(
                      quarterTurns: 3,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Container(
                              height: 0.8, width: 60, color: Colors.grey[300]),
                          const SizedBox(height: 10),
                          Text(task.isCompleted == 0 ? 'TODO' : 'COMPELETED',
                              style: bodyStyle.copyWith(
                                  color: white, fontSize: 12))
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  getColor(int? color) {
    switch (color) {
      case 0:
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return orangeClr;

      default:
        bluishClr;
    }
  }
}
