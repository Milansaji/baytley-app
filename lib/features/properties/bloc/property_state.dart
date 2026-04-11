import '../data/models/property_model.dart';

abstract class PropertyState {}

class PropertyInitial extends PropertyState {}

class PropertyLoading extends PropertyState {}

class PropertyLoaded extends PropertyState {
  final List<PropertyModel> properties;
  PropertyLoaded(this.properties);
}

class PropertyError extends PropertyState {
  final String message;
  PropertyError(this.message);
}
