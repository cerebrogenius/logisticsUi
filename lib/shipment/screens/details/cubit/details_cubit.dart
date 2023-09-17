import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_bloc_app/shipment/models/time_line.dart';
import 'package:my_bloc_app/shipment/utilities/constants.dart';

import '../../../models/item_model.dart';
import '../../../network/network_request.dart';

// part 'details_state.dart';

enum Update { loading, error, success, initial }

class DetailsCubitState extends Equatable {
  final List<ItemTimeLine>? timelineList;
  final Update? updated;
  final ItemTimeLine? timeLine;
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
    List<ItemTimeLine>? timelineList,
    Update? updated,
    String? currentStatus,
    DateTime? date,
    String? location,
    ItemTimeLine? timeLine,
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
            timelineList: const [],
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

  editItem(
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
      emit(
        state.copyWith(updated: Update.success, ),
      );
    } else {
      emit(
        state.copyWith(updated: Update.error),
      );
    }

    return [];
  }

  Future<List<ItemTimeLine>> getItemTimelines(
      {required String id,
      required String accessToken,
      required Items item}) async {
    emit(
      state.copyWith(updated: Update.loading),
    );
    List<ItemTimeLine> timelines = [];
    final response =
        await HttpRequest().getItemStream(accessToken: accessToken);
    if (response.isNotEmpty) {
      for (item in response) {
        final timeline = response.map((e) => e.timeline) as ItemTimeLine;
        timelines.add(timeline);
      }
      emit(
        state.copyWith(
          timelineList: timelines,
          updated: Update.success,
        ),
      );
    } else {
      emit(
        state.copyWith(updated: Update.error),
      );
    }
    return timelines;
  }
}
