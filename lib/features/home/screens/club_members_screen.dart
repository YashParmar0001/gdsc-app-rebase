import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gdsc_atmiya/bloc/club_members/club_members_bloc.dart';
import 'package:gdsc_atmiya/features/home/widgets/club_member.dart';
import 'dart:developer' as dev;

import '../../../model/user_model.dart';

class ClubMemberScreen extends StatefulWidget {
  const ClubMemberScreen({super.key});

  @override
  State<ClubMemberScreen> createState() => _ClubMemberScreenState();
}

class _ClubMemberScreenState extends State<ClubMemberScreen> {
  late TextEditingController _searchController;
  late ScrollController _scrollController;
  List<UserModel> _filteredList = [];

  @override
  void initState() {
    _scrollController = ScrollController();
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> onRefresh() async {
      context.read<ClubMembersBloc>().add(LoadClubMembers());
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Club Members',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.small(
          onPressed: _scrollToTop,
          shape: const CircleBorder(),
          child: const Icon(Icons.keyboard_arrow_up),
        ),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: BlocBuilder<ClubMembersBloc, ClubMembersState>(
              builder: (context, state) {
                if (state is ClubMembersLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ClubMembersLoaded) {
                  return SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          onSubmitted: (value) {
                            dev.log('This is String $value', name: "TextField");
                            filterSearchResults(
                              value,
                              state.clubMembers,
                            );
                          },
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: "Search",
                            hintText: "Search",
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  _filteredList.clear();
                                  setState(() {});
                                },
                                icon: const Icon(Icons.clear)),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        _buildListOfClubMember(
                          state.clubMembers,
                          _searchController.text,
                        )
                      ],
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('some thing happens'),
                  );
                }
              },
            ),
          ),
        ));
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void filterSearchResults(String query, List<UserModel> list) {
    setState(() {
      _filteredList = list
          .where((element) =>
              element.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      dev.log("The size of the list ${_filteredList.length.toString()}",
          name: 'Search Bar ');
    });
  }

  Widget _buildListOfClubMember(List<UserModel> originalList, String query) {
    if (_filteredList.isNotEmpty) {
      return ListView.builder(
        // physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return ClubMember(user: _filteredList[index]);
        },
        itemCount: _filteredList.length,
      );
    }
    if (_filteredList.isEmpty && query.isNotEmpty) {
      return const Center(
        child: Text(
          'Opps! Nothing Found ',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
      );
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return ClubMember(user: originalList[index]);
      },
      itemCount: originalList.length,
    );
  }
}

// ListView.builder(
// physics: NeverScrollableScrollPhysics(),
// shrinkWrap: true,
// scrollDirection: Axis.vertical,
// // shrinkWrap: true,
// itemCount: _filterdList.isEmpty
// ? state.clubMembers.length
//     : _filterdList.length,
// itemBuilder: (context, index) {
// return ClubMember(
// user: _filterdList.isEmpty
// ? state.clubMembers[index]
//     : _filterdList[index],
// );
// },
// ),
