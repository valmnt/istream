import 'package:flutter/material.dart';
import 'package:istream/src/managers/responsive_manager.dart';
import 'package:istream/src/shared/colors.dart';
import 'package:istream/src/shared/loader.dart';
import 'package:istream/src/ui/home/widgets/upload_data.dart';
import 'package:istream/src/ui/home/widgets/channel_card.dart';
import 'package:istream/src/ui/home/widgets/empty_list.dart';
import 'package:istream/src/ui/home/widgets/search_bar.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomeView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    HomeViewModel viewModel =
        Provider.of<HomeViewModel>(context, listen: false);
    if (viewModel.channels.isEmpty && !viewModel.initData) {
      viewModel.getChannels();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  left: ResponsiveBreakpoints.of(context).orientation ==
                          Orientation.portrait
                      ? ResponsiveManager.instance
                          .responsiveMultiplicator(context, 10, 1, 4, 40)
                      : ResponsiveManager.instance
                          .responsiveMultiplicator(context, 10, 4, 4, 40),
                  right: ResponsiveBreakpoints.of(context).orientation ==
                          Orientation.portrait
                      ? ResponsiveManager.instance
                          .responsiveMultiplicator(context, 10, 1, 4, 40)
                      : ResponsiveManager.instance
                          .responsiveMultiplicator(context, 10, 4, 4, 40)),
              child: SearchBar(
                  onChanged: (input) => {
                        Provider.of<HomeViewModel>(context, listen: false)
                            .search(input)
                      }),
            )),
            SliverPadding(
              padding: const EdgeInsets.all(5.0),
              sliver: Consumer<HomeViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading) {
                    return const SliverFillRemaining(
                        child: Center(child: Loader(width: 50, height: 52)));
                  } else if (viewModel.channels.isEmpty &&
                      viewModel.input.isEmpty &&
                      viewModel.initData) {
                    return const SliverToBoxAdapter(
                      child: EmptyList(
                        text:
                            "You haven't added any M3U source... \nAdd one to access your content!",
                      ),
                    );
                  } else if (viewModel.channels.isEmpty &&
                      viewModel.input.isNotEmpty &&
                      viewModel.initData) {
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
                      crossAxisCount:
                          ResponsiveBreakpoints.of(context).orientation ==
                                  Orientation.portrait
                              ? ResponsiveManager.instance
                                  .responsiveSelector(context, 2, 3, 5)
                                  .toInt()
                              : ResponsiveManager.instance
                                  .responsiveSelector(context, 5, 3, 5)
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
                            key: Key(viewModel.channels[index].link),
                            title: viewModel.channels[index].title,
                            url: viewModel.channels[index].link,
                            onDelete: () => {viewModel.deleteChannel(index)},
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
        floatingActionButton:
            Consumer<HomeViewModel>(builder: (context, viewModel, child) {
          if (!viewModel.isLoading) {
            return UploadData(
              isLoading: viewModel.isLoading,
              openPicker: () => {viewModel.openPicker()},
              getNetworkFile: (url) => {viewModel.getNetworkFile(url)},
            );
          }
          return Container();
        }));
  }
}
