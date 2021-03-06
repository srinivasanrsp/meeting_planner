import 'package:flutter/material.dart';
import 'package:meeting_planner/ui/base/base_bloc.dart';
import 'package:meeting_planner/ui/base/base_widget_state.dart';
import 'package:meeting_planner/ui/base/bloc_state.dart';
import 'package:meeting_planner/ui/booking_list/bloc/booking_list_bloc.dart';

class BookingListPage extends StatefulWidget {
  @override
  _BookingListPageState createState() =>
      _BookingListPageState(BookingListBloc());
}

class _BookingListPageState
    extends BaseWidgetState<BookingListBloc, BookingListPage> {
  _BookingListPageState(BaseBloc bloc) : super(bloc);

  @override
  Widget buildContentWidget(BuildContext context, BlocState<dynamic> state) {}

  @override
  Widget buildIdleWidget(BuildContext context) {}
}
