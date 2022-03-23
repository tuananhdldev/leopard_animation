import 'package:equatable/equatable.dart';

class AppState extends Equatable {
  final double offset;
  final double page;
  final double value;
  final double mapvalue;

  const AppState(this.offset, this.page, this.value, this.mapvalue);

  factory AppState.initial() {
    return const AppState(0.0, 0.0, 0.0, 0.0);
  }

  @override
  List<Object?> get props => [offset, page, value];

  AppState copyWith(
      {double? offset, double? page, double? value, double? mapvalue}) {
    return AppState(offset ?? this.offset, page ?? this.page,
        value ?? this.value, mapvalue ?? this.mapvalue);
  }
}
