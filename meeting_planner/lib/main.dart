import 'package:flutter/material.dart';
import 'package:meeting_planner/ui/booking_list/view/booking_list_page.dart';
import 'package:meeting_planner/utils/strings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppString.appTitle,
      theme: ThemeData(
        // This is the theme of application.
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BookingListPage(),
    );
  }
}
