import 'package:meeting_planner/repository/data_repository.dart';
import 'package:meeting_planner/ui/base/base_bloc.dart';

class NewBookingBloc extends BaseBloc {
  NewBookingBloc(DataRepository repository) : super(repository);

  @override
  Future addData({param}) async {
    return await repository.bookNewMeeting(param);
  }
}
