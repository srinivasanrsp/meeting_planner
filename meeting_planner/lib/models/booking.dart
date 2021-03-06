import 'package:meeting_planner/models/meeting_room.dart';

class Booking {
  int bookingId;
  String title;
  String description;
  DateTime bookingDate;
  MeetingRoom meetingRoom;
  Priority priority;
  DateTime reminder;
}

enum Priority { HIGH, MEDIUM, LOW }
