import 'package:mybookstore/data/models/store_model.dart';

abstract class StoreStates {}

class StoreLoadingState extends StoreStates {}

class StoreUpdatingState extends StoreStates {}

class StoreUpdateSuccessState extends StoreStates {
  final StoreModel store;

  StoreUpdateSuccessState({required this.store});
}

class StoreLoadedState extends StoreStates {
  final StoreModel store;

  StoreLoadedState({required this.store});
}

class UpdateStoreErrorState extends StoreStates {
  final String message;

  UpdateStoreErrorState({required this.message});
}
