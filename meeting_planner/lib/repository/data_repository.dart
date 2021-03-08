import 'package:meeting_planner/database/database_helper.dart';
import 'package:meeting_planner/models/booking.dart';

/// The Abstract repository to wrap multiple data providers of a widget.
class DataRepository {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<List<Booking>> getBookingList(DateTime dateTime) async {
    try {
      List<Map<String, dynamic>> response =
          await databaseHelper.getBookingData(dateTime);
      int count = response.length;
      List<Booking> bookingList = List.empty(growable: true);
      if (dateTime == null) {
        dateTime = DateTime.now();
      }
      for (int i = 0; i < count; i++) {
        Booking booking = Booking.fromJson(response[i]);
        DateTime queryDate =
            DateTime(dateTime.year, dateTime.month, dateTime.day);
        DateTime bookingDate = DateTime(booking.meetingDateTime.year,
            booking.meetingDateTime.month, booking.meetingDateTime.day);
        if (queryDate.compareTo(bookingDate) == 0) {
          bookingList.add(booking);
        }
      }
      bookingList
          .sort((a, b) => a.meetingDateTime.compareTo(b.meetingDateTime));
      bookingList.sort((a, b) => b.priority.value.compareTo(a.priority.value));
      return bookingList;
    } catch (e) {
      return List.empty();
    }
  }

  Future<int> bookNewMeeting(Booking booking) async {
    Map<String, dynamic> jsonMap = booking.toJson();
    return await databaseHelper.insertData(jsonMap);
  }

  Future<int> cancelBooking(int bookingId) async {
    return await databaseHelper.deleteData(bookingId);
  }
}
