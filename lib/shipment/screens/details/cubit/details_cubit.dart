import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_bloc_app/shipment/models/time_line.dart';
import 'package:my_bloc_app/shipment/utilities/constants.dart';

import '../../../models/item_model.dart';
import '../../../network/network_request.dart';

// part 'details_state.dart';

enum Update { loading, error, success, initial }

class DetailsCubitState extends Equatable {
  final List<TimeLine>? timelineList;
  final Update? updated;
  final TimeLine? timeLine;
  final String? currentStatus;
  final DateTime? date;
  final String? location;

  const DetailsCubitState({
    this.timelineList,
    this.updated,
    this.timeLine,
    this.location,
    this.date,
    this.currentStatus,
  });
  DetailsCubitState copyWith({
    List<TimeLine>? timelineList,
    Update? updated,
    String? currentStatus,
    DateTime? date,
    String? location,
    TimeLine? timeLine,
  }) {
    return DetailsCubitState(
      timelineList: timelineList ?? this.timelineList,
      updated: updated ?? this.updated,
      currentStatus: currentStatus ?? this.currentStatus,
      date: date ?? this.date,
      location: location ?? this.location,
      timeLine: timeLine ?? this.timeLine,
    );
  }

  @override
  List<Object?> get props => [
        currentStatus,
        date,
        location,
        timeLine,
        updated,
      ];
}

class DetailsCubit extends Cubit<DetailsCubitState> {
  DetailsCubit()
      : super(
          DetailsCubitState(
            currentStatus: statusList[0],
            location: locationslist[0],
            timelineList: const[],
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

  Future<List<TimeLine>> editItem(
      {required String id,
      required String accessToken,
      required Items item}) async {
    emit(
      state.copyWith(updated: Update.loading),
    );
    final response = await HttpRequest().updateItem(
      id,
      accessToken,
      item,
    );
    if (response[0] == 'success') {
      List timelines = response[1];
      List<TimeLine> timeLineFinal = [];

      for (Map<String, dynamic> data in timelines) {
        timeLineFinal.add(
          TimeLine.getTimelineFromMap(data),
        );
      }
      emit(
        state.copyWith(timelineList: timeLineFinal,
        updated: Update.success,
        ),
      );
      return timelines
          .map(
            (e) => TimeLine.getTimelineFromMap(e),
          )
          .toList();
    } else {
      emit(
        state.copyWith(updated: Update.error),
      );
    }
    return [];
  }
}