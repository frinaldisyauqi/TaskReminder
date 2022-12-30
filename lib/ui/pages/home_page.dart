import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:taskreminder/models/task.dart';
import 'package:taskreminder/services/notification_services.dart';
import 'package:taskreminder/ui/widgets/task_tile.dart';

import '../../controllers/task_controller.dart';
import '../widgets/appBar.dart';
import '../widgets/input_field.dart';
import '/services/theme_services.dart';
import '/ui/size_config.dart';
import '/ui/theme.dart';
import '/ui/widgets/button.dart';
import 'add_task_page.dart';
import 'notification_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NotifyHelper notifyHelper;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 700), (() => animationCall()));
    notifyHelper = NotifyHelper();
    notifyHelper.requestIOSPermissions();
    notifyHelper.initializeNotification();
    _taskController.getTask();
  }

  final TaskController _taskController = Get.put(TaskController());
  DateTime selectedTime = DateTime.now();

  double scale = 0;
  animationCall() => setState(() {
        scale = scale == 0 ? 1 : 0;
      });
  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    Orientation orientation = mediaQueryData.orientation;

    return Scaffold(
      appBar: appBar(
        context,
        () {
          ThemeServices().switchTheme();
        },
        Icon(Get.isDarkMode ? Icons.wb_sunny : Icons.nightlight,
            color: Get.isDarkMode ? Colors.yellow : Colors.black),
        deleteTasks: IconButton(
            onPressed: () {
              _taskController.deleteAllTasks();
              notifyHelper.deleteAllNotification();
            },
            icon: const Icon(
              Icons.cleaning_services,
              color: pinkClr,
            )),
      ),
      body: RefreshIndicator(
        onRefresh: () => _taskController.getTask(),
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 10, 10, 10),
          child: Column(children: [
            taskBar(),
            const SizedBox(height: 10),
            datePicker(),
            SizedBox(height: _taskController.taskList.isEmpty ? 80 : 20),
            showTask(orientation),
          ]),
        ),
      ),
    );
  }

  Widget showTask(Orientation orientation) {
    return Expanded(
      child: Obx(
        () => _taskController.taskList.isEmpty
            ? noTask(orientation)
            : ListView.builder(
                itemCount: _taskController.taskList.length,
                itemBuilder: (context, index) {
                  var task = _taskController.taskList[index];

                  var date = DateFormat.jm().parse(task.startTime!);
                  var myTime = DateFormat('HH:mm').format(date);
                  var hours = int.parse(myTime.split(':')[0]);
                  var minuts = int.parse(myTime.split(':')[1]);

                  notifyHelper.scheduledNotification(hours, minuts, task);
                  // notifyHelper.displayNotification(
                  //     title: task.title,
                  //     body: 'Task has been added',
                  //     disc: task.note,
                  //     date: task.startTime);

                  if (task.repeat == 'Daily' ||
                      task.date == DateFormat.yMd().format(selectedTime) ||
                      (task.repeat == 'Weekly' &&
                          selectedTime
                                      .difference(
                                          DateFormat.yMd().parse(task.date))
                                      .inDays %
                                  7 ==
                              0) ||
                      task.repeat == 'Monthly' &&
                          DateFormat.yMd().parse(task.date).day ==
                              selectedTime.day) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(seconds: 1),
                      child: SlideAnimation(
                        horizontalOffset: 500,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            child: TaskTile(task),
                            onTap: () => showBottomSheet(
                                _taskController.taskList[index]),
                            onDoubleTap: (() =>
                                _taskController.markTaskComplete(task.id)),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
      ),
    );
  }

  Widget noTask(Orientation orientation) {
    return SingleChildScrollView(
      child: AnimatedScale(
        scale: scale,
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 500),
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          direction: orientation == Orientation.landscape
              ? Axis.horizontal
              : Axis.vertical,
          children: [
            SvgPicture.asset(
              'images/task.svg',
              alignment: Alignment.bottomRight,
              color: primaryClr,
              width: 150,
              height: 150,
            ),
            Container(
              width: 350,
              margin: const EdgeInsets.only(top: 10),
              child: Text(
                'No Tasks Are Addedd Yet !',
                style: subTitleStyle,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

  Container datePicker() {
    return Container(
      margin: const EdgeInsets.only(left: 0),
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: DateTime.now(),
        selectionColor: pinkClr,
        onDateChange: (newDate) => setState(() => selectedTime = newDate),
        width: 70,
        height: 100,
        dateTextStyle: GoogleFonts.lato(fontSize: 20, color: Colors.grey),
        dayTextStyle: GoogleFonts.lato(fontSize: 18, color: Colors.grey),
        monthTextStyle: GoogleFonts.lato(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  Row taskBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(DateFormat('yMMMMd').format(DateTime.now()),
              style: subheadingStyle),
          Text('Today', style: headingStyle)
        ]),
        MyButton(
            lable: '+   Add Task',
            onPressed: () async {
              await Get.to(() => const AddTaskPage());
              _taskController.getTask();
            }),
      ],
    );
  }

  showBottomSheet(Task task) {
    SizeConfig().init(context);
    return Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Color.fromARGB(255, 47, 47, 47),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              task.isCompleted == 1
                  ? buttonsBottomSheet('Task TODO', () {
                      _taskController.markTasktodo(task.id!);
                      notifyHelper.deleteNotification(task);
                      Get.back();
                    }, primaryClr)
                  : buttonsBottomSheet('Task Complete', () {
                      _taskController.markTaskComplete(task.id!);
                      Get.back();
                    }, primaryClr),
              buttonsBottomSheet('Delete Task', () {
                _taskController.deleteTask(task);
                notifyHelper.deleteNotification(task);
                Get.back();
              }, Colors.red[700]!),
              const Divider(
                  height: 20,
                  thickness: 3,
                  color: white,
                  indent: 100,
                  endIndent: 100),
              buttonsBottomSheet('Cancel', () => Get.back(), primaryClr),
            ],
          ),
        ),
      ),
    );
  }

  buttonsBottomSheet(String lable, Function() onTap, Color clr) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        width: 300,
        height: 60,
        decoration:
            BoxDecoration(color: clr, borderRadius: BorderRadius.circular(15)),
        child: Center(
            child: Text(lable, style: titleStyle.copyWith(color: white))),
      ),
    );
  }
}
