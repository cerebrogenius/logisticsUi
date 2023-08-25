import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class HomeScreenCubitState {
  final int index;

  HomeScreenCubitState({required this.index});
  HomeScreenCubitState copyWith({int? index}) {
    return HomeScreenCubitState(index: index ?? this.index);
  }
}

class HomeScreenCubit extends Cubit<HomeScreenCubitState> {
  HomeScreenCubit() : super(HomeScreenCubitState(index: 0));
  pageChange({required int index}) {
    emit(
      state.copyWith(index: index),
    );
  }
}
