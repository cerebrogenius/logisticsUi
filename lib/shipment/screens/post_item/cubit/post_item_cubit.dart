import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_bloc_app/shipment/utilities/constants.dart';

// part 'post_item_state.dart';
enum ItemStatus { processing, created, delivered, inTransit }

class PostItemCubitState extends Equatable {
  final String? currentStatus;
  final DateTime? date;

  const PostItemCubitState({
    this.currentStatus= 'Processing',
    this.date,
  });
  PostItemCubitState copyWith({DateTime? date, String? status}) {
    return PostItemCubitState(
      date: date,
      currentStatus: status ?? this.currentStatus,
    );
  }

  @override
  List<Object?> get props => [date, currentStatus];
}

class PostItemCubit extends Cubit<PostItemCubitState> {
  PostItemCubit() : super(const PostItemCubitState());

  updateDate({required DateTime? newDate}) {
    emit(
      state.copyWith(date: newDate),
    );
  }

  updateStatus({required ItemStatus status}) {
    if (status == ItemStatus.created) {
      emit(
        state.copyWith(status: statusList[0]),
      );
    } else if (status == ItemStatus.created) {
      emit(
        state.copyWith(status: statusList[1]),
      );
    } else if (status == ItemStatus.delivered) {
      emit(
        state.copyWith(status: statusList[2]),
      );
    } else if (status == ItemStatus.inTransit) {
      emit(
        state.copyWith(status: statusList[3]),
      );
    }
  }

  changeStatus({required currentStatus}) {
    emit(
      state.copyWith(status: currentStatus),
    );
  }
}
