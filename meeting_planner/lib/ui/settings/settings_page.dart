import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:meeting_planner/models/booking.dart';
import 'package:meeting_planner/notification/local_notification.dart';
import 'package:meeting_planner/ui/base/base_widget_state.dart';
import 'package:meeting_planner/ui/base/bloc_state.dart';
import 'package:meeting_planner/ui/booking_list/booking_list_bloc.dart';
import 'package:meeting_planner/utils/data_helper.dart';
import 'package:meeting_planner/utils/date_utils.dart';
import 'package:meeting_planner/utils/dimension_utils.dart';
import 'package:meeting_planner/utils/utils.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage();

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState
    extends BaseWidgetState<BookingListBloc, SettingsPage> {
  TextEditingController startTimeEditController = TextEditingController();
  TextEditingController endTimeEditController = TextEditingController();

  TimeOfDay startTime;
  TimeOfDay endTime;

  bool isNotificationEnabled = true;

  @override
  void initState() {
    super.initState();
    startTime = DataHelper.instance.officeStartTime;
    endTime = DataHelper.instance.officeEndTime;
    DateTime today = DateTime.now();
    startTimeEditController.text = DateFormat(DateTimeUtils.PATTERN_HM).format(
        DateTime(today.year, today.month, today.day, startTime.hour,
            startTime.minute));
    endTimeEditController.text = DateFormat(DateTimeUtils.PATTERN_HM).format(
        DateTime(
            today.year, today.month, today.day, endTime.hour, endTime.minute));
    isNotificationEnabled = DataHelper.instance.isNotificationEnabled;
  }

  Widget _buildContent(BlocState<dynamic> state) {
    List<Booking> bookingList = state.data;
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                DataHelper.instance.officeStartTime = startTime;
                DataHelper.instance.officeEndTime = endTime;
                DataHelper.instance.isNotificationEnabled =
                    isNotificationEnabled;
                if (isNotificationEnabled) {
                  LocalNotification.instance.scheduledNotification(bookingList);
                } else {
                  LocalNotification.instance.cancel();
                }
                Utils.showToast("Setting saved successfully");
              })
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(Dimension.LARGE),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.only(
                    left: Dimension.MEDIUM, right: Dimension.MEDIUM),
                child: Container(
                  height: 140,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            left: Dimension.LARGE,
                            right: Dimension.LARGE,
                            top: Dimension.MEDIUM),
                        child: Text(
                          "Office Hours",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: TextSize.X_LARGE),
                        ),
                      ),
                      Divider(),
                      Expanded(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Start Time"),
                                  InkWell(
                                    onTap: () {
                                      _chooseTime(context,
                                          startTimeEditController, true);
                                    },
                                    child: Container(
                                      width: 150,
                                      margin: EdgeInsets.only(
                                          bottom: Dimension.LARGE),
                                      child: TextFormField(
                                          decoration: InputDecoration(
                                            labelStyle: TextStyle(
                                                fontSize: TextSize.X_LARGE),
                                          ),
                                          style: TextStyle(
                                              fontSize: TextSize.X_LARGE),
                                          controller: startTimeEditController,
                                          enabled: false),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("End Time"),
                                  InkWell(
                                    onTap: () {
                                      _chooseTime(context,
                                          endTimeEditController, false);
                                    },
                                    child: Container(
                                      width: 150,
                                      margin: EdgeInsets.only(
                                          bottom: Dimension.LARGE),
                                      child: TextFormField(
                                        controller: endTimeEditController,
                                        enabled: false,
                                        style: TextStyle(
                                            fontSize: TextSize.X_LARGE),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Card(
                margin: EdgeInsets.only(
                    left: Dimension.MEDIUM, right: Dimension.MEDIUM),
                child: Container(
                  width: double.infinity,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Notification",
                            style: TextStyle(fontSize: TextSize.X_LARGE)),
                        Switch(
                            activeColor: Theme.of(context).primaryColor,
                            value: isNotificationEnabled,
                            onChanged: (value) {
                              setState(() {
                                isNotificationEnabled = value;
                              });
                            },
                            inactiveThumbColor: Colors.white)
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _chooseTime(BuildContext context, TextEditingController _controller,
      bool isStartTime) async {
    try {
      var result = await showTimePicker(
        context: context,
        initialTime: isStartTime ? startTime : endTime,
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
      if (isStartTime) {
        startTime = TimeOfDay(hour: time.hour, minute: time.minute);
      } else {
        endTime = TimeOfDay(hour: time.hour, minute: time.minute);
      }
      setState(() {
        _controller.text = DateFormat(DateTimeUtils.PATTERN_HM).format(time);
      });
    } catch (_) {
      print(_);
    }
  }

  @override
  Widget buildContentWidget(BlocState<dynamic> state) {
    return _buildContent(state);
  }

  @override
  Widget buildIdleWidget(BlocState<dynamic> state) {
    return _buildContent(state);
  }

  @override
  Widget buildLoadingWidget(BlocState<dynamic> state) {
    return _buildContent(state);
  }
}
