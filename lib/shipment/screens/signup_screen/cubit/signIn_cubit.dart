import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_bloc_app/shipment/models/user_model.dart';
import 'package:my_bloc_app/shipment/network/network_request.dart';

part 'signin_cubit_state.dart';

enum SignInState { initial, loading, success, error }

class SignInStates {
  final SignInState signInState;
  final String error;
  final bool login;

  const SignInStates(
      {this.error = '',
      this.signInState = SignInState.initial,
      this.login = false});

  SignInStates copyWith({SignInState? status, String? error, bool? login}) {
    return SignInStates(
        signInState: status ?? signInState,
        error: error ?? this.error,
        login: login ?? this.login);
  }

  // @override
  // List<Object?> get props => [loginState, error];
}

class SignInCubit extends Cubit<SignInStates> {
  SignInCubit()
      : super(const SignInStates(signInState: SignInState.initial, error: ''));

  createUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      emit(state.copyWith(status: SignInState.loading, error: ''));

      final result = await HttpRequest().registerNewUser(
        user: UserModel(name: name, email: email, password: password),
      );

      if (result == 'success') {
        emit(state.copyWith(
            status: SignInState.success,
            error: 'Account created, proceed to login page',
            login: true));
      } else {
        emit(state.copyWith(
            status: SignInState.error, error: result, login: false));
      }
    } catch (e, s) {
      emit(state.copyWith(status: SignInState.error, error: e.toString()));
    }
  }
}
// we,we@gmail.com,where