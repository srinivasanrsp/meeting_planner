import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meeting_planner/models/booking.dart';
import 'package:meeting_planner/repository/data_repository.dart';
import 'package:meeting_planner/ui/base/base_widget_state.dart';
import 'package:meeting_planner/ui/base/bloc_event.dart';
import 'package:meeting_planner/ui/base/bloc_state.dart';
import 'package:meeting_planner/ui/booking_details/booking_details_bloc.dart';
import 'package:meeting_planner/utils/constants.dart';
import 'package:meeting_planner/utils/date_utils.dart';
import 'package:meeting_planner/utils/dimension_utils.dart';
import 'package:meeting_planner/utils/utils.dart';

class BookingDetailsPage extends StatefulWidget {
  final Booking booking;

  const BookingDetailsPage(this.booking);

  @override
  _BookingDetailsPageState createState() => _BookingDetailsPageState(booking);
}

class _BookingDetailsPageState
    extends BaseWidgetState<BookingDetailsBloc, BookingDetailsPage> {
  final Booking booking;

  _BookingDetailsPageState(this.booking)
      : super(bloc: BookingDetailsBloc(DataRepository()));

  @override
  Widget buildContentWidget(BlocState<dynamic> state) {
    if (state.event == Event.DELETE_DATA && state.state == STATE.COMPLETED) {
      Utils.showToast(Constants.messageCancelled);
      Future.delayed(Duration(milliseconds: 300), () {
        Navigator.pop(context, true);
      });
    }
    return _buildContent(state);
  }

  @override
  Widget buildIdleWidget(BlocState<dynamic> state) {
    return _buildContent(state);
  }

  _buildContent(BlocState state) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Booking Details"),
        ),
        body: state.event == Event.DELETE_DATA && state.state == STATE.LOADING
            ? Stack(
                children: <Widget>[
                  _buildDetailsContent(state),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xa0000000), Color(0xa0000000)],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(child: CircularProgressIndicator()),
                        Padding(
                          padding: EdgeInsets.only(top: Dimension.NORMAL),
                        ),
                        Text(
                          Constants.labelLoading,
                          style: TextStyle(
                              color: Colors.grey, fontSize: TextSize.XX_LARGE),
                        ),
                      ],
                    ),
                  )
                ],
              )
            : _buildDetailsContent(state));
  }

  _buildDetailsContent(BlocState state) {
    return Container(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.only(
                    left: Dimension.LARGE, right: Dimension.LARGE),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextWidget(
                          labelText: Constants.labelTitle,
                          value: booking.title),
                      _buildTextWidget(
                          labelText: Constants.labelDescription,
                          value: booking.description),
                    ],
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.only(
                    left: Dimension.LARGE,
                    right: Dimension.LARGE,
                    top: Dimension.MEDIUM),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextWidget(
                          labelText: Constants.labelMeetingRoom,
                          value: booking.meetingRoom.name),
                      _buildTextWidget(
                          labelText: Constants.labelMeetingDate,
                          value: DateFormat(DateTimeUtils.PATTERN_DMY)
                              .format(booking.meetingDateTime)),
                      _buildTextWidget(
                          labelText: Constants.labelPriority,
                          value: booking.priority.name),
                    ],
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.only(
                    left: Dimension.LARGE,
                    right: Dimension.LARGE,
                    top: Dimension.MEDIUM),
                child: Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTextWidget(
                          labelText: Constants.labelStartTime,
                          value: DateFormat(DateTimeUtils.PATTERN_H12MA)
                              .format(booking.meetingDateTime)),
                      _buildTextWidget(
                          labelText: Constants.labelEndTime,
                          value: DateFormat(DateTimeUtils.PATTERN_H12MA).format(
                              booking.meetingDateTime.add(
                                  Duration(seconds: booking.meetingDuration))))
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: Dimension.XX_LARGE),
                child: RaisedButton(
                  child: Text(
                    "CANCEL",
                    style: TextStyle(
                        color: Colors.white, fontSize: TextSize.X_LARGE),
                  ),
                  color: Theme.of(context).primaryColor,
                  elevation: Dimension.SMALL,
                  splashColor: Colors.blueGrey,
                  onPressed: () {
                    Utils.showAlert(context,
                        message: Constants.messageDeleteConfirm, onCancel: () {
                      Navigator.pop(context);
                    }, onConfirm: () {
                      Navigator.pop(context);
                      bloc.add(BlocEvent(Event.DELETE_DATA, booking.bookingId));
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildTextWidget({String labelText, String value}) {
    return Container(
      padding: EdgeInsets.all(Dimension.MEDIUM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(labelText, style: Theme.of(context).textTheme.subtitle2),
          Padding(padding: EdgeInsets.only(top: Dimension.SMALL)),
          Text(value, style: Theme.of(context).textTheme.subtitle1),
        ],
      ),
    );
  }
}
