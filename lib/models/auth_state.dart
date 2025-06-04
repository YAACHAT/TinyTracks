enum AuthStatus {
  initial,
  authenticating,
  authenticated,
  profileIncomplete,
  unauthenticated,
}

class AuthState {
  final AuthStatus status;
  final String? userId;
  final String? email;
  final Map<String, dynamic>? userProfile;
  final String? error;

  const AuthState({
    required this.status,
    this.userId,
    this.email,
    this.userProfile,
    this.error,
  });

  const AuthState.initial() : this(status: AuthStatus.initial);
  
  const AuthState.authenticating() : this(status: AuthStatus.authenticating);
  
  const AuthState.authenticated({
    required String userId,
    required String email,
    Map<String, dynamic>? userProfile,
  }) : this(
    status: AuthStatus.authenticated,
    userId: userId,
    email: email,
    userProfile: userProfile,
  );

  const AuthState.profileIncomplete({
    required String userId,
    required String email,
  }) : this(
    status: AuthStatus.profileIncomplete,
    userId: userId,
    email: email,
  );

  const AuthState.unauthenticated({String? error}) : this(
    status: AuthStatus.unauthenticated,
    error: error,
  );

  AuthState copyWith({
    AuthStatus? status,
    String? userId,
    String? email,
    Map<String, dynamic>? userProfile,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      userProfile: userProfile ?? this.userProfile,
      error: error ?? this.error,
    );
  }
}