import 'package:todo/data/models/user_model.dart';
import 'package:todo/utils/constants.dart';
import 'package:todo/utils/network/api_base_helper.dart';

class UserRepository {
  Future<UserModel> Login(String email, String password) async {
    ApiBaseHelper apiBaseHelper = ApiBaseHelper();
    var body = {"username": email, "password": password};
    var result = await apiBaseHelper.formPost(Constants.logIn, body);

    var user = UserModel.fromJson(result);
    return user;
  }
}
