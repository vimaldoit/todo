import 'package:flutter/material.dart';
import 'package:todo/ui/screens/home/home_bloc.dart';

class EventSearchDelegate extends SearchDelegate {
  final HomeBloc homeBloc;
  EventSearchDelegate(this.homeBloc);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ""),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    homeBloc.add(SearchEvents(query));
    return const SizedBox.shrink(); // Calendar updates automatically
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const SizedBox.shrink(); // no suggestions for now
  }
}
