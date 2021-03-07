import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_planner/repository/data_repository.dart';
import 'package:meeting_planner/ui/base/bloc_event.dart';
import 'package:meeting_planner/ui/base/bloc_state.dart';

class BaseBloc extends Bloc<BlocEvent, BlocState> {
  final DataRepository repository;

  BaseBloc(this.repository);

  @override
  BlocState get initialState => BlocState(STATE.IDLE);

  @override
  Stream<BlocState> mapEventToState(BlocEvent<dynamic> blocEvent) async* {
    if (blocEvent.event == Event.IDLE) {
      yield BlocState(STATE.IDLE);
    } else if (blocEvent.event == Event.GET_DATA) {
      yield BlocState(STATE.LOADING, event: blocEvent.event);
      var data = await getData(param: blocEvent.data);
      yield BlocState(STATE.COMPLETED, data: data, event: blocEvent.event);
    } else if (blocEvent.event == Event.UPDATE_DATA) {
      yield BlocState(STATE.LOADING, event: blocEvent.event);
      var data = await updateData(param: blocEvent.data);
      yield BlocState(STATE.COMPLETED, data: data, event: blocEvent.event);
    } else if (blocEvent.event == Event.DELETE_DATA) {
      yield BlocState(STATE.LOADING, event: blocEvent.event);
      var data = await deleteData(param: blocEvent.data);
      yield BlocState(STATE.COMPLETED, data: data, event: blocEvent.event);
    }
  }

  Future<dynamic> getData({param}) {}

  Future<dynamic> addData({param}) {}

  Future<dynamic> updateData({param}) {}

  Future<dynamic> deleteData({param}) {}
}
