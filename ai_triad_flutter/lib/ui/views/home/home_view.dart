import 'package:ai_triad/ui/widgets/customBottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';

import '../../common/app_colors.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI-Triad'),
        actions: [
          if (viewModel.user != null)
            IconButton(
              onPressed: viewModel.logout,
              icon: const Icon(Icons.logout),
            )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/views/home.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      'assets/logo.png',
                      height: 150,
                    ),
                  ),
                  CustomButtonSelector(
                      onTap: viewModel.openChatView, text: "PLAN A TRIP"),
                  if (viewModel.user!.userRole == 'admin')
                    CustomButtonSelector(
                        onTap: viewModel.openHotelAddView, text: "ADD HOTELS"),
                  if (viewModel.user!.userRole == 'admin')
                    CustomButtonSelector(
                        onTap: viewModel.openTravelModesAddView,
                        text: "ADD TRAVEL MODES"),
                  // CustomButtonSelector(
                  //     onTap: viewModel.openGuidsAddView,
                  //     text: "Add tour guids"),
                ],
              ),
            ),
            CustomBottomNavigationBar(
                currentIndex: 0,
                onTap: (index) {
                  if (index == 2) viewModel.openProfileView();
                  if (index == 1) viewModel.openTripView();
                })
          ],
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) => SchedulerBinding.instance
      .addPostFrameCallback((timeStamp) => viewModel.runStartupLogic());
}

class CustomButtonSelector extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const CustomButtonSelector({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextButton(
        onPressed: onTap,
        child: Container(
            decoration: BoxDecoration(
                color: kcLightGrey,
                border: Border.all(
                  color: kcPrimaryColor,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.add),
                ],
              ),
            )),
      ),
    );
  }
}
