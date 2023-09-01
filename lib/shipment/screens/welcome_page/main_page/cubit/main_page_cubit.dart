import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_bloc_app/shipment/models/item_model.dart';
import 'package:my_bloc_app/shipment/network/network_request.dart';

// part 'main_page_state.dart';

class MainPageState extends Equatable {
  final Stream<List<Items>>? items;
  const MainPageState({
    this.items,
  });

  MainPageState copyWith({Stream<List<Items>>? list}) {
    return MainPageState(items: items ?? items);
  }

  @override
  List<Object?> get props => [];
}

class MainPageCubit extends Cubit<MainPageState> {
  MainPageCubit()
      : super(
          const MainPageState(),
        );

  Stream<List<Items>> getlistFromNetwork({
    required String accessToken,
  }) async* {
    final itemList = [];
    final list = HttpRequest().getItems(accessToken: accessToken);
    
  }
}
