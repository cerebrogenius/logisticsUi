class Items {
  final String? name;
  final DateTime? date;
  final String? status;
  final String? location;
  final String? note;
  final String? owner;
  final String? email;
  final String? phoneNumber;
  final String? id;

  Items({
    this.name,
    this.date,
    this.status,
    this.location,
    this.note,
    this.owner,
    this.email,
    this.phoneNumber,
    this.id,
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
        'name': item.owner??'',
        'email': item.email??'',
        'phone_no': item.phoneNumber??'',
      }
    };
  }

  Items itemFromNetwork(Map<String, dynamic> map) {
    return Items(
      name: map['name'],
      date: DateTime.tryParse(map['timeline'][0]['date']),
      status: map['timeline'][0]['status'],
      location: map['timeline'][0]['location'],
      note: map['timeline'][0]['note'],
      owner: map['owner']['name'],
      email: map['owner']['email'],
      phoneNumber: map['owner']['phone_no'].toString(),
      id: map['_id']
    );
  }
}
