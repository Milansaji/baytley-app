import '../models/upcoming_project_model.dart';

abstract class UpcomingProjectState {}

class UpcomingProjectInitial extends UpcomingProjectState {}

class UpcomingProjectLoading extends UpcomingProjectState {}

class UpcomingProjectLoaded extends UpcomingProjectState {
  final List<UpcomingProjectModel> projects;
  UpcomingProjectLoaded(this.projects);
}

class UpcomingProjectError extends UpcomingProjectState {
  final String message;
  UpcomingProjectError(this.message);
}
