import '../models/upcoming_project_model.dart';

abstract class UpcomingProjectEvent {}

class FetchUpcomingProjectsEvent extends UpcomingProjectEvent {}

class AddUpcomingProjectEvent extends UpcomingProjectEvent {
  final UpcomingProjectModel project;
  AddUpcomingProjectEvent(this.project);
}

class UpdateUpcomingProjectEvent extends UpcomingProjectEvent {
  final UpcomingProjectModel project;
  UpdateUpcomingProjectEvent(this.project);
}

class DeleteUpcomingProjectEvent extends UpcomingProjectEvent {
  final String id;
  DeleteUpcomingProjectEvent(this.id);
}
