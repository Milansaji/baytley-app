import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/property_repository.dart';
import 'property_event.dart';
import 'property_state.dart';

class PropertyBloc extends Bloc<PropertyEvent, PropertyState> {
  final PropertyRepository _repository;

  PropertyBloc({PropertyRepository? repository})
    : _repository = repository ?? PropertyRepository(),
      super(PropertyInitial()) {
    on<FetchPropertiesEvent>(_onFetchProperties);
    on<AddPropertyEvent>(_onAddProperty);
    on<UpdatePropertyEvent>(_onUpdateProperty);
    on<DeletePropertyEvent>(_onDeleteProperty);
  }

  Future<void> _onFetchProperties(
    FetchPropertiesEvent event,
    Emitter<PropertyState> emit,
  ) async {
    emit(PropertyLoading());
    try {
      final properties = await _repository.fetchProperties();
      emit(PropertyLoaded(properties));
    } catch (e) {
      emit(PropertyError(e.toString()));
    }
  }

  Future<void> _onAddProperty(
    AddPropertyEvent event,
    Emitter<PropertyState> emit,
  ) async {
    try {
      await _repository.addProperty(event.property);
      add(FetchPropertiesEvent());
    } catch (e) {
      emit(PropertyError(e.toString()));
    }
  }

  Future<void> _onUpdateProperty(
    UpdatePropertyEvent event,
    Emitter<PropertyState> emit,
  ) async {
    try {
      await _repository.updateProperty(event.property);
      add(FetchPropertiesEvent());
    } catch (e) {
      emit(PropertyError(e.toString()));
    }
  }

  Future<void> _onDeleteProperty(
    DeletePropertyEvent event,
    Emitter<PropertyState> emit,
  ) async {
    try {
      await _repository.deleteProperty(event.id);
      add(FetchPropertiesEvent());
    } catch (e) {
      emit(PropertyError(e.toString()));
    }
  }
}
