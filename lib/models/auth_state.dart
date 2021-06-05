import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_state.g.dart';

@JsonSerializable()
@CopyWith()
class AuthState {
  bool hasSentOtp;

  bool isGoogleSignInLoading;
  bool isPhoneSignInLoading;

  AuthState({
    this.hasSentOtp = false,
    this.isGoogleSignInLoading = false,
    this.isPhoneSignInLoading = false,
  });

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);

  Map<String, dynamic> toJson() => _$AuthStateToJson(this);
}
