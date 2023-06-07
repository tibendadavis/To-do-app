import 'package:flutter/material.dart';
import 'package:todo/components/heading4.dart';
import 'package:todo/components/heading5.dart';
import 'package:todo/components/searchBar.comp.dart';
import 'package:todo/components/sortOptionsDialog.comp.dart';
import 'package:todo/components/todoItem.comp.dart';
import 'package:todo/controllers/functions.dart';
import 'package:todo/controllers/globalVariables.dart';
import 'package:todo/theme/design.theme.dart';

class listTodoItems extends StatefulWidget {
  const listTodoItems({super.key});

  @override
  State<listTodoItems> createState() => _listTodoItemsState();
}

class _listTodoItemsState extends State<listTodoItems> {
  var todos = [];
  var newData = [];
  var allData = [];
  var filteredData;
  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int _currentPage = 1;
  int _totalPages = 10;
  int page = 0;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

//function to load more data after the pageSize limit
  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });
    newData = await Funcs().getAllTodos((_currentPage).toString());
    setState(() {
      todos.addAll(newData);
      _isLoading = false;
      todos.sort((a, b) =>
          b['value']['lastUpdated'].compareTo(a['value']['lastUpdated']));
    });
  }

//function to search for todos from all the pages available
  performSearch(String query) async {
    var nextData = await Funcs().getAllTodos((page).toString());
    allData.addAll(nextData);
    filteredData = allData
        .where((item) =>
            item['value']['title'].toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      allData.sort((a, b) =>
          b['value']['lastUpdated'].compareTo(a['value']['lastUpdated']));
    });

    if (filteredData == []) {
      setState(() {
        filteredData = null;
      });
    }
  }

//sort todos items by title
  sortByTitle() async {
    setState(() {
      filteredData = null;
    });

    if (filteredData != null) {
      setState(() {
        filteredData
            .sort((a, b) => a['value']['title'].compareTo(b['value']['title']));
      });
    } else {
      setState(() {
        todos
            .sort((a, b) => a['value']['title'].compareTo(b['value']['title']));
      });
    }
  }

  //sort todos items by creation Date
  sortByDate() {
    setState(() {
      filteredData = null;
    });
    if (filteredData != null) {
      setState(() {
        filteredData.sort(
            (a, b) => b['value']['created'].compareTo(a['value']['created']));
      });
    } else {
      setState(() {
        todos.sort(
            (a, b) => b['value']['created'].compareTo(a['value']['created']));
      });
    }
  }

  //sort todos items by completion Status
  sortByStatus() {
    if (filteredData != null) {
      setState(() {
        filteredData.sort((a, b) => a['value']['completed'] ? -1 : 1);
      });
    } else {
      setState(() {
        todos.sort((a, b) => a['value']['completed'] ? -1 : 1);
      });
    }
  }

//function to delete a todo when it is swiped
  deleteTask(BuildContext context, String id, int index) async {
    await Funcs().deleteTodo(id);
    todos.removeAt(index);
    Funcs().showSnackBar(
        context: context,
        mainLabel: "Task deleted successfully",
        actionLabel: "",
        actionFunc: () {},
        type: "success");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //search bar component
            searchBar(
              onSort: () {
                showDialog(
                  context: context,
                  builder: (context) => sortOptionsDialog(sortByName: () {
                    sortByTitle();
                  }, sortByCompletion: () {
                    sortByStatus();
                  }, sortByDate: () {
                    sortByDate();
                  }),
                );
              },
              value: globalData.searchQuery != null
                  ? globalData.searchQuery
                  : null,
              onSelect: (val) {
                setState(() {
                  globalData.searchQuery = val;
                  page++;
                });
                print(val);
                performSearch(val);
              },
            ),

            SizedBox(
                height: size.height - 320,
                child:
                    //FutureBuilder widget to handle data after the http request has been made
                    FutureBuilder(
                        future: Funcs().getAllTodos(_currentPage.toString()),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                  color: globalData.darkMode
                                      ? Palette().accentColorLight
                                      : Palette().accentColorDark),
                            );
                          } else if (snapshot.hasData) {
                            return ListView.builder(
                                addAutomaticKeepAlives: true,
                                controller: _scrollController,
                                itemCount: filteredData == null
                                    ? todos.length + 1
                                    : filteredData.length + 1,
                                itemBuilder: ((context, index) {
                                  if (index <
                                      (filteredData == null
                                          ? todos.length
                                          : filteredData.length)) {
                                    var item = filteredData == null
                                        ? todos[index]['key']
                                        : filteredData[index]['key'];
                                    return Dismissible(
                                      key: Key(item),
                                      background: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.red),
                                        child: Icon(Icons.delete_rounded,
                                            size: 30, color: Colors.white),
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.only(right: 20.0),
                                      ),
                                      onDismissed: (direction) {
                                        deleteTask(
                                            context,
                                            filteredData == null
                                                ? todos[index]['value']['id']
                                                : filteredData[index]['value']
                                                    ['id'],
                                            index);
                                      },
                                      child:
                                          //tile component to display a single todo item
                                          todoItem(
                                        id: filteredData == null
                                            ? todos[index]['value']['id']
                                            : filteredData[index]['value']
                                                ['id'],
                                        title: filteredData == null
                                            ? todos[index]['value']['title']
                                            : filteredData[index]['value']
                                                ['title'],
                                        description: filteredData == null
                                            ? todos[index]['value']
                                                ['description']
                                            : filteredData[index]['value']
                                                ['description'],
                                        completed: filteredData == null
                                            ? todos[index]['value']['completed']
                                            : filteredData[index]['value']
                                                ['completed'],
                                        created: filteredData == null
                                            ? todos[index]['value']['created']
                                            : filteredData[index]['value']
                                                ['created'],
                                        lastUpdated: filteredData == null
                                            ? todos[index]['value']
                                                ['lastUpdated']
                                            : filteredData[index]['value']
                                                ['lastUpdated'],
                                      ),
                                    );
                                  } else {
                                    return snapshot.data.length == 50
                                        ? Container(
                                            padding: EdgeInsets.all(16.0),
                                            alignment: Alignment.center,
                                            child: _isLoading
                                                ? Center(
                                                    child: CircularProgressIndicator(
                                                        color: globalData
                                                                .darkMode
                                                            ? Palette()
                                                                .accentColorLight
                                                            : Palette()
                                                                .accentColorDark),
                                                  )
                                                : ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor: globalData
                                                                .darkMode
                                                            ? Palette()
                                                                .accentColorLight
                                                                .withOpacity(
                                                                    0.9)
                                                            : Palette()
                                                                .accentColorDark
                                                                .withOpacity(
                                                                    0.7),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        7))),
                                                    onPressed: () {
                                                      if (!_isLoading &&
                                                          _currentPage <
                                                              _totalPages) {
                                                        setState(() {
                                                          _currentPage++;
                                                        });
                                                        loadData();
                                                      }
                                                    },
                                                    child: Heading5(
                                                      value: "Load more",
                                                    ),
                                                  ))
                                        : Container(
                                            padding: EdgeInsets.all(16.0),
                                            alignment: Alignment.center,
                                            child: Heading5(
                                              value: "End of List",
                                              color: globalData.darkMode
                                                  ? Colors.grey.shade400
                                                  : Colors.grey.shade600,
                                            ),
                                          );
                                  }
                                }));
                          } else {
                            return Center(
                                child: Heading4(
                              value: "No Tasks Available",
                              color: globalData.darkMode
                                  ? Colors.grey.shade500
                                  : Colors.grey.shade500,
                            ));
                          }
                        }))
          ],
        ));
  }
}
