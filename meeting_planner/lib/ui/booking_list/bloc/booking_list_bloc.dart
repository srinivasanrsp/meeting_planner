import 'package:meeting_planner/repository/data_repository.dart';
import 'package:meeting_planner/ui/base/base_bloc.dart';

class BookingListBloc extends BaseBloc {
  BookingListBloc(DataRepository repository) : super(repository);

  @override
  Future getData({param}) async {
    return repository.getBookingList(param);
  }
}
