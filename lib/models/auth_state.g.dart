// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension AuthStateCopyWith on AuthState {
  AuthState copyWith({
    bool? hasSentOtp,
    bool? isGoogleSignInLoading,
    bool? isPhoneSignInLoading,
  }) {
    return AuthState(
      hasSentOtp: hasSentOtp ?? this.hasSentOtp,
      isGoogleSignInLoading:
          isGoogleSignInLoading ?? this.isGoogleSignInLoading,
      isPhoneSignInLoading: isPhoneSignInLoading ?? this.isPhoneSignInLoading,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthState _$AuthStateFromJson(Map<String, dynamic> json) {
  return AuthState(
    hasSentOtp: json['hasSentOtp'] as bool,
    isGoogleSignInLoading: json['isGoogleSignInLoading'] as bool,
    isPhoneSignInLoading: json['isPhoneSignInLoading'] as bool,
  );
}

Map<String, dynamic> _$AuthStateToJson(AuthState instance) => <String, dynamic>{
      'hasSentOtp': instance.hasSentOtp,
      'isGoogleSignInLoading': instance.isGoogleSignInLoading,
      'isPhoneSignInLoading': instance.isPhoneSignInLoading,
    };
