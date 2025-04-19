import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mybookstore/data/models/store_model.dart';
import 'package:mybookstore/interfaces/services/store_service_interface.dart';
import 'package:mybookstore/ui/_core/blocs/store/store_events.dart';
import 'package:mybookstore/ui/_core/blocs/store/store_states.dart';

class StoreBloc extends Bloc<StoreEvents, StoreStates> {
  StoreModel? store;
  StoreServiceInterface storeService = GetIt.I<StoreServiceInterface>();

  StoreBloc() : super(StoreLoadingState()) {
    on<LoadStoreEvent>((event, emit) {
      store = event.store;
      emit(StoreLoadedState(store: event.store));
    });

    on<UpdateStoreEvent>((event, emit) async {
      emit(StoreUpdatingState());
      try {
        StoreModel storeModel = await storeService.updateStore(
          event.storeModel,
        );
        if (store != null) {
          storeModel.user = store!.user;
          emit(StoreUpdateSuccessState(store: storeModel));
        } else {
          emit(UpdateStoreErrorState(message: 'Store not found'));
        }
      } catch (e) {
        emit(UpdateStoreErrorState(message: e.toString()));
      }
    });
  }
}
