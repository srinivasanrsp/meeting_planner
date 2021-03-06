import 'package:equatable/equatable.dart';
import 'package:meeting_planner/ui/base/bloc_event.dart';

class BlocState<T> extends Equatable {
  /// Payload of the current state
  T data;

  Event event;

  Error error;

  BlocState(this._state, {this.data, this.event, this.error});

  STATE _state = STATE.IDLE;

  STATE get state => _state;

  @override
  List<Object> get props => [_state];
}

/// Constants of bloc state.
enum STATE { IDLE, LOADING, COMPLETED, ERROR }
