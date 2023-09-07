import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:my_bloc_app/shipment/utilities/constants.dart';

import '../../../models/item_model.dart';
import '../../../network/network_request.dart';

// part 'details_state.dart';

class DetailsCubitState extends Equatable {
  final String? currentStatus;
  final DateTime? date;
  final String? location;

  const DetailsCubitState({
    this.location,
    this.date,
    this.currentStatus,
  });
  DetailsCubitState copyWith({
    String? currentStatus,
    DateTime? date,
    String? location,
  }) {
    return DetailsCubitState(
      currentStatus: currentStatus ?? this.currentStatus,
      date: date ?? this.date,
      location: location ?? this.location,
    );
  }

  @override
  List<Object?> get props => [
        currentStatus,
        date,
        location,
      ];
}

class DetailsCubit extends Cubit<DetailsCubitState> {
  DetailsCubit()
      : super(
          DetailsCubitState(
            currentStatus: statusList[0],
            location: locationslist[0],
          ),
        );

  updateStatus(String status) {
    emit(
      state.copyWith(
        currentStatus: status,
      ),
    );
  }

  updateDate(DateTime? date) {
    emit(state.copyWith(date: date));
  }

  updateLocation(String? location) {
    emit(state.copyWith(location: location));
  }

  Future<String?> editItem(
      {required String id,
      required String accessToken,
      required Items item}) async {
    final response = await HttpRequest().updateItem(
      id,
      accessToken,
      item,
    );
    if (response == 'success') {
      print('success');
    }
    return response;
  }
}
