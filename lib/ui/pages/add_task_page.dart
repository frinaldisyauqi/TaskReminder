import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/models/task.dart';
import 'package:todo/ui/theme.dart';
import 'package:todo/ui/widgets/button.dart';

import '../../controllers/task_controller.dart';
import '../widgets/appBar.dart';
import '../widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(hours: 1)))
      .toString();

  var _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'Just Once';
  List<String> repeatList = ['Just Once', 'Daily', 'Weekly', 'Monthly'];

  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context,
        () => Get.back(),
        Icon(Icons.arrow_back_ios,
            color: Get.isDarkMode ? Colors.white : primaryClr),
      ),
      body: Container(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: [
                  Text('Add Task', style: headingStyle.copyWith(fontSize: 28)),
                  const SizedBox(height: 10),
                  InputField(
                    title: 'Title',
                    hint: 'Enter Your Title',
                    txtController: _titleController,
                  ),
                  const SizedBox(height: 10),
                  InputField(
                    title: 'Note',
                    hint: 'Enter Note',
                    txtController: _noteController,
                  ),
                  const SizedBox(height: 10),
                  InputField(
                    title: 'Date',
                    hint: DateFormat.yMd().format(_selectedDate),
                    widget: IconButton(
                      onPressed: () => getDateFromUser(),
                      icon: const Icon(Icons.calendar_today_outlined),
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                          child: InputField(
                        title: 'Start Time',
                        hint: _startTime,
                        widget: IconButton(
                            onPressed: () => getTimeFromUser(isStartTime: true),
                            icon: const Icon(Icons.access_time_rounded,
                                color: Colors.grey)),
                      )),
                      const SizedBox(width: 10),
                      Expanded(
                          child: InputField(
                        title: 'End Time',
                        hint: _endTime,
                        widget: IconButton(
                            onPressed: () =>
                                getTimeFromUser(isStartTime: false),
                            icon: const Icon(Icons.access_time_rounded,
                                color: Colors.grey)),
                      ))
                    ],
                  ),
                  const SizedBox(height: 10),
                  InputField(
                      title: 'Reminder',
                      hint: '$_selectedRemind  Minuts Early',
                      widget: dropDown(remindList)),
                  const SizedBox(height: 10),
                  InputField(
                      title: 'Repeat',
                      hint: _selectedRepeat,
                      widget: dropDown(repeatList)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Colors', style: titleStyle),
                          Wrap(
                              children: List.generate(
                            3,
                            (index) => Container(
                              margin: const EdgeInsets.only(right: 7),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => _selectedColor = index);
                                },
                                child: CircleAvatar(
                                  backgroundColor: index == 0
                                      ? bluishClr
                                      : index == 1
                                          ? pinkClr
                                          : orangeClr,
                                  radius: 17,
                                  child: _selectedColor == index
                                      ? const Icon(
                                          Icons.done,
                                          size: 20,
                                          color: white,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          )),
                        ],
                      ),
                      MyButton(
                          lable: 'Create Task', onPressed: () => validate())
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }

  DropdownButton dropDown(List list) {
    return DropdownButton(
      borderRadius: BorderRadius.circular(10),
      items: list
          .map((e) => DropdownMenuItem(child: Text('$e'), value: e))
          .toList(),
      onChanged: (v) {
        setState(() => list == repeatList
            ? _selectedRepeat = v.toString()
            : _selectedRemind = v);
      },
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
      underline: Container(height: 0), // to Remove underline
      iconSize: 25,
    );
  }

  validate() {
    if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar('', '',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryClr,
          titleText: const Text('Required',
              style: TextStyle(fontWeight: FontWeight.bold, color: white)),
          messageText: const Text('Fields Must Not Be Empty!!',
              style: TextStyle(fontWeight: FontWeight.bold, color: white)),
          icon: const Icon(Icons.warning_amber_outlined,
              color: Colors.yellow, size: 35),
          leftBarIndicatorColor: pinkClr,
          borderRadius: 0,
          shouldIconPulse: true);
    } else {
      addTaskToDB();
      Get.back();
    }
  }

  addTaskToDB() async {
    int value = await _taskController.addTask(
        task: Task(
            title: _titleController.text,
            note: _noteController.text,
            date: DateFormat.yMd().format(_selectedDate),
            isCompleted: 0,
            startTime: _startTime,
            endTime: _endTime,
            color: _selectedColor,
            repeat: _selectedRepeat,
            remind: _selectedRemind));

    print(value);
  }

  getDateFromUser() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2040));

    if (pickedDate != null)
      setState(() => _selectedDate = pickedDate);
    else
      print('');
  }

  getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? pickedDate = await showTimePicker(
        context: context,
        initialTime: isStartTime
            ? TimeOfDay.fromDateTime(DateTime.now())
            : TimeOfDay.fromDateTime(
                DateTime.now().add(const Duration(hours: 1))));

    String formatedTime = pickedDate!.format(context);

    if (isStartTime)
      setState(() => _startTime = formatedTime);
    else if (!isStartTime)
      setState(() => _endTime = formatedTime);
    else
      print('');
  }
}
