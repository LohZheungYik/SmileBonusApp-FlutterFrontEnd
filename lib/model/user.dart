class User {
  int? _id;
  String? _name;
  String? _email;
  String? _phoneNumber;
  String? _password;
  String? _type;
  String? _token;

  int? _points;
  double? _rePoints;


  set id(int i) {
    _id = i;
  }

  int get id => _id ?? 0;

  set name(String n) {
    _name = n;
  }

  String get name => _name ?? '';

  set email(String e) {
    _email = e;
  }

  String get email => _email ?? '';

  set phoneNumber(String p) {
    _phoneNumber = p;
  }

  String get phoneNumber => _phoneNumber ?? '';

  set password(String p) {
    _password = p;
  }

  String get password => _password ?? '';

  set type(String t) {
    _type = t;
  }

  String get type => _type ?? '';

  set token(String t) {
    _token = t;
  }

  String get token => _token ?? '';

  set points(int p){
    _points = p;
  }

  int get points => _points ?? 0;

  set rePoints(double p){
    _rePoints = p;
  }

  double get rePoints => _rePoints ?? 0;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'type': type,
    };
  }
}
