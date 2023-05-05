import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:istream/src/managers/responsive_manager.dart';
import 'package:istream/src/resources/colors.dart';
import 'package:istream/src/ui/home/widgets/add_m3u.dart';
import 'package:istream/src/ui/home/widgets/channel_card.dart';
import 'package:istream/src/ui/home/widgets/empty_list.dart';
import 'package:istream/src/ui/home/widgets/search_bar.dart';
import 'package:provider/provider.dart';
import 'home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomeView> {
  late HomeViewModel _homeViewModel;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
        create: (context) => HomeViewModel(),
        child: Builder(builder: (BuildContext privateContext) {
          _homeViewModel =
              Provider.of<HomeViewModel>(privateContext, listen: true);
          if (_homeViewModel.channels.isEmpty && !_homeViewModel.initData) {
            _homeViewModel.getChannels();
          }
          return Scaffold(
            backgroundColor: tertiary,
            body: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: tertiary,
                  expandedHeight: 100.0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Text(
                              "IStream",
                              style: TextStyle(
                                color: primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 35,
                              ),
                            ))),
                  ),
                ),
                SliverToBoxAdapter(
                    child: Padding(
                  padding: EdgeInsets.only(
                      top: 20,
                      bottom: 30,
                      left: ResponsiveManager.instance
                          .responsiveMultiplicator(context, 10, 1, 4, 40),
                      right: ResponsiveManager.instance
                          .responsiveMultiplicator(context, 10, 1, 4, 40)),
                  child: SearchBar(
                      onChanged: (input) => {_homeViewModel.search(input)}),
                )),
                SliverPadding(
                  padding: const EdgeInsets.all(5.0),
                  sliver: Consumer<HomeViewModel>(
                    builder: (context, viewModel, child) {
                      if (viewModel.channels.isEmpty &&
                          viewModel.input.isEmpty) {
                        return const SliverToBoxAdapter(
                          child: EmptyList(
                            text:
                                "You haven't added any M3U files... \nAdd one to access your content!",
                          ),
                        );
                      } else if (viewModel.channels.isEmpty &&
                          viewModel.input.isNotEmpty) {
                        return FutureBuilder<String>(
                          future: viewModel.fetchJokeForFunnyError(),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SliverToBoxAdapter(
                                  child: EmptyList(
                                      text:
                                          "Sorry, we couldn't find what you're looking for, but we've got something even cooler! Here's a Chuck Norris joke: \n\nWait the joke is coming..."));
                            } else if (snapshot.hasError) {
                              return const SliverToBoxAdapter(
                                  child: EmptyList(
                                      text:
                                          "Sorry, we couldn't find what you're looking for...😢"));
                            } else if (snapshot.hasData) {
                              // Afficher les données si elles ont été récupérées avec succès
                              return SliverToBoxAdapter(
                                  child: EmptyList(
                                      text:
                                          "Sorry, we couldn't find what you're looking for, but we've got something even cooler! Here's a Chuck Norris joke: \n\n${snapshot.data}"));
                            } else {
                              return const SliverToBoxAdapter(
                                  child: EmptyList(
                                      text:
                                          "Sorry, we couldn't find what you're looking for...😢"));
                            }
                          },
                        );
                      } else {
                        return SliverGrid.count(
                          crossAxisCount: ResponsiveManager.instance
                              .responsiveSelector(context, 2, 3, 5)
                              .toInt(),
                          mainAxisSpacing: ResponsiveManager.instance
                              .responsiveMultiplicator(context, 10, 3, 4, 10),
                          crossAxisSpacing: ResponsiveManager.instance
                              .responsiveMultiplicator(context, 10, 3, 4, 10),
                          childAspectRatio: 0.7,
                          children: List.generate(
                            viewModel.channels.length,
                            (index) {
                              return ChannelCard(
                                title: viewModel.channels[index].title,
                                url: viewModel.channels[index].link,
                                onDelete: () =>
                                    {viewModel.deleteChannel(index)},
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            floatingActionButton: AddM3U(
              openPicker: () => {_homeViewModel.openPicker()},
              getNetworkFile: (url) => {_homeViewModel.getNetworkFile(url)},
            ),
          );
        }));
  }
}
