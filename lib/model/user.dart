class UserObject {
  String id;
  String name;
  String imageUrl;
  bool _isOnline = false;

  UserObject(this.id);

  bool get isOnline => _isOnline;

  set isOnline(bool value) {
    _isOnline = value;
  }
}
