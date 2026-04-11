import '../data/models/property_model.dart';

abstract class PropertyEvent {}

class FetchPropertiesEvent extends PropertyEvent {}

class AddPropertyEvent extends PropertyEvent {
  final PropertyModel property;
  AddPropertyEvent(this.property);
}

class UpdatePropertyEvent extends PropertyEvent {
  final PropertyModel property;
  UpdatePropertyEvent(this.property);
}

class DeletePropertyEvent extends PropertyEvent {
  final String id;
  DeletePropertyEvent(this.id);
}
