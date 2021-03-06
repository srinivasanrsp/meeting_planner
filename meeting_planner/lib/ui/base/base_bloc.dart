import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_planner/ui/base/bloc_event.dart';
import 'package:meeting_planner/ui/base/bloc_state.dart';

class BaseBloc extends Bloc<BlocEvent, BlocState> {
  BaseBloc() : super(BlocState(STATE.IDLE));

  @override
  Stream<BlocState> mapEventToState(BlocEvent<dynamic> event) {}
}
