import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meeting_planner/models/booking.dart';
import 'package:meeting_planner/notification/local_notification.dart';
import 'package:meeting_planner/ui/base/base_widget_state.dart';
import 'package:meeting_planner/ui/base/bloc_event.dart';
import 'package:meeting_planner/ui/base/bloc_state.dart';
import 'package:meeting_planner/ui/booking_list/booking_list_bloc.dart';
import 'package:meeting_planner/ui/new_booking/new_booking_widget.dart';
import 'package:meeting_planner/ui/settings/settings_page.dart';
import 'package:meeting_planner/utils/constants.dart';
import 'package:meeting_planner/utils/date_utils.dart';
import 'package:meeting_planner/utils/dimension_utils.dart';
import 'package:meeting_planner/utils/utils.dart';

class BookingListPage extends StatefulWidget {
  @override
  _BookingListPageState createState() => _BookingListPageState();
}

class _BookingListPageState
    extends BaseWidgetState<BookingListBloc, BookingListPage> {
  DateTime selectedDate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeNotification();
    if (selectedDate == null) {
      selectedDate = DateTime.now();
    }
    bloc.add(BlocEvent(Event.GET_DATA));
  }

  _initializeNotification() {
    LocalNotification _localNotification = LocalNotification.instance;
    _localNotification.initialize();
  }

  @override
  Widget buildContentWidget(BlocState<dynamic> state) {
    return _buildBookingListPage(state: state);
  }

  @override
  Widget buildIdleWidget(BlocState state) {
    return _buildBookingListPage(state: state);
  }

  @override
  Widget buildLoadingWidget(BlocState<dynamic> state) {
    return _buildBookingListPage(state: state);
  }

  void handleMenuItemClick(String value) async {
    switch (value) {
      case Constants.menuSettings:
        {
          final result = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => SettingsPage()));
          if (result != null) {
            bloc.add(BlocEvent(Event.GET_DATA, selectedDate));
          }
        }
        break;
    }
  }

  _buildBookingListPage({BlocState state}) {
    Widget contentWidget = Container();
    if (state.state == STATE.LOADING) {
      contentWidget = super.buildLoadingWidget(state);
    } else if (state.state == STATE.COMPLETED) {
      List<Booking> bookings = state.data;
      contentWidget = bookings != null && bookings.isNotEmpty
          ? ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                return _buildBookingListItemWidget(bookings.elementAt(index));
              })
          : Center(
              child: Text(
                Constants.noMeetingAvailable,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            );
    }
    return Scaffold(
        backgroundColor: Utils.hexToColor(Constants.colorBackground),
        appBar: AppBar(
          title: Text(Constants.titleBookings),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleMenuItemClick,
              itemBuilder: (BuildContext context) {
                return {Constants.menuSettings}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: Column(children: [
          InkWell(
            onTap: () {
              _selectDate();
            },
            child: Card(
              margin: EdgeInsets.all(Dimension.LARGE),
              child: Container(
                padding: EdgeInsets.only(
                    left: Dimension.X_LARGE,
                    right: Dimension.LARGE,
                    top: Dimension.LARGE,
                    bottom: Dimension.LARGE),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.date_range_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: Dimension.LARGE, right: Dimension.LARGE),
                        child: Text(
                          DateTimeUtils.getLocalDateTimeFromServerDateTime(
                              selectedDate,
                              dateFormat: DateTimeUtils.PATTERN_DMY),
                          style: TextStyle(
                              fontSize: TextSize.XX_LARGE,
                              color:
                                  Theme.of(context).textTheme.subtitle1.color),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(child: contentWidget)
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => NewBookingWidget()));
            if (result != null) {
              selectedDate = DateTime.now();
              bloc.add(BlocEvent(Event.GET_DATA, selectedDate));
            }
          },
          child: Icon(Icons.add, color: Colors.white),
        ));
  }

  _buildBookingListItemWidget(Booking booking) {
    return Container(
      child: Card(
        margin: EdgeInsets.all(Dimension.X_LARGE),
        child: Container(
          height: 120,
          child: Row(
            children: [
              Container(
                height: double.infinity,
                padding: EdgeInsets.all(Dimension.LARGE),
                color: Theme.of(context).primaryColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: Dimension.MEDIUM),
                      child: Text(
                          DateFormat(DateTimeUtils.PATTERN_H12MA)
                              .format(booking.meetingDateTime),
                          style: TextStyle(
                              color: Colors.white, fontSize: TextSize.X_LARGE)),
                    ),
                    Text("to",
                        style: TextStyle(
                            color: Colors.white, fontSize: TextSize.LARGE)),
                    Padding(
                      padding: const EdgeInsets.only(top: Dimension.MEDIUM),
                      child: Text(
                          DateFormat(DateTimeUtils.PATTERN_H12MA).format(booking
                              .meetingDateTime
                              .add(Duration(seconds: booking.meetingDuration))),
                          style: TextStyle(
                              color: Colors.white, fontSize: TextSize.X_LARGE)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: double.infinity,
                  padding: EdgeInsets.all(Dimension.LARGE),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(booking.title,
                                  style: Theme.of(context).textTheme.subtitle1),
                            ),
                            Text(booking.priority.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Utils.hexToColor(
                                        booking.priority.colorCode)))
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: Dimension.MEDIUM)),
                      Expanded(
                        child: Text(booking.description,
                            maxLines: 2,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.subtitle2),
                      ),
                      Padding(padding: EdgeInsets.only(top: Dimension.MEDIUM)),
                      Container(
                        color: Utils.hexToColor(booking.meetingRoom.colorCode),
                        padding: EdgeInsets.all(Dimension.SMALL),
                        child: Text(booking.meetingRoom.name,
                            style: TextStyle(color: Colors.white)),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _selectDate() async {
    DateTime today = DateTime.now();
    DateTime startDate = DateTime(1900, 1),
        endDate = DateTime(today.year + 10, 12, 31);

    final DateTime picked = await showDatePicker(
        initialDatePickerMode: DatePickerMode.day,
        initialEntryMode: DatePickerEntryMode.calendar,
        context: context,
        initialDate: selectedDate,
        firstDate: startDate,
        lastDate: endDate);
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      setState(() {});
      bloc.add(BlocEvent(Event.GET_DATA, selectedDate));
    }
  }
}
