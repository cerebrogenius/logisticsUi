import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:my_bloc_app/shipment/utilities/constants.dart';

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
  List<Object?> get props => [currentStatus, date];
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
      state.copyWith(currentStatus: status, date: DateTime.now()),
    );
  }

  updateDate(DateTime? date) {
    emit(state.copyWith(date: date));
  }

  updateLocation(String? location) {
    emit(state.copyWith(location: location));
  }
}
