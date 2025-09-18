import 'package:todo/data/models/user_model.dart';
import 'package:todo/data/repositories/user_repository.dart';
import 'package:todo/services/secure_storage_service.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserRepository _repository;
  final SecureStorageService _storage = SecureStorageService();
  LoginCubit(this._repository) : super(LoginInitial());
  void userLogin(String email, String password) async {
    emit(LoginLoader());
    try {
      UserModel user = await _repository.Login(email, password);
      print(user.toJson());

      if (user.status == true) {
        if (user.token != null) {
          await _storage.saveToken(user.token!);
        }
        emit(LoginSuccesse());
      } else if (user.status == false) {
        emit(
          LoginFailure(error: user.message ?? "Someting went wrong try again"),
        );
      }
    } catch (e) {
      print(e.toString());
      emit(LoginFailure(error: e.toString()));
    }
  }
}
