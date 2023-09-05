import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_bloc_app/shipment/models/item_model.dart';
import 'package:my_bloc_app/shipment/network/network_request.dart';

// part 'main_page_state.dart';

class MainPageState extends Equatable {
  final String? rebuild;
  final List<Items>? items;
  const MainPageState({
    this.rebuild,
    this.items,
  });

  MainPageState copyWith({List<Items>? list, String? rebuild}) {
    return MainPageState(
      items: items ?? this.items,
      rebuild: rebuild ?? this.rebuild,
    );
  }

  @override
  List<Object?> get props => [
        items,
        rebuild,
      ];
}

class MainPageCubit extends Cubit<MainPageState> {
  MainPageCubit()
      : super(
          const MainPageState(),
        );

  getlistFromNetwork({
    required String accessToken,
  }) async* {
    Items item = Items();
    List<Items> listed = [];
    final list = HttpRequest().getItems(accessToken: accessToken);
    for (Map<String, dynamic> map in list) {
      listed.add(
        item.itemFromNetwork(map),
      );
      yield listed;
      emit(state.copyWith(list: listed));
    }
  }

  String? rebuildUi(String? rebuild) {
    emit(state.copyWith(rebuild: rebuild));
    return rebuild;
  }
}
