import 'package:ai_triad/ui/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'add_travel_modes_viewmodel.dart';

class AddTravelModesView extends StackedView<AddTravelModesViewModel> {
  const AddTravelModesView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AddTravelModesViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Travel Mode'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: viewModel.formKey,
          child: ListView(
            children: [
              SizedBox(height: 16),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) => viewModel.name = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                    labelText: 'Type (Flight/Train/Car/Bus)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a type';
                  }
                  return null;
                },
                onSaved: (value) => viewModel.type = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Rate'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a rate';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) => viewModel.rate = int.parse(value!),
              ),
              SizedBox(height: 16),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(labelText: 'From State'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a state';
                  }
                  return null;
                },
                onSaved: (value) => viewModel.fromState = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(labelText: 'To State'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a state';
                  }
                  return null;
                },
                onSaved: (value) => viewModel.toState = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(labelText: 'Place'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a place';
                  }
                  return null;
                },
                onSaved: (value) => viewModel.place = value!,
              ),
              SizedBox(height: 20),
              CustomButton(
                  onTap: viewModel.saveForm,
                  text: "Save",
                  isLoading: viewModel.isBusy)
            ],
          ),
        ),
      ),
    );
  }

  @override
  AddTravelModesViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AddTravelModesViewModel();
}
