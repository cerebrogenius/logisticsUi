import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_bloc_app/shipment/models/item_model.dart';
import 'package:my_bloc_app/shipment/network/network_request.dart';

import '../../../utilities/constants.dart';

// part 'post_item_state.dart';
enum ItemStatus { loading, success, error, initial }

class PostItemCubitState extends Equatable {
  final ItemStatus? postStatus;
  final String? currentStatus;
  final DateTime? date;
  final List<Items>? itemList;
  final String? postLocation;

  const PostItemCubitState({
    this.postStatus,
    this.currentStatus = 'Processing',
    this.date,
    this.itemList,
    this.postLocation,
  });
  PostItemCubitState copyWith({
    ItemStatus? postStatus,
    DateTime? date,
    String? status,
    List<Items>? itemList,
    String? location,
  }) {
    return PostItemCubitState(
      date: date ?? this.date,
      currentStatus: status ?? currentStatus,
      itemList: itemList ?? this.itemList,
      postStatus: postStatus ?? this.postStatus,
      postLocation: location ?? postLocation,
    );
  }

  @override
  List<Object?> get props => [date, currentStatus, postStatus, postLocation];
}

class PostItemCubit extends Cubit<PostItemCubitState> {
  PostItemCubit() : super(PostItemCubitState(postLocation: locationslist[0]));

  updateDate({required DateTime? newDate}) {
    emit(
      state.copyWith(date: newDate),
    );
  }

  changeStatus({required currentStatus}) {
    emit(
      state.copyWith(status: currentStatus),
    );
  }

  Future<String> postItem(
      {required Items item, required String accesstoken}) async {
    try {
      emit(
        state.copyWith(postStatus: ItemStatus.loading),
      );
      final reply =
          await HttpRequest().postItem(item: item, accesstoken: accesstoken);
      emit(
        state.copyWith(postStatus: ItemStatus.success),
      );
      return reply;
    } on Exception catch (e) {
      emit(
        state.copyWith(postStatus: ItemStatus.error),
      );
    }
    return 'failure';
  }

  updateLocation({required String? location}) {
    emit(
      state.copyWith(location: location),
    );
  }
}
