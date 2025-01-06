enum AsyncProgress { idle, busy, sync }

class AsyncResult<T, E extends Enum> {
  final AsyncProgress progress;
  final Set<E> errors;
  final T? result;

  AsyncResult(this.progress, this.errors, this.result);

  factory AsyncResult.initial(T? initialValue) => AsyncResult<T, E>(AsyncProgress.idle, <E>{}, initialValue);

  AsyncResult<T, E> copyWith({AsyncProgress? progress, Set<E>? errors, T? result}) =>
      AsyncResult<T, E>(progress ?? this.progress, errors ?? this.errors, result ?? this.result);

  bool get hasErrors => errors.isNotEmpty;
}
