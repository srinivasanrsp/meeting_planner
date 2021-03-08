import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meeting_planner/models/booking.dart';
import 'package:meeting_planner/repository/data_repository.dart';
import 'package:meeting_planner/ui/base/base_widget_state.dart';
import 'package:meeting_planner/ui/base/bloc_event.dart';
import 'package:meeting_planner/ui/base/bloc_state.dart';
import 'package:meeting_planner/ui/new_booking/new_booking_bloc.dart';
import 'package:meeting_planner/utils/constants.dart';
import 'package:meeting_planner/utils/data_helper.dart';
import 'package:meeting_planner/utils/date_utils.dart';
import 'package:meeting_planner/utils/dimension_utils.dart';
import 'package:meeting_planner/utils/utils.dart';

class NewBookingWidget extends StatefulWidget {
  @override
  _NewBookingWidgetState createState() =>
      _NewBookingWidgetState(NewBookingBloc(DataRepository()));
}

class _NewBookingWidgetState
    extends BaseWidgetState<NewBookingBloc, NewBookingWidget> {
  final String keyMeetingRoomSelection = "MeetingRoom";
  final String keyPrioritySelection = "Priority";
  final String keyReminderSelection = "Reminder";

  TextEditingController titleEditController = TextEditingController();
  TextEditingController descEditController = TextEditingController();
  TextEditingController dateEditController = TextEditingController();
  TextEditingController startTimeEditController = TextEditingController();
  TextEditingController durationEditController = TextEditingController();
  TimeOfDay selectedDuration;

  Map<String, Choice> selectionMap = Map();

  _NewBookingWidgetState(NewBookingBloc newBookingBloc)
      : super(bloc: newBookingBloc);

  @override
  void initState() {
    super.initState();
    selectedDuration = TimeOfDay(hour: 0, minute: 30);
  }

  @override
  Widget buildContentWidget(BlocState<dynamic> state) {
    if (state.event == Event.ADD_DATA && state.state == STATE.COMPLETED) {
      Utils.showToast(Constants.messageBooked);
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
          title: Text(Constants.titleNewBookings),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            String dateTimeStr =
                dateEditController.text + " " + startTimeEditController.text;
            DateTime dataTime =
                DateTimeUtils.covertToServerDateTimeFromDateString(
                    dateTimeStr, DateTimeUtils.PATTERN_DMY_H12MA);
            bloc.add(BlocEvent(
                Event.ADD_DATA,
                Booking(
                    title: titleEditController.text,
                    description: descEditController.text,
                    meetingRoom: selectionMap[keyMeetingRoomSelection],
                    meetingDateTime: dataTime,
                    meetingDuration: Duration(
                            hours: selectedDuration.hour,
                            minutes: selectedDuration.minute)
                        .inSeconds,
                    priority: selectionMap[keyPrioritySelection],
                    reminderDuration: selectionMap[keyReminderSelection])));
          },
          child: Icon(Icons.date_range_outlined, color: Colors.white),
        ),
        body: state.event == Event.ADD_DATA && state.state == STATE.LOADING
            ? Stack(
                children: <Widget>[
                  _buildNewBookingWidget(state),
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
            : _buildNewBookingWidget(state));
  }

  _buildNewBookingWidget(BlocState state) {
    return Container(
      margin: EdgeInsets.all(Dimension.X_LARGE),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel(Constants.labelTitle),
            Utils.buildFormField(controller: titleEditController),
            _buildLabel(Constants.labelDescription),
            Utils.buildFormField(controller: descEditController),
            _buildLabel(Constants.labelMeetingRoom),
            Utils.buildDropDownWidget(
                key: keyMeetingRoomSelection,
                choiceList: DataHelper.instance.meetingRooms,
                hint: Constants.labelMeetingRoom,
                value: selectionMap[keyMeetingRoomSelection],
                theme: Theme.of(context),
                onDropDownChange: (Choice value) {
                  setState(() {
                    selectionMap[keyMeetingRoomSelection] = value;
                  });
                }),
            _buildLabel(Constants.labelMeetingDate),
            Utils.buildDateTimeField(
                controller: dateEditController,
                onDateClick: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _chooseDate(context, dateEditController);
                }),
            _buildLabel(Constants.labelStartTime),
            Utils.buildDateTimeField(
                controller: startTimeEditController,
                onTimeClick: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _chooseTime(context, startTimeEditController);
                }),
            _buildLabel(Constants.labelMeetingDuration),
            Utils.buildDateTimeField(
                controller: durationEditController,
                onTimeClick: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _chooseTimeDuration(context, durationEditController);
                }),
            _buildLabel(Constants.labelPriority),
            Utils.buildDropDownWidget(
                key: keyPrioritySelection,
                choiceList: DataHelper.instance.priorityOptions,
                hint: Constants.hintSelectPriority,
                value: selectionMap[keyPrioritySelection],
                theme: Theme.of(context),
                onDropDownChange: (Choice value) {
                  setState(() {
                    selectionMap[keyPrioritySelection] = value;
                  });
                }),
            _buildLabel(Constants.labelReminderDuration),
            Utils.buildDropDownWidget(
                key: keyReminderSelection,
                choiceList: DataHelper.instance.reminderOptions,
                hint: Constants.hintSelectReminder,
                value: selectionMap[keyReminderSelection],
                theme: Theme.of(context),
                onDropDownChange: (Choice value) {
                  setState(() {
                    selectionMap[keyReminderSelection] = value;
                  });
                }),
          ],
        ),
      ),
    );
  }

  _buildLabel(String labelText) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimension.LARGE),
      child: Text(labelText,
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: TextSize.LARGE)),
    );
  }

  DateTime convertToDate(String input) {
    try {
      var d = new DateFormat.yMd().parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }

  Future _chooseDate(
      BuildContext context, TextEditingController _controller) async {
    DateTime now = DateTime.now();
    DateTime initialDate = convertToDate(_controller.text) ?? now;
    initialDate = (initialDate.year >= 1900 && initialDate.isBefore(now)
        ? initialDate
        : now);
    var result = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(now.year + 1, now.month, now.day));

    if (result == null) return;

    setState(() {
      _controller.text = DateFormat(DateTimeUtils.PATTERN_DMY).format(result);
    });
  }

  Future _chooseTime(
      BuildContext context, TextEditingController _controller) async {
    try {
      var result = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        },
      );
      if (result == null) {
        return;
      }
      DateTime now = DateTime.now();
      DateTime officeStartTime = DateTime(
          now.year,
          now.month,
          now.day,
          DataHelper.instance.officeStartTime.hour,
          DataHelper.instance.officeStartTime.minute);
      DateTime officeEndTime = DateTime(
          now.year,
          now.month,
          now.day,
          DataHelper.instance.officeEndTime.hour,
          DataHelper.instance.officeEndTime.minute);
      DateTime selectedTime =
          DateTime(now.year, now.month, now.day, result.hour, result.minute);
      officeStartTime = officeStartTime.add(Duration(minutes: -1));
      officeEndTime = officeEndTime.add(Duration(minutes: 1));
      if (selectedTime.isAfter(officeStartTime) &&
          selectedTime.isBefore(officeEndTime)) {
        setState(() {
          _controller.text =
              DateFormat(DateTimeUtils.PATTERN_H12MA).format(selectedTime);
        });
      } else {
        Utils.showToast(Constants.messageInvalidTime);
      }
    } catch (_) {
      print(_);
    }
  }

  Future _chooseTimeDuration(
      BuildContext context, TextEditingController _controller) async {
    try {
      var result = await showTimePicker(
        context: context,
        initialTime: selectedDuration,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        },
      );

      if (result == null) return;
      DateTime time = DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, result.hour, result.minute);
      selectedDuration = TimeOfDay(hour: time.hour, minute: time.minute);
      setState(() {
        _controller.text = DateFormat(DateTimeUtils.PATTERN_HM).format(time);
      });
    } catch (_) {
      print(_);
    }
  }
}
