class UserModel {
  bool? status;
  String? message;
  String? token;
  bool? isSuperuser;
  UserDetails? userDetails;

  UserModel({
    this.status,
    this.message,
    this.token,
    this.isSuperuser,
    this.userDetails,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
    isSuperuser = json['is_superuser'];
    userDetails =
        json['user_details'] != null
            ? new UserDetails.fromJson(json['user_details'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['token'] = this.token;
    data['is_superuser'] = this.isSuperuser;
    if (this.userDetails != null) {
      data['user_details'] = this.userDetails!.toJson();
    }
    return data;
  }
}

class UserDetails {
  int? id;
  Null? lastLogin;
  String? name;
  String? phone;
  String? address;
  String? mail;
  String? username;
  String? password;
  String? passwordText;
  int? admin;
  bool? isAdmin;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  Null? branch;

  UserDetails({
    this.id,
    this.lastLogin,
    this.name,
    this.phone,
    this.address,
    this.mail,
    this.username,
    this.password,
    this.passwordText,
    this.admin,
    this.isAdmin,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.branch,
  });

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lastLogin = json['last_login'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    mail = json['mail'];
    username = json['username'];
    password = json['password'];
    passwordText = json['password_text'];
    admin = json['admin'];
    isAdmin = json['is_admin'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    branch = json['branch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['last_login'] = this.lastLogin;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['mail'] = this.mail;
    data['username'] = this.username;
    data['password'] = this.password;
    data['password_text'] = this.passwordText;
    data['admin'] = this.admin;
    data['is_admin'] = this.isAdmin;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['branch'] = this.branch;
    return data;
  }
}
