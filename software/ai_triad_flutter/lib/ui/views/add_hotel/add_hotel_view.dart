import 'package:ai_triad/ui/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'add_hotel_viewmodel.dart';

class AddHotelView extends StackedView<AddHotelViewModel> {
  const AddHotelView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AddHotelViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Hotel'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: viewModel.formKey,
          child: ListView(
            children: [
              SizedBox(height: 20),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: viewModel.nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
                validator: viewModel.validateName,
              ),
              SizedBox(height: 20),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: viewModel.typeController,
                decoration: const InputDecoration(
                  labelText: 'Type(Hotel, Resort, Home stay)',
                ),
                validator: viewModel.validateType,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: viewModel.rateController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Rate',
                ),
                validator: viewModel.validateRate,
              ),
              SizedBox(height: 20),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: viewModel.stateController,
                decoration: InputDecoration(
                  labelText: 'State',
                ),
                validator: viewModel.validateState,
              ),
              SizedBox(height: 20),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: viewModel.placeController,
                decoration: InputDecoration(
                  labelText: 'Place',
                ),
                validator: viewModel.validatePlace,
              ),
              SizedBox(height: 16),
              CustomButton(
                  onTap: viewModel.addHotel,
                  text: "Add hotel",
                  isLoading: viewModel.isBusy)
            ],
          ),
        ),
      ),
    );
  }

  @override
  AddHotelViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AddHotelViewModel();
}
