import 'dart:developer';

import 'package:mobx/mobx.dart';

import '../../core/exceptions/unauthorized_exception.dart';
import '../../services/auth/login_service.dart';
part 'login_controller.g.dart';

enum LoginStateStatus {
  initial,
  loading,
  success,
  error;
}

class LoginController = LoginControllerBase with _$LoginController;

abstract class LoginControllerBase with Store {
  final LoginService _loginService;

  @readonly
  String? _errorMessage;

  @readonly
  LoginStateStatus _loginStatus = LoginStateStatus.initial;

  LoginControllerBase(this._loginService);

  @action
  Future<void> login(String login, String password) async {
    try {
      _loginStatus = LoginStateStatus.loading;
      await _loginService.execute(login, password);
      _loginStatus = LoginStateStatus.success;
    } on UnauthorizedException catch (e) {
      _errorMessage = 'Login ou senha inválidos';
      _loginStatus = LoginStateStatus.error;
    } catch(e, s){
      log('Erro ao realizar login', error: e, stackTrace: s);
      _loginStatus = LoginStateStatus.error;
    }
  }
}
