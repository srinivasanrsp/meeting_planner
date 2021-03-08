import 'package:meeting_planner/models/booking.dart';
import 'package:meeting_planner/notification/local_notification.dart';
import 'package:meeting_planner/repository/data_repository.dart';
import 'package:meeting_planner/ui/base/base_bloc.dart';

class BookingListBloc extends BaseBloc {
  BookingListBloc(DataRepository repository) : super(repository);

  @override
  Future getData({param}) async {
    List<Booking> bookingList = await repository.getBookingList(param);
    scheduledNotification(bookingList);
    return bookingList;
  }

  void scheduledNotification(List<Booking> booking) {
    if (booking != null) {
      booking.forEach((element) {
        LocalNotification.instance.scheduleNotification(element);
      });
    }
  }
}
