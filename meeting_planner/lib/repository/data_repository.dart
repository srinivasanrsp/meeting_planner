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
      for (int i = 0; i < count; i++) {
        bookingList.add(Booking.fromJson(response[i]));
      }
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
