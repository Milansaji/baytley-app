import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/analytics_repository.dart';
import 'analytics_event.dart';

// States
abstract class AnalyticsState {}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final AnalyticsData data;
  AnalyticsLoaded(this.data);
}

class AnalyticsError extends AnalyticsState {
  final String message;
  AnalyticsError(this.message);
}

// BLoC
class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsRepository repository;

  AnalyticsBloc({required this.repository}) : super(AnalyticsInitial()) {
    on<FetchAnalyticsEvent>((event, emit) async {
      emit(AnalyticsLoading());
      try {
        final data = await repository.fetchDashboardStats();
        emit(AnalyticsLoaded(data));
      } catch (e) {
        emit(AnalyticsError(e.toString()));
      }
    });
  }
}
