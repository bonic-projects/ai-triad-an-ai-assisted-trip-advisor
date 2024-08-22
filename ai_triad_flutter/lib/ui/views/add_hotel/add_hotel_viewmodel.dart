import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.bottomsheets.dart';
import '../../../app/app.locator.dart';
import '../../../models/hotel.dart';
import '../../../services/firestore_service.dart';

class AddHotelViewModel extends BaseViewModel {
  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final rateController = TextEditingController();
  final stateController = TextEditingController();
  final placeController = TextEditingController();

  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  final formKey = GlobalKey<FormState>();

  Future<void> addHotel() async {
    if (!validate()) return;

    setBusy(true);

    final hotelData = HotelData(
      name: nameController.text,
      type: typeController.text,
      rate: int.parse(rateController.text),
      state: stateController.text,
      place: placeController.text,
    );

    try {
      await _firestoreService.addHotelData(hotelData);
      formKey.currentState?.reset();
      _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.notice,
        title: "Updated",
        description: "Added to database",
      );
    } catch (e) {
      print(e);
    }

    setBusy(false);
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid name';
    }
    return null;
  }

  String? validateType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid type';
    }
    return null;
  }

  String? validateRate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid rate';
    }
    double? rate = double.tryParse(value);
    if (rate == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  String? validateState(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid state';
    }
    return null;
  }

  String? validatePlace(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid place';
    }
    return null;
  }

  bool validate() {
    if (!formKey.currentState!.validate()) {
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    nameController.dispose();
    typeController.dispose();
    rateController.dispose();
    stateController.dispose();
    placeController.dispose();
    super.dispose();
  }
}
