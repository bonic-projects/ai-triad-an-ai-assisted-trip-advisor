import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../widgets/customBottomNavBar.dart';
import 'profile_viewmodel.dart';

class ProfileView extends StackedView<ProfileViewModel> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ProfileViewModel viewModel,
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
                  //fddf-------------------------
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.person_pin, size: 200),
                      SizedBox(height: 30),
                      Text(
                        viewModel.user!.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          viewModel.user!.email,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 19,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            CustomBottomNavigationBar(
              currentIndex: 0,
              onTap: (index) {
                if (index == 0) viewModel.openHomeView();
                if (index == 1) viewModel.openTripView();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  ProfileViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ProfileViewModel();
}
