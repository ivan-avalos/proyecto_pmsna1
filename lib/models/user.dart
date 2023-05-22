class FsUser {
  final String uid;
  final String displayName;
  final String photoUrl;
  final String email;
  final List<String> groups;

  const FsUser({
    required this.uid,
    required this.displayName,
    required this.photoUrl,
    required this.email,
    this.groups = const [],
  });

  factory FsUser.fromMap(Map<String, dynamic> map) {
    return FsUser(
      uid: map['uid'],
      displayName: map['displayName'],
      photoUrl: map['photoUrl'],
      email: map['email'],
      groups: map['groups'] ?? [],
    );
  }
}
