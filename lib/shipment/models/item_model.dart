class Items {
  final String name;
  final DateTime date;
  final String status;
  final String location;
  final String note;
  final String owner;
  final String email;
  final String phoneNumber;

  Items({
    required this.name,
    required this.date,
    required this.status,
    required this.location,
    required this.note,
    required this.owner,
    required this.email,
    required this.phoneNumber,
  });


  Map<String, dynamic> itemToMap({required Items item}) {
    return {
      'name': item.name,
      'timeline': [
        {
          'date': item.date.toString(),
          'status': item.status,
          'location': item.location,
          'note': item.note,
        }
      ],
      'owner': {
        'name': item.owner,
        'email': item.email,
        'phone_no': item.phoneNumber,
      }
    };
  }
}
