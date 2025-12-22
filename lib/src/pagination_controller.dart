import 'pagination_state.dart';

class PaginationController {
  PaginationStatus status = PaginationStatus.idle;

  bool get isLoading => status == PaginationStatus.loading;
  bool get hasCompleted => status == PaginationStatus.completed;

  void setLoading() => status = PaginationStatus.loading;
  void setIdle() => status = PaginationStatus.idle;
  void setCompleted() => status = PaginationStatus.completed;
  void setError() => status = PaginationStatus.error;
}
