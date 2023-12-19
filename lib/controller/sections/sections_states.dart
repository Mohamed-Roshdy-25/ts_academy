abstract class SectionsStates{ }
class GetSectionsSuccessfully  extends SectionsStates{ }
class GetSectionsInitial extends SectionsStates{ }
class GetSectionsLoading extends SectionsStates{ }
class GetSectionsFailure extends SectionsStates{
  final String message;
  GetSectionsFailure({required this.message});
}