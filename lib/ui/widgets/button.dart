import 'package:flutter/material.dart';
import 'package:todo/ui/theme.dart';

class MyButton extends StatelessWidget {
  const MyButton({Key? key, required this.lable, required this.onPressed})
      : super(key: key);
  final String lable;
  final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          lable,
          style: const TextStyle(color: white, fontWeight: FontWeight.w900),
        ),
        color: primaryClr,
      ),
    );
  }
}
