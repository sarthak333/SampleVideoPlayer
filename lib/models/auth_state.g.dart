// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

extension AuthStateCopyWith on AuthState {
  AuthState copyWith({
    bool? hasSentOtp,
  }) {
    return AuthState(
      hasSentOtp: hasSentOtp ?? this.hasSentOtp,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthState _$AuthStateFromJson(Map<String, dynamic> json) {
  return AuthState(
    hasSentOtp: json['hasSentOtp'] as bool,
  );
}

Map<String, dynamic> _$AuthStateToJson(AuthState instance) => <String, dynamic>{
      'hasSentOtp': instance.hasSentOtp,
    };
