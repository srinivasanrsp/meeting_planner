import 'package:meeting_planner/repository/data_repository.dart';
import 'package:meeting_planner/ui/base/base_bloc.dart';

class BookingDetailsBloc extends BaseBloc {
  BookingDetailsBloc(DataRepository repository) : super(repository);

  @override
  Future deleteData({param}) async {
    return await repository.cancelBooking(param);
  }
}
