import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meeting_planner/ui/base/base_bloc.dart';
import 'package:meeting_planner/ui/base/bloc_state.dart';

/// State of widget with BLoC support. Responsible for building widgets based on
/// the current [BlocState].
abstract class BaseWidgetState<B extends BaseBloc, W extends StatefulWidget>
    extends State<W> {
  B bloc;

  BaseWidgetState({this.bloc});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (bloc == null) {
      bloc = BlocProvider.of<B>(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return getBlocBuilder();
  }

  Widget getBlocBuilder() {
    return BlocBuilder<BaseBloc, BlocState>(
        bloc: bloc,
        builder: (BuildContext context, BlocState state) {
          switch (state.state) {
            case STATE.IDLE:
              return buildIdleWidget(state);
            case STATE.LOADING:
              return buildLoadingWidget(state);
            case STATE.COMPLETED:
              return buildContentWidget(state);
            case STATE.ERROR:
              return buildErrorWidget(state);
            default:
              return buildIdleWidget(state);
          }
        });
  }

  Widget buildIdleWidget(BlocState<dynamic> state);

  Widget buildLoadingWidget(BlocState<dynamic> state) {
    return Container(child: Center(child: CircularProgressIndicator()));
  }

  Widget buildContentWidget(BlocState<dynamic> state);

  Widget buildErrorWidget(BlocState<dynamic> state) {
    return Container();
  }
}
