import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/testimonial_repository.dart';
import 'testimonial_event.dart';
import 'testimonial_state.dart';

class TestimonialBloc extends Bloc<TestimonialEvent, TestimonialState> {
  final TestimonialRepository _repository;

  TestimonialBloc({TestimonialRepository? repository})
    : _repository = repository ?? TestimonialRepository(),
      super(TestimonialInitial()) {
    on<FetchTestimonialsEvent>(_onFetchTestimonials);
    on<AddTestimonialEvent>(_onAddTestimonial);
    on<UpdateTestimonialEvent>(_onUpdateTestimonial);
    on<DeleteTestimonialEvent>(_onDeleteTestimonial);
  }

  Future<void> _onFetchTestimonials(
    FetchTestimonialsEvent event,
    Emitter<TestimonialState> emit,
  ) async {
    emit(TestimonialLoading());
    try {
      final testimonials = await _repository.fetchTestimonials();
      emit(TestimonialLoaded(testimonials));
    } catch (e) {
      emit(TestimonialError(e.toString()));
    }
  }

  Future<void> _onAddTestimonial(
    AddTestimonialEvent event,
    Emitter<TestimonialState> emit,
  ) async {
    try {
      await _repository.addTestimonial(event.testimonial);
      add(FetchTestimonialsEvent());
    } catch (e) {
      emit(TestimonialError(e.toString()));
    }
  }

  Future<void> _onUpdateTestimonial(
    UpdateTestimonialEvent event,
    Emitter<TestimonialState> emit,
  ) async {
    try {
      await _repository.updateTestimonial(event.testimonial);
      add(FetchTestimonialsEvent());
    } catch (e) {
      emit(TestimonialError(e.toString()));
    }
  }

  Future<void> _onDeleteTestimonial(
    DeleteTestimonialEvent event,
    Emitter<TestimonialState> emit,
  ) async {
    try {
      await _repository.deleteTestimonial(event.id);
      add(FetchTestimonialsEvent());
    } catch (e) {
      emit(TestimonialError(e.toString()));
    }
  }
}
