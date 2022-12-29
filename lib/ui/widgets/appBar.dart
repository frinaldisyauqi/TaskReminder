import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/ui/theme.dart';
import '../../controllers/task_controller.dart';

AppBar appBar(BuildContext context, Function() onPressed, Widget icon,
        {Widget? deleteTasks}) =>
    AppBar(
      toolbarHeight: 70,
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: IconButton(onPressed: onPressed, icon: icon),
      actions: [
        deleteTasks ?? Container(),
        const CircleAvatar(backgroundImage: AssetImage('images/person.jpeg')),
        const SizedBox(width: 20),
      ],
    );
