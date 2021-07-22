import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class Utils {
  static void showSnackBar(BuildContext context, String text) =>
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(text)));

  static DateTime toDateTime(Timestamp value) {
    return value.toDate();
  }

  static dynamic fromDateTimeToJson(DateTime date) {
    return date.toUtc();
  }

  static Map<String, dynamic> toMap(Object? data) {
    if (data is Map<String, dynamic>) {
      Map<String, dynamic> newMap = data;
      return newMap;
    } else {
      return Map();
    }
  }

  static StreamTransformer<QuerySnapshot<Map<String, dynamic>>, List<T>>
      transformer<T>(T Function(Map<String, dynamic> json) fromJson) {
    return StreamTransformer<QuerySnapshot<Map<String, dynamic>>,
        List<T>>.fromHandlers(
      handleData: (QuerySnapshot data, EventSink<List<T>> sink) {
        final List<Map<String, dynamic>> snaps =
            data.docs.map((doc) => toMap(doc.data())).toList();
        final objects = snaps.map((json) => fromJson(json)).toList();

        sink.add(objects);
      },
    );
  }

  static String toDateTimeString(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);
    final time = DateFormat.Hm().format(dateTime);

    return '$date $time';
  }

  static String toDateString(DateTime dateTime) {
    final date = DateFormat.yMMMEd().format(dateTime);

    return '$date';
  }

  static String toTimeString(DateTime dateTime) {
    final time = DateFormat.Hm().format(dateTime);

    return '$time';
  }

  static String fromColor(Color colorValue) {
    // print('The color full string is: ' + colorValue.toString());
    return colorValue.toString().substring(6, 16);
  }

  static Color toColor(String colorCode) {
    return Color(int.parse(colorCode));
  }

  static String toWeekDayString(int weekDayValue) {
    List<String> weekDayStrings = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return weekDayStrings[weekDayValue - 1];
  }

  static String toMonthString(int monthValue) {
    List<String> monthStrings = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'DEC',
      'NOV',
    ];
    return monthStrings[monthValue - 1];
  }

  static SvgPicture toCategorySVG({required String category, required width}) {
    return SvgPicture.asset(
      category == 'Study'
          ? 'assets/images/calendar_widget_book.svg'
          : category == 'Self Care'
              ? 'assets/images/calendar_widget_selfcare.svg'
              : category == 'Sports'
                  ? 'assets/images/calendar_widget_sport.svg'
                  : category == 'Family Time'
                      ? 'assets/images/calendar_widget_family.svg'
                      : 'assets/images/calendar_widget_pet.svg',
      fit: BoxFit.contain,
      width: width,
      height: 60,
    );
  }

  static Duration toDuration(String duration) {
    return duration == '<10 minutes'
        ? Duration(seconds: 0)
        : duration == '10 minutes'
            ? Duration(minutes: 10)
            : duration == '1 hour'
                ? Duration(hours: 1)
                : Duration(days: 1);
  }

  static List<String> toListOfString(List<dynamic> jsonList) {
    List<String> res = [];
    for (dynamic ele in jsonList) {
      res.add(ele);
    }
    return res;
  }
}
