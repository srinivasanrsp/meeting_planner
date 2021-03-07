import 'package:meeting_planner/models/meeting_room.dart';
import 'package:meeting_planner/utils/date_utils.dart';

class Booking {
  int bookingId;
  String title;
  String description;
  DateTime meetingDateTime;
  int meetingDuration;
  MeetingRoom meetingRoom;
  Priority priority;
  int reminderDuration;

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
    bookingId = json["bookingId"];
    title = json["title"];
    description = json["description"];
    meetingDateTime = json["meetingDateTime"] != null
        ? DateTimeUtils.getLocalDateTimeFromServer(json["meetingDateTime"],
            inputPattern: DateTimeUtils.PATTERN_TIME)
        : null;
    meetingRoom = json["meetingRoom"];
    priority = json["priority"] != null
        ? Priority.values.elementAt(json["priority"])
        : 0;
    reminderDuration = json["reminder"];
    meetingDuration = json["duration"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map();
    data["title"] = title;
    data["description"] = description;
    data["bookingDate"] = DateTimeUtils.covertToServerDateTime(
        meetingDateTime, DateTimeUtils.PATTERN_SERVER_DATE_TIME);
    data["duration"] = meetingDuration;
    data["meetingRoomId"] = meetingRoom.id;
    data["priority"] = priority.index + 1;
    data["reminder"] = reminderDuration;
    return data;
  }
}

enum Priority { HIGH, MEDIUM, LOW }
