part of 'welcome_page_bloc.dart';

@immutable
abstract class WelcomePageEvent {}

class PageChangeEvent extends WelcomePageEvent{
  final int page;

  PageChangeEvent({required this.page});
}
