import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/upcoming_project_repository.dart';
import 'upcoming_project_event.dart';
import 'upcoming_project_state.dart';

class UpcomingProjectBloc
    extends Bloc<UpcomingProjectEvent, UpcomingProjectState> {
  final UpcomingProjectRepository _repository;

  UpcomingProjectBloc({UpcomingProjectRepository? repository})
    : _repository = repository ?? UpcomingProjectRepository(),
      super(UpcomingProjectInitial()) {
    on<FetchUpcomingProjectsEvent>(_onFetchProjects);
    on<AddUpcomingProjectEvent>(_onAddProject);
    on<UpdateUpcomingProjectEvent>(_onUpdateProject);
    on<DeleteUpcomingProjectEvent>(_onDeleteProject);
  }

  Future<void> _onFetchProjects(
    FetchUpcomingProjectsEvent event,
    Emitter<UpcomingProjectState> emit,
  ) async {
    emit(UpcomingProjectLoading());
    try {
      final projects = await _repository.fetchProjects();
      emit(UpcomingProjectLoaded(projects));
    } catch (e) {
      emit(UpcomingProjectError(e.toString()));
    }
  }

  Future<void> _onAddProject(
    AddUpcomingProjectEvent event,
    Emitter<UpcomingProjectState> emit,
  ) async {
    try {
      await _repository.addProject(event.project);
      add(FetchUpcomingProjectsEvent());
    } catch (e) {
      emit(UpcomingProjectError(e.toString()));
    }
  }

  Future<void> _onUpdateProject(
    UpdateUpcomingProjectEvent event,
    Emitter<UpcomingProjectState> emit,
  ) async {
    try {
      await _repository.updateProject(event.project);
      add(FetchUpcomingProjectsEvent());
    } catch (e) {
      emit(UpcomingProjectError(e.toString()));
    }
  }

  Future<void> _onDeleteProject(
    DeleteUpcomingProjectEvent event,
    Emitter<UpcomingProjectState> emit,
  ) async {
    try {
      await _repository.deleteProject(event.id);
      add(FetchUpcomingProjectsEvent());
    } catch (e) {
      emit(UpcomingProjectError(e.toString()));
    }
  }
}
