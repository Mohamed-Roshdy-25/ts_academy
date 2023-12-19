part of 'generate_tokenn_cubit.dart';

abstract class GenerateTokenState {}

class GenerateTokenInitial extends GenerateTokenState {}

class GenerateTokenLoading extends GenerateTokenState {}

class GenerateTokenLoaded extends GenerateTokenState {}

class GenerateTokenFailure extends GenerateTokenState {
  final String message;
  GenerateTokenFailure({required this.message});
}
