// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

PushNotificationModel pushnotificationModelFromJson(String str) =>
    PushNotificationModel.fromJson(json.decode(str));

String pushnotificationModelToJson(PushNotificationModel data) =>
    json.encode(data.toJson());

class PushNotificationModel {
  PushNotificationModel({
    this.body,
    this.title,
  });

  String? body;
  String? title;

  factory PushNotificationModel.fromJson(Map<String, dynamic> json) =>
      PushNotificationModel(
        body: json["body"] ?? "",
        title: json["title"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "body": body,
        "title": title,
      };
}
