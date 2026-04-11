import '../models/property_enquiry_model.dart';

abstract class PropertyEnquiryState {}

class PropertyEnquiryInitial extends PropertyEnquiryState {}

class PropertyEnquiryLoading extends PropertyEnquiryState {}

class PropertyEnquiryLoaded extends PropertyEnquiryState {
  final List<PropertyEnquiryModel> enquiries;
  PropertyEnquiryLoaded(this.enquiries);
}

class PropertyEnquiryError extends PropertyEnquiryState {
  final String message;
  PropertyEnquiryError(this.message);
}
