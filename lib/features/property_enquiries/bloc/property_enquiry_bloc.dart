import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/property_enquiry_repository.dart';
import 'property_enquiry_event.dart';
import 'property_enquiry_state.dart';

class PropertyEnquiryBloc
    extends Bloc<PropertyEnquiryEvent, PropertyEnquiryState> {
  final PropertyEnquiryRepository _repository;

  PropertyEnquiryBloc({PropertyEnquiryRepository? repository})
    : _repository = repository ?? PropertyEnquiryRepository(),
      super(PropertyEnquiryInitial()) {
    on<FetchPropertyEnquiriesEvent>(_onFetchEnquiries);
  }

  Future<void> _onFetchEnquiries(
    FetchPropertyEnquiriesEvent event,
    Emitter<PropertyEnquiryState> emit,
  ) async {
    emit(PropertyEnquiryLoading());
    try {
      final enquiries = await _repository.fetchEnquiries();
      emit(PropertyEnquiryLoaded(enquiries));
    } catch (e) {
      emit(PropertyEnquiryError(e.toString()));
    }
  }
}
