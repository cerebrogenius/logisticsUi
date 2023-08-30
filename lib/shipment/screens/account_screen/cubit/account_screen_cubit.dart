import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../network/network_request.dart';

// part 'account_screen_state.dart';

enum ConfirmState { initial, loading, success, error }

class AccountScreenState {
  final String response;
  final ConfirmState accountstate;

  AccountScreenState({
    required this.accountstate,
    required this.response,
  });

  AccountScreenState copyWith({String? response, ConfirmState? state}) {
    return AccountScreenState(
      response: response ?? this.response,
      accountstate: state ?? this.accountstate,
    );
  }
}

class AccountScreenCubit extends Cubit<AccountScreenState> {
  AccountScreenCubit()
      : super(
          AccountScreenState(
              response: 'Activate Your Account', accountstate: ConfirmState.initial),
        );

  void changeButtonText({required String response}) {
    emit(
      state.copyWith(response: response),
    );
  }

  Future<String> checkStatus({required String accessToken}) async {
    emit(
      state.copyWith(
        state: ConfirmState.loading,
      ),
    );
    String reply = await HttpRequest().confirmUser(
      accessToken: accessToken,
    );
    if (reply == 'success') {
      emit(
        state.copyWith(
          state: ConfirmState.success,
          response: 'Confirm Account In Your Gmail'
        ),
      );
    } else {
      emit(
        state.copyWith(
          state: ConfirmState.error,
          response: 'Error Processing Request'
        ),
      );
    }
    return 'total failure';
  }
}
