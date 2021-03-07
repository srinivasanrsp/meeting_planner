import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_planner/repository/data_repository.dart';
import 'package:meeting_planner/ui/booking_list/bloc/booking_list_bloc.dart';
import 'package:meeting_planner/ui/booking_list/view/booking_list_page.dart';
import 'package:meeting_planner/utils/constants.dart';

void main() {
  runApp(MeetingPlannerApp());
}

class MeetingPlannerApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: Constants.appName,
        theme: ThemeData(
          // This is the theme of application.
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: MultiBlocProvider(
          child: BookingListPage(),
          providers: [
            BlocProvider<BookingListBloc>(
              create: (context) => BookingListBloc(DataRepository()),
            ),
          ],
        ));
  }
}
