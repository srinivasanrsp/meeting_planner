import 'package:flutter/material.dart';
import 'package:meeting_planner/utils/data_helper.dart';
import 'package:meeting_planner/utils/date_utils.dart';

class Booking {
  int bookingId;
  String title;
  String description;
  DateTime meetingDateTime;
  int meetingDuration;
  MeetingRoom meetingRoom;
  Priority priority;
  Reminder reminderDuration;

  Booking(
      {this.bookingId,
      this.title,
      this.description,
      this.meetingDateTime,
      this.meetingDuration,
      this.meetingRoom,
      this.priority,
      this.reminderDuration});

  Booking.fromJson(Map<String, dynamic> json) {
    bookingId = json["id"];
    title = json["title"];
    description = json["description"];
    meetingDateTime = json["bookingDate"] != null
        ? DateTimeUtils.getLocalDateTimeFromServer(json["bookingDate"],
            inputPattern: DateTimeUtils.PATTERN_SERVER_DATE_TIME)
        : null;
    meetingDuration = json["duration"];
    meetingRoom = DataHelper.instance.meetingRooms
        .singleWhere((element) => element.id == json["meetingRoomId"]);
    priority = DataHelper.instance.priorityOptions
        .singleWhere((element) => element.id == json["priorityId"]);
    reminderDuration = DataHelper.instance.reminderOptions
        .singleWhere((element) => element.id == json["reminderId"]);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map();
    data["title"] = title;
    data["description"] = description;
    data["bookingDate"] = DateTimeUtils.covertToServerDateTime(
        meetingDateTime, DateTimeUtils.PATTERN_SERVER_DATE_TIME);
    data["duration"] = meetingDuration;
    data["meetingRoomId"] = meetingRoom.id;
    data["priorityId"] = priority.id;
    data["reminderId"] = reminderDuration.id;
    return data;
  }
}

class Choice {
  int id;
  String name;

  Choice(this.id, this.name);
}

class MeetingRoom extends Choice {
  String colorCode;

  MeetingRoom({id, name, this.colorCode}) : super(id, name);
}

class Priority extends Choice {
  int value;
  String colorCode;

  Priority({id, name, this.value, this.colorCode}) : super(id, name);
}

class Reminder extends Choice {
  TimeOfDay duration;

  Reminder({id, name, this.duration}) : super(id, name);
}
