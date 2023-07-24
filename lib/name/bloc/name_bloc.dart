import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_bloc_app/name/bloc/name_page_event.dart';
import 'package:my_bloc_app/name/bloc/name_page_state.dart';

class NameBloc extends Bloc<NameEvents,NameState>{
  NameBloc():super(NamePageState()){
    on<NameChangeEvent>((event, emit) {
      emit(NameState(name: state.name));
    });
  }

}