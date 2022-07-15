import 'dart:convert';

ActivityModel activityModelFromJson(String str) =>
    ActivityModel.fromJson(json.decode(str));

String activityModelToJson(ActivityModel data) => json.encode(data.toJson());

class ActivityModel {
  ActivityModel({
    required this.created,
    this.assigned,
    this.resolved,
  });

  String created;
  List<String>? assigned;
  dynamic resolved;

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
        created: json["created"],
        assigned: List<String>.from(json["assigned"].map((x) => x)),
        resolved: json["resolved"],
      );

  Map<String, dynamic> toJson() => {
        "created": created,
        "assigned": List<dynamic>.from(assigned!.map((x) => x)),
        "resolved": resolved,
      };
}
