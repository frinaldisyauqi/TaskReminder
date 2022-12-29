import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/services/theme_services.dart';
import 'package:todo/ui/theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({
    Key? key,
    required this.payload,
  }) : super(key: key);
  final String payload;
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<String> payload = [];

  @override
  void initState() {
    payload = widget.payload.split('||');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.backgroundColor,
        leading: IconButton(
          color: Get.isDarkMode? Colors.white : bluishClr,
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
        title: Text(
          payload[0],
          style: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black)
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Column(
        children: [
          Column(
            children: [
              const SizedBox(height: 10),
              Text(
                'Hello BomBoOo',
                style: TextStyle(
                    color: ThemeServices().loadThemeFromBox()
                        ? Colors.white
                        : darkGreyClr,
                    fontSize: 26,
                    fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),
              Text(
                'You Have New Reminder !',
                style: TextStyle(
                    color: ThemeServices().loadThemeFromBox()
                        ? Colors.white
                        : darkGreyClr,
                    fontSize: 18,
                    fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 20),
            ],
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: primaryClr,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                notifyHead(Icons.text_format, 'Title'),
                const SizedBox(height: 10),
                notifyParaghraph(payload[0]),
                const SizedBox(height: 20),
                notifyHead(Icons.description, 'Description'),
                const SizedBox(height: 10),
                notifyParaghraph(payload[1]),
                const SizedBox(height: 20),
                notifyHead(Icons.calendar_today, 'Date'),
                const SizedBox(height: 10),
                notifyParaghraph(payload[2]),
                const SizedBox(height: 20),
              ],
            ),
          )),
          const SizedBox(height: 20)
        ],
      )),
    );
  }

  Text notifyParaghraph(String text) => Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      );

  Row notifyHead(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 30, color: Colors.white),
        const SizedBox(width: 15),
        Text(text,
            style: const TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.w500))
      ],
    );
  }
}
