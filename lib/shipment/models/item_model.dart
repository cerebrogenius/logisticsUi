class Items {
  final String? name;
  final DateTime? date;
  final String? status;
  final String? location;
  final String? note;
  final String? owner;
  final String? email;
  final String? phoneNumber;

  Items({
    this.name,
    this.date,
    this.status,
    this.location,
    this.note,
    this.owner,
    this.email,
    this.phoneNumber,
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
    );
  }
}
// {"_id":"64ee7c2c480687ed75e339d8",
// "creator":"yakubayoola96@gmail.com",
// "name":"system",
// "timeline":[{"date":"2023-08-29 18:51:53.723636","status":"In Transit","note":"order created","location":"unilorin"}],
// "owner":{"_id":"64ee7c2c480687ed75e339d9",
// "name":"Shola","email":"shola@gmail.com",
// "phone_no":8050664367}}
