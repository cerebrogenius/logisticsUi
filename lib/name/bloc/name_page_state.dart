import 'package:my_bloc_app/name/name_page.dart';

class NameState {
 String? name;
  NameState({required this.name});
}
class NamePageState extends NameState{
  NamePageState():super(name: 'Old Name');

}