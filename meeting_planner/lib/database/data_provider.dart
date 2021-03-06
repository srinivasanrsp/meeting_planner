import 'package:meeting_planner/database/database_helper.dart';
import 'package:meeting_planner/models/booking.dart';

class DataProvider {
  final String tableName = 'booking';
  DatabaseHelper databaseHelper = DatabaseHelper();
  static DataProvider dataProvider;

  DataProvider._createInstance();

  factory DataProvider() {
    if (DataProvider == null) {
      dataProvider = DataProvider._createInstance();
    }
    return dataProvider;
  }

  void createTable() async {
    await databaseHelper.createTable(
        tableName,
        Booking(
                title: "",
                body: "",
                type: "",
                siteName: "",
                listName: "",
                itemId: "",
                receivedAt: "")
            .toJson());
  }

  Future<Booking> getBookingList(DateTime dateTime) {}

  Future<Booking> bookNewMeeting(Booking booking) {}

  Future<Booking> cancelBooking(int bookingId) {}
}
