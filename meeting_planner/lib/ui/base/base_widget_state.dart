import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_planner/ui/base/base_bloc.dart';
import 'package:meeting_planner/ui/base/bloc_state.dart';

/// State of widget with BLoC support. Responsible for building widgets based on
/// the current [BlocState].
abstract class BaseWidgetState<T, W extends StatefulWidget> extends State<W> {
  final BaseBloc bloc;

  BaseWidgetState(this.bloc);

  @override
  Widget build(BuildContext context) {
    return getBlocBuilder();
  }

  Widget getBlocBuilder() {
    return BlocBuilder<BaseBloc, BlocState>(
        builder: (BuildContext context, BlocState state) {
      switch (state.state) {
        case STATE.IDLE:
          return buildIdleWidget(context);
        case STATE.LOADING:
          return buildLoadingWidget(context, state);
        case STATE.COMPLETED:
          return buildContentWidget(context, state);
        case STATE.ERROR:
          return buildErrorWidget(context, state);
        default:
          return buildIdleWidget(context);
      }
    });
  }

  Widget buildIdleWidget(BuildContext context);

  Widget buildLoadingWidget(BuildContext context, BlocState<dynamic> state) {
    return Container(child: Center(child: CircularProgressIndicator()));
  }

  Widget buildContentWidget(BuildContext context, BlocState<dynamic> state);

  Widget buildErrorWidget(BuildContext context, BlocState<dynamic> state) {
    return Container();
  }
}
