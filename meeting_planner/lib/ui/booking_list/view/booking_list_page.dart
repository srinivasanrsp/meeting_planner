import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meeting_planner/models/booking.dart';
import 'package:meeting_planner/ui/base/base_widget_state.dart';
import 'package:meeting_planner/ui/base/bloc_event.dart';
import 'package:meeting_planner/ui/base/bloc_state.dart';
import 'package:meeting_planner/ui/booking_list/bloc/booking_list_bloc.dart';
import 'package:meeting_planner/ui/new_booking/new_booking_widget.dart';
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
  DateTime selectedDate = DateTime.now();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bloc.add(BlocEvent(Event.GET_DATA, selectedDate));
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

  _buildBookingListPage({BlocState state}) {
    Widget contentWidget = Container();
    if (state.state == STATE.LOADING) {
      contentWidget = super.buildLoadingWidget(state);
    } else if (state.state == STATE.COMPLETED) {
      List<Booking> bookings = state.data;
      contentWidget = bookings != null && bookings.isNotEmpty
          ? ListView.builder(itemBuilder: (context, index) {
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
          title: Center(child: Text(Constants.titleBookings)),
        ),
        body: Column(children: [
          InkWell(
            onTap: () {
              _selectDate();
            },
            child: Card(
              margin: EdgeInsets.all(DimensionUtils.LARGE),
              child: Container(
                padding: EdgeInsets.only(
                    left: DimensionUtils.X_LARGE,
                    right: DimensionUtils.LARGE,
                    top: DimensionUtils.LARGE,
                    bottom: DimensionUtils.LARGE),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        DateTimeUtils.getLocalDateTimeFromServerDateTime(
                            selectedDate,
                            dateFormat: DateTimeUtils.PATTERN_DATE),
                        style: TextStyle(
                            fontSize: TextSize.XX_LARGE,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                    Icon(
                      Icons.date_range_outlined,
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(child: contentWidget)
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NewBookingWidget()));
          },
          child: Icon(Icons.add, color: Colors.white),
        ));
  }

  _buildBookingListItemWidget(Booking booking) {
    return Container();
  }

  Future<Null> _selectDate() async {
    if (selectedDate == null) {
      selectedDate = DateTime.now();
    }
    DateTime today = DateTime.now();
    DateTime startDate = DateTime(1900, 1),
        endDate = DateTime(today.year + 10, 12, 31);
    String dateFormat = DateTimeUtils.PATTERN_DATE;

    final DateTime picked = await showDatePicker(
        initialDatePickerMode: DatePickerMode.day,
        initialEntryMode: DatePickerEntryMode.calendar,
        context: context,
        initialDate: selectedDate,
        firstDate: startDate,
        lastDate: endDate);
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        String formattedDate = DateFormat(dateFormat).format(picked);
      });
  }
}
