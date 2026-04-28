import '../models/testimonial_model.dart';

abstract class TestimonialEvent {}

class FetchTestimonialsEvent extends TestimonialEvent {}

class AddTestimonialEvent extends TestimonialEvent {
  final TestimonialModel testimonial;
  AddTestimonialEvent(this.testimonial);
}

class UpdateTestimonialEvent extends TestimonialEvent {
  final TestimonialModel testimonial;
  final String? oldAvatarUrl;
  
  UpdateTestimonialEvent(this.testimonial, {this.oldAvatarUrl});}

class DeleteTestimonialEvent extends TestimonialEvent {
  final String id;
  DeleteTestimonialEvent(this.id);
}