import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import '../../../models/trip.dart';
import '../../common/app_colors.dart';
import 'trip_viewmodel.dart';

class TripView extends StackedView<TripViewModel> {
  const TripView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    TripViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My trips'),
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
        child: viewModel.isBusy
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display upcoming trips
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                    child: Text(
                      'Upcoming Trips',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: viewModel.upcomingTrips.length,
                    itemBuilder: (context, index) {
                      final trip = viewModel.upcomingTrips[index];
                      return TripTile(trip: trip);
                    },
                  ),
                  // Display past trips
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                    child: Text(
                      'Past Trips',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: viewModel.pastTrips.length,
                    itemBuilder: (context, index) {
                      final trip = viewModel.pastTrips[index];
                      return TripTile(trip: trip);
                    },
                  ),
                ],
              ),
      ),
    );
  }

  @override
  TripViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      TripViewModel();

  @override
  void onViewModelReady(TripViewModel viewModel) {
    viewModel.fetchTrips();
  }
}

class TripTile extends StatelessWidget {
  final Trip trip;

  const TripTile({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
          color: kcLightGrey,
          border: Border.all(
            color: kcPrimaryColor,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: ListTile(
        title: Text(trip.to),
        subtitle: Text(
          DateFormat('dd MMM, yyyy').format(trip.date),
        ),
        trailing: Text('₹${trip.paymentMade}'),
        // const Icon(Icons.arrow_forward),
        onTap: () {
          // Handle tile tap action
        },
      ),
    );
  }
}
