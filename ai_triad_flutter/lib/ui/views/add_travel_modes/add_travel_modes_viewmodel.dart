import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.bottomsheets.dart';
import '../../../app/app.locator.dart';
import '../../../models/travelModes.dart';
import '../../../services/firestore_service.dart';

class AddTravelModesViewModel extends BaseViewModel {
  final formKey = GlobalKey<FormState>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  String? name;
  String? type;
  int? rate;
  String? fromState;
  String? toState;
  String? place;

  void saveForm() {
    final isValid = formKey.currentState?.validate() ?? false;
    if (isValid) {
      formKey.currentState?.save();
      // Save data to Firebase
      addTravelMode(TravelMode(
          name: name!,
          type: type!,
          rate: rate!,
          fromState: fromState!,
          toState: toState!,
          place: place!));
    }
  }

  Future<void> addTravelMode(TravelMode travelMode) async {
    try {
      setBusy(true);
      await _firestoreService.addTravelModes(travelMode);
      formKey.currentState?.reset();
      setBusy(false);
      _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.notice,
        title: "Updated",
        description: "Added to database",
      );
    } catch (e) {
      setBusy(false);
      throw e;
    }
  }

  String? validatePlace(String? value) {
    if (value == null || value.isEmpty) {
      return 'Place is required';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? validateType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Type is required';
    }
    return null;
  }

  String? validateRate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Rate is required';
    }
    final number = num.tryParse(value);
    if (number == null || number < 0) {
      return 'Rate must be a non-negative number';
    }
    return null;
  }

  String? validateFromState(String? value) {
    if (value == null || value.isEmpty) {
      return 'From state is required';
    }
    return null;
  }

  String? validateToState(String? value) {
    if (value == null || value.isEmpty) {
      return 'To state is required';
    }
    return null;
  }
}
