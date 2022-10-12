import 'dart:io';

class NewOrderBody {
  int _userId;
  String _type;
  String _subject;
  String _description;
  String _quantity;
  String _price;
  File _photo;

  NewOrderBody(int userId, String type, String subject, String description, String quantity,String price,File photo) {
    this._userId = userId;
    this._type = type;
    this._subject = subject;
    this._description = description;
    this._quantity = quantity;
    this._price = price;
    this._photo = photo;
  }

  int get userId => _userId;
  String get type => _type;
  String get subject => _subject;
  String get description => _description;
  String get quantity => _quantity;
  String get price => _price;
  File get photo => _photo;

  NewOrderBody.fromJson(Map<String, dynamic> json) {
    _userId = json['user_id'];
    _type = json['type'];
    _subject = json['subject'];
    _description = json['description'];
    _quantity = json['quantity'];
    _price = json['price'];
    _photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this._userId;
    data['type'] = this._type;
    data['subject'] = this._subject;
    data['description'] = this._description;
    data['quantity'] = this._quantity;
    data['price'] = this._price;
    data['photo'] = this._photo;
    return data;
  }
}
