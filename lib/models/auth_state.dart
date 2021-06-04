import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_state.g.dart';

@JsonSerializable()
@CopyWith()
class AuthState {
  bool hasSentOtp;

  AuthState({this.hasSentOtp = false});

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);

  Map<String, dynamic> toJson() => _$AuthStateToJson(this);
}
