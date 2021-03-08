import 'package:flutter/material.dart';
import 'package:meeting_planner/models/booking.dart';

class DataHelper {
  static final DataHelper instance = DataHelper._private();

  List<MeetingRoom> meetingRooms = List.empty(growable: true);
  List<Reminder> reminderOptions = List.empty(growable: true);
  List<Priority> priorityOptions = List.empty(growable: true);

  TimeOfDay officeStartTime;
  TimeOfDay officeEndTime;

  DataHelper._private() {
    officeStartTime = TimeOfDay(hour: 9, minute: 0);
    officeEndTime = TimeOfDay(hour: 17, minute: 0);
    initMeetingRoomsData();
    initReminderOptions();
    initPriorityOptions();
  }

  initMeetingRoomsData() {
    if (meetingRooms.isEmpty) {
      meetingRooms
          .add(MeetingRoom(id: 1, name: "Room 1", colorCode: "#008000"));
      meetingRooms
          .add(MeetingRoom(id: 2, name: "Room 2", colorCode: "#FFA07A"));
      meetingRooms
          .add(MeetingRoom(id: 3, name: "Room 3", colorCode: "#B22222"));
      meetingRooms
          .add(MeetingRoom(id: 4, name: "Room 4", colorCode: "#1E90FF"));
    }
  }

  initReminderOptions() {
    if (reminderOptions.isEmpty) {
      reminderOptions.add(
          Reminder(id: 1, name: "15 mins", duration: TimeOfDay(minute: 15)));
      reminderOptions.add(
          Reminder(id: 2, name: "30 mins", duration: TimeOfDay(minute: 30)));
      reminderOptions.add(
          Reminder(id: 3, name: "24 hours", duration: TimeOfDay(hour: 24)));
    }
  }

  void initPriorityOptions() {
    if (priorityOptions.isEmpty) {
      priorityOptions
          .add(Priority(id: 1, name: "High", value: 3, colorCode: "#ff3300"));
      priorityOptions
          .add(Priority(id: 2, name: "Medium", value: 2, colorCode: "#6600ff"));
      priorityOptions
          .add(Priority(id: 3, name: "Low", value: 1, colorCode: "#00cc99"));
    }
  }

  MeetingRoom getMeetingRoomById(int id) {
    return meetingRooms.singleWhere((element) => element.id == id);
  }
}
