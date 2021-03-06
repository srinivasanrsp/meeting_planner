import 'package:meeting_planner/models/meeting_room.dart';

class Booking {
  int bookingId;
  String title;
  String description;
  DateTime bookingDate;
  MeetingRoom meetingRoom;
  Priority priority;
  DateTime reminder;

  Booking(
      {this.bookingId,
      this.title,
      this.description,
      this.bookingDate,
      this.meetingRoom,
      this.priority,
      this.reminder});

  Booking.fromJson(Map<String, dynamic> json) {
    bookingId = json["bookingId"];
    title = json["title"];
    description = json["description"];
    bookingDate = json["bookingDate"];
    meetingRoom = json["meetingRoom"];
    priority = json["priority"];
    reminder = json["reminder"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = Map();
    data["bookingId"] = bookingId;
    data["title"] = title;
    data["description"] = description;
    data["bookingDate"] = bookingDate;
    data["meetingRoom"] = meetingRoom;
    data["priority"] = priority;
    data["reminder"] = reminder;
    return data;
  }
}

enum Priority { HIGH, MEDIUM, LOW }
