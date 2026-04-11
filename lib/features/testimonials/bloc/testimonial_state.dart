import '../models/testimonial_model.dart';

abstract class TestimonialState {}

class TestimonialInitial extends TestimonialState {}

class TestimonialLoading extends TestimonialState {}

class TestimonialLoaded extends TestimonialState {
  final List<TestimonialModel> testimonials;
  TestimonialLoaded(this.testimonials);
}

class TestimonialError extends TestimonialState {
  final String message;
  TestimonialError(this.message);
}
