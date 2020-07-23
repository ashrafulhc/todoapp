import 'package:flutter/material.dart';
import 'package:todoapp/router.dart';
import 'package:todoapp/src/components/cards/task_details_card.dart';
import 'package:todoapp/src/model/task.dart';
import 'package:todoapp/src/pages/task_details_page.dart';

class WordSearch extends SearchDelegate {
  final List<Task> tasks;
  WordSearch(this.tasks);

  final String suggestionIcon = 'assets/images/suggestion_word_icon.svg';

  Task relevantResult;

  @override
  String get searchFieldLabel => "Search Here";

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView(
      children: <Widget>[
        TaskDetailsCard(
          title: relevantResult.title,
          body: relevantResult.details,
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return showSearchResult(context, query);
  }

  Widget showSearchResult(BuildContext context, String query) {
    if (query.trim().length == 0)
      return Container(
        child: Center(
          child: Icon(
            Icons.search,
            size: 100,
            color: Colors.grey,
          ),
        ),
      );

    List<Task> suggestionList = tasks
        .where((element) => element.title.toLowerCase().startsWith(query))
        .toList();

    return ListView.builder(
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            onTap: () {
              relevantResult = suggestionList[index];
              showResults(context);
            },
            title: Text(suggestionList[index].title),
          ),
        );
      },
      itemCount: suggestionList.length,
    );
  }
}
