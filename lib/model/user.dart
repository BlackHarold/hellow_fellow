class UserObject {
  String id;
  String name;
  String imageUrl;
  bool isOnline = false;

  UserObject(this.id);

  @override
  String toString() {
    return 'UserObject{id: $id, name: $name, imageUrl: $imageUrl, isOnline: $isOnline}';
  }
}
