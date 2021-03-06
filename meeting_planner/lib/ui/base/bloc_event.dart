import 'package:equatable/equatable.dart';

class BlocEvent<T> extends Equatable {
  /// Payload of the current state
  var data;

  BlocEvent(this._event, [this.data]);

  Event _event = Event.IDLE;

  Event get event => _event;

  @override
  List<Object> get props => [_event, data];
}

/// Representation of event in BLoc.
enum Event {
  IDLE,
  GET_DATA,
  ADD_DATA,
  UPDATE_DATA,
  DELETE_DATA,
  REFRESH_DATA,
  SEARCH_DATA
}
