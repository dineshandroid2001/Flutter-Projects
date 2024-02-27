class EventModel {
  final int? eventId;
  final String eventName;
  final String eventPlace;
  final String eventDate;
  final String eventTime;
  final String createdAt;

  EventModel({
    this.eventId,
    required this.eventName,
    required this.eventPlace,
    required this.eventDate,
    required this.eventTime,
    required this.createdAt,
  });

  factory EventModel.fromMap(Map<String, dynamic> json) => EventModel(
        eventId: json["eventId"],
        eventName: json["eventName"],
        eventPlace: json["eventPlace"],
        eventDate: json["eventDate"],
        eventTime: json["eventTime"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toMap() => {
        "eventId": eventId,
        "eventName": eventName,
        "eventPlace": eventPlace,
        "eventDate":eventDate,
        "eventTime":eventTime,
        "createdAt": createdAt,
      };
}