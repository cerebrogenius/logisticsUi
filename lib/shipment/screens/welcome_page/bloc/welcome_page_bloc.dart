import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'welcome_page_event.dart';
part 'welcome_page_state.dart';

class WelcomePageBloc extends Bloc<WelcomePageEvent, WelcomePageState> {
  WelcomePageBloc() : super(WelcomePageInitial(page:0)) {
    on<PageChangeEvent>((event, emit) {
      emit(WelcomePageInitial(page:event.page));
    });
  }
}
