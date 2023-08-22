import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

enum AuthStatus { authenticated, unauthenticated }

class AuthStateCubit extends Cubit<AuthStatus> {
  AuthStatus authStatus;
  bool isLoggedOut = false;

  AuthStateCubit({required this.authStatus})
      : super(AuthStatus.unauthenticated);

  void updateState(AuthStatus authStatus) {
    this.authStatus = authStatus;
    if (authStatus == AuthStatus.unauthenticated) {
      isLoggedOut = true;
    }
    emit(authStatus);
  }
}
