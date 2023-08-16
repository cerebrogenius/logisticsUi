import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_bloc_app/shipment/network/network_request.dart';

// part 'login_cubit_state.dart';

enum LoginStates { initial, loading, success, error }

class LoginCubitState {
  final String access;
  final String refresh;
  final bool isLoggedIn;
  final LoginStates loginState;
  final String error;

  LoginCubitState(
      {this.error = '',
      this.access = '',
      this.refresh = '',
      this.isLoggedIn = false,
      this.loginState = LoginStates.initial});
  LoginCubitState copyWith({
    String? access,
    String? refresh,
    bool? isLoggedIn,
    LoginStates? loginState,
    String? error,
  }) {
    return LoginCubitState(
        error: error ?? this.error,
        access: access ?? this.access,
        refresh: refresh ?? this.refresh,
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
        loginState: loginState ?? this.loginState);
  }
}

class LoginCubit extends Cubit<LoginCubitState> {
  LoginCubit() : super(LoginCubitState(loginState: LoginStates.initial));

  loginUser({
    required String email,
    required String password,
  }) async {
    try {
      emit(state.copyWith(loginState: LoginStates.loading, error: ''));
      List response = await HttpRequest().loginUser(
        email: email,
        password: password,
      );
      if (response[0] == 'success') {
        emit(
          state.copyWith(loginState: LoginStates.success, error: '', isLoggedIn: true),
        );
      } else {
        emit(
          state.copyWith(loginState: LoginStates.error, error: response[0]),
        );
      }
    } on Exception catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
