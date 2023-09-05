import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_bloc_app/shipment/models/item_model.dart';
import 'package:my_bloc_app/shipment/network/network_request.dart';

// part 'post_item_state.dart';
enum ItemStatus { processing, created, delivered, inTransit }

class PostItemCubitState extends Equatable {
  final bool posted;
  final String? currentStatus;
  final DateTime? date;
  final List<Items>? itemList;

  const PostItemCubitState({
    this.posted = false,
    this.currentStatus = 'Processing',
    this.date,
    this.itemList,
  });
  PostItemCubitState copyWith({
    DateTime? date,
    String? status,
    List<Items>? itemList,
    bool? posted,
  }) {
    return PostItemCubitState(
      date: date ?? this.date,
      currentStatus: status ?? currentStatus,
      itemList: itemList ?? this.itemList,
      posted: posted ?? this.posted,
    );
  }

  @override
  List<Object?> get props => [date, currentStatus, posted];
}

class PostItemCubit extends Cubit<PostItemCubitState> {
  PostItemCubit() : super(const PostItemCubitState());

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
      final reply =
          await HttpRequest().postItem(item: item, accesstoken: accesstoken);
      emit(
        state.copyWith(posted: true),
      );
      return reply;
    } on Exception catch (e) {}
    return 'failure';
  }

 
}
