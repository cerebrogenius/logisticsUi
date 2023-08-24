import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_bloc_app/shipment/models/user_model.dart';
import 'package:my_bloc_app/shipment/network/network_request.dart';

// part 'login_cubit_state.dart';

enum LoginStates { initial, loading, success, error }

class LoginCubitState extends Equatable {
  final UserModel? user;
  final String access;
  final String refresh;
  final bool isLoggedIn;
  final LoginStates loginState;
  final String error;

  const LoginCubitState(
      {this.user,
      this.error = '',
      this.access = '',
      this.refresh = '',
      this.isLoggedIn = false,
      this.loginState = LoginStates.initial});
  LoginCubitState copyWith({
    UserModel? user,
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
      loginState: loginState ?? this.loginState,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [
        isLoggedIn,
        error,
        access,
        refresh,
        user,
      ];
}

class LoginCubit extends Cubit<LoginCubitState> {
  LoginCubit() : super(const LoginCubitState(loginState: LoginStates.initial));

  loginUser({
    required String email,
    required String password,
  }) async {
    try {
      emit(state.copyWith(loginState: LoginStates.loading, error: ''));
      await Future.delayed(Duration(seconds: 2));
      List response = await HttpRequest().loginUser(
        email: email,
        password: password,
      );
      if (response[0] == 'success') {
        emit(
          state.copyWith(
              loginState: LoginStates.success, error: '', isLoggedIn: true),
        );
        emit(state.copyWith(access: response[1]['access_token']));
      } else {
        emit(
          state.copyWith(loginState: LoginStates.error, error: response[0]),
        );
        return response[0];
      }
    } on Exception catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<UserModel> getUserDetails(String access) async {
    UserModel user = UserModel();
    try {
      user = await HttpRequest().getUserDetailsFromNetwork(access);

      emit(state.copyWith(user: user));
    } catch (e) {}
    return user;
  }

  Future<String> logOut(String access) async {
    try {
      String response = await HttpRequest().logoutUser(access);
      if (response == 'success') {
        emit(state.copyWith(isLoggedIn: false));
      }
      return response;
    } catch (e) {
      print(e);
      return 'error';
    }
  }
}
