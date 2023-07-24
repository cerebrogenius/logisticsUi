
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_bloc_app/name/bloc/name_bloc.dart';
import 'package:my_bloc_app/name/bloc/name_page_event.dart';
import 'package:my_bloc_app/name/bloc/name_page_state.dart';


class NamePage extends StatelessWidget {
   NamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Scaffold(
        body: BlocBuilder<NameBloc,NameState>(
          builder: (context,state) {
            return Column(
              children: [
                Center(
                  child: Container(
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        style: BorderStyle.solid,
                        width: 3
                      )
                    ),
                    child: Center(
                      child: Text(
                      '${BlocProvider.of<NameBloc>(context).state.name}'
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: 45,
                  width: 300,
                  child: TextField(
                    onChanged: (value) {
                      BlocProvider.of<NameBloc>(context).state.name = value;
                      BlocProvider.of<NameBloc>(context).add(NameChangeEvent());
                      }
                  ),
                )
              ],
            );
          }
        ),
      )
    );
  }
}