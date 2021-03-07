import 'package:flutter/material.dart';
import 'package:meeting_planner/repository/data_repository.dart';
import 'package:meeting_planner/ui/base/base_widget_state.dart';
import 'package:meeting_planner/ui/base/bloc_state.dart';
import 'package:meeting_planner/ui/new_booking/new_booking_bloc.dart';
import 'package:meeting_planner/utils/constants.dart';

class NewBookingWidget extends StatefulWidget {
  @override
  _NewBookingWidgetState createState() =>
      _NewBookingWidgetState(NewBookingBloc(DataRepository()));
}

class _NewBookingWidgetState
    extends BaseWidgetState<NewBookingBloc, NewBookingWidget> {
  _NewBookingWidgetState(NewBookingBloc newBookingBloc)
      : super(bloc: newBookingBloc);

  @override
  Widget buildContentWidget(BlocState<dynamic> state) {
    return _buildNewBookingWidget(state);
  }

  @override
  Widget buildIdleWidget(BlocState<dynamic> state) {
    return _buildNewBookingWidget(state);
  }

  _buildNewBookingWidget(BlocState state) {
    return Scaffold(
        appBar: AppBar(
      title: Text(Constants.titleNewBookings),
    ));
  }
}
