final class UserModel {
  UserModel(this.uid, this.username, this.password, this.authorized, this.queries, this.queryWithDate);

  String uid;
  String username;
  String password;
  bool authorized;
  Map<String, dynamic> queries;
  String queryWithDate;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        json['uid'] as String,
        json['username'] as String,
        json['password'] as String,
        json['authorized'] as bool,
        json['queries'] as Map<String, dynamic>,
        json['queryWithDate'] as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'uid': uid,
        'username': username,
        'password': password,
        'authorized': authorized,
        'queries': queries,
        'queryWithDate': queryWithDate,
      };
}
