import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_bloc_app/shipment/models/item_model.dart';
import 'package:my_bloc_app/shipment/network/network_request.dart';
import 'package:my_bloc_app/shipment/utilities/constants.dart';

// part 'post_item_state.dart';
enum ItemStatus { processing, created, delivered, inTransit }

class PostItemCubitState extends Equatable {
  final String? currentStatus;
  final DateTime? date;
  final List<Items>? itemList;

  const PostItemCubitState({
    this.currentStatus = 'Processing',
    this.date,
    this.itemList,
  });
  PostItemCubitState copyWith(
      {DateTime? date, String? status, List<Items>? itemList}) {
    return PostItemCubitState(
      date: date,
      currentStatus: status ?? this.currentStatus,
      itemList: itemList ?? this.itemList,
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
    } on Exception catch (e) {}
    return 'failure';
  }

 Future<Items> getItems({required String accessToken}) async {
    Items items = Items();
    List<Items> finalList = [];
    List rawItems = await HttpRequest().getItems(accessToken: accessToken);
    for (Map<String, dynamic> item in rawItems) {
      finalList.add(items.itemFromNetwork(item));
    }
    emit(state.copyWith(itemList: finalList),);
  return items;
  }
}
