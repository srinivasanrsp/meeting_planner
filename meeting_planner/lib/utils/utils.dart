import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meeting_planner/models/booking.dart';
import 'package:meeting_planner/utils/dimension_utils.dart';

class Utils {
  /// Construct a color from a hex code string, of the format #RRGGBB.
  static Color hexToColor(String code) {
    return code == null
        ? null
        : Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  static Widget buildFormField(
      {TextEditingController controller,
      int maxLines = 1,
      String hintText,
      String value}) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimension.LARGE),
      child: TextFormField(
        controller: controller,
        style: TextStyle(fontSize: TextSize.X_LARGE),
        validator: (val) => val.isEmpty ? '$hintText is required' : null,
      ),
    );
  }

  static Widget buildDateTimeField(
      {TextEditingController controller,
      int maxLines = 1,
      String hintText,
      String value,
      Function onDateClick,
      Function onTimeClick}) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimension.LARGE),
      child: InkWell(
          child: Container(
              child: TextFormField(
                  decoration: InputDecoration(
                      labelStyle: TextStyle(fontSize: TextSize.X_LARGE),
                      labelText: hintText,
                      suffixIcon: Icon(onDateClick != null
                          ? Icons.date_range
                          : Icons.access_time)),
                  style: TextStyle(fontSize: TextSize.X_LARGE),
                  controller: controller,
                  enabled: false)),
          onTap: (() {
            if (onDateClick != null) {
              onDateClick();
            } else {
              onTimeClick();
            }
          })),
    );
  }

  static Widget buildDropDownWidget(
      {List<Choice> choiceList,
      String key,
      String hint,
      Choice value,
      Function onDropDownChange,
      ThemeData theme}) {
    return Container(
      margin: EdgeInsets.only(top: Dimension.MEDIUM, bottom: Dimension.MEDIUM),
      padding: EdgeInsets.only(right: Dimension.LARGE),
      child: DropdownButton(
        key: ObjectKey(key),
        isExpanded: true,
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black38,
        ),
        iconSize: Dimension.XX_LARGE,
        hint: Text(hint),
        elevation: 16,
        underline: Container(height: 1, color: Colors.black38),
        value: value,
        onChanged: (Choice newValue) {
          onDropDownChange(newValue);
        },
        items: _buildDropdownMenuItems(choiceList, theme),
      ),
    );
  }

  static _buildDropdownMenuItems(List<Choice> choiceList, ThemeData theme) {
    List<DropdownMenuItem<Choice>> items = List.empty(growable: true);
    choiceList.forEach((element) {
      items.add(DropdownMenuItem(
          value: element,
          child: Text(
            element.name,
            style: theme.textTheme.subtitle1,
          )));
    });
    return items;
  }

  static showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
