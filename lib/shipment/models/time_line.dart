class TimeLine {
  final DateTime date;
  final String status;
  final String note;
  final String location;
  const TimeLine({
    required this.date,
    required this.status,
    required this.note,
    required this.location,
  });
  factory TimeLine.getTimelineFromMap(Map<String, dynamic> json) {
    return TimeLine(
      date: DateTime.parse(json['date']),
      status: json['status'],
      note: json['note'],
      location: json['location'],
    );
  }
}
