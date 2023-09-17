class ItemTimeLine {
  final DateTime date;
  final String status;
  final String note;
  final String location;
  const ItemTimeLine({
    required this.date,
    required this.status,
    required this.note,
    required this.location,
  });
  factory ItemTimeLine.getTimelineFromMap(Map<String, dynamic> json) {
    return ItemTimeLine(
      date: DateTime.parse(json['date']),
      status: json['status'],
      note: json['note'],
      location: json['location'],
    );
  }
}
