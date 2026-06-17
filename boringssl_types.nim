# SPDX-License-Identifier: Apache-2.0 OR MIT
# Copyright (c) Status Research & Development GmbH

type ptrdiff_t* {.importc: "ptrdiff_t", header: "<stddef.h>".} = int

# enums are generated manually to avoid issue described in
# https://github.com/PMunch/futhark/issues/152
template borrowCEnumOps(T: typedesc) =
  proc `==`*(a, b: T): bool {.borrow.}
  proc `<`*(a, b: T): bool {.borrow.}
  proc `<=`*(a, b: T): bool {.borrow.}
  proc `or`*(a, b: T): T {.borrow.}
  proc `and`*(a, b: T): T {.borrow.}
  proc `xor`*(a, b: T): T {.borrow.}
  proc `not`*(a: T): T {.borrow.}
  proc `$`*(a: T): string {.borrow.}

type
  enum_evp_aead_direction_t* = distinct cuint
  enum_spake2_role_t* = distinct cuint
  enum_bn_primality_result_t* = distinct cuint
  enum_point_conversion_form_t* = distinct cuint
  enum_fips_counter_t* = distinct cuint
  enum_ssl_private_key_result_t* = distinct cuint
  enum_ssl_ticket_aead_result_t* = distinct cuint
  enum_ssl_verify_result_t* = distinct cuint
  enum_ssl_encryption_level_t* = distinct cuint
  enum_ssl_early_data_reason_t* = distinct cuint
  enum_ssl_renegotiate_mode_t* = distinct cuint
  enum_ssl_select_cert_result_t* = distinct cint
  enum_ssl_compliance_policy_t* = distinct cuint

borrowCEnumOps(enum_evp_aead_direction_t)
borrowCEnumOps(enum_spake2_role_t)
borrowCEnumOps(enum_bn_primality_result_t)
borrowCEnumOps(enum_point_conversion_form_t)
borrowCEnumOps(enum_fips_counter_t)
borrowCEnumOps(enum_ssl_private_key_result_t)
borrowCEnumOps(enum_ssl_ticket_aead_result_t)
borrowCEnumOps(enum_ssl_verify_result_t)
borrowCEnumOps(enum_ssl_encryption_level_t)
borrowCEnumOps(enum_ssl_early_data_reason_t)
borrowCEnumOps(enum_ssl_renegotiate_mode_t)
borrowCEnumOps(enum_ssl_select_cert_result_t)
borrowCEnumOps(enum_ssl_compliance_policy_t)

const
  evp_aead_open* = enum_evp_aead_direction_t(0)
  evp_aead_seal* = enum_evp_aead_direction_t(1)

  spake2_role_alice* = enum_spake2_role_t(0)
  spake2_role_bob* = enum_spake2_role_t(1)

  bn_probably_prime* = enum_bn_primality_result_t(0)
  bn_composite* = enum_bn_primality_result_t(1)
  bn_non_prime_power_composite* = enum_bn_primality_result_t(2)

  POINT_CONVERSION_COMPRESSED* = enum_point_conversion_form_t(2)
  POINT_CONVERSION_UNCOMPRESSED* = enum_point_conversion_form_t(4)
  POINT_CONVERSION_HYBRID* = enum_point_conversion_form_t(6)

  fips_counter_evp_aes_128_gcm* = enum_fips_counter_t(0)
  fips_counter_evp_aes_256_gcm* = enum_fips_counter_t(1)
  fips_counter_evp_aes_128_ctr* = enum_fips_counter_t(2)
  fips_counter_evp_aes_256_ctr* = enum_fips_counter_t(3)
  fips_counter_max* = fips_counter_evp_aes_256_ctr

  ssl_private_key_success* = enum_ssl_private_key_result_t(0)
  ssl_private_key_retry* = enum_ssl_private_key_result_t(1)
  ssl_private_key_failure* = enum_ssl_private_key_result_t(2)

  ssl_ticket_aead_success* = enum_ssl_ticket_aead_result_t(0)
  ssl_ticket_aead_retry* = enum_ssl_ticket_aead_result_t(1)
  ssl_ticket_aead_ignore_ticket* = enum_ssl_ticket_aead_result_t(2)
  ssl_ticket_aead_error* = enum_ssl_ticket_aead_result_t(3)

  ssl_verify_ok* = enum_ssl_verify_result_t(0)
  ssl_verify_invalid* = enum_ssl_verify_result_t(1)
  ssl_verify_retry* = enum_ssl_verify_result_t(2)

  ssl_encryption_initial* = enum_ssl_encryption_level_t(0)
  ssl_encryption_early_data* = enum_ssl_encryption_level_t(1)
  ssl_encryption_handshake* = enum_ssl_encryption_level_t(2)
  ssl_encryption_application* = enum_ssl_encryption_level_t(3)

  ssl_early_data_unknown* = enum_ssl_early_data_reason_t(0)
  ssl_early_data_disabled* = enum_ssl_early_data_reason_t(1)
  ssl_early_data_accepted* = enum_ssl_early_data_reason_t(2)
  ssl_early_data_protocol_version* = enum_ssl_early_data_reason_t(3)
  ssl_early_data_peer_declined* = enum_ssl_early_data_reason_t(4)
  ssl_early_data_no_session_offered* = enum_ssl_early_data_reason_t(5)
  ssl_early_data_session_not_resumed* = enum_ssl_early_data_reason_t(6)
  ssl_early_data_unsupported_for_session* = enum_ssl_early_data_reason_t(7)
  ssl_early_data_hello_retry_request* = enum_ssl_early_data_reason_t(8)
  ssl_early_data_alpn_mismatch* = enum_ssl_early_data_reason_t(9)
  ssl_early_data_channel_id* = enum_ssl_early_data_reason_t(10)
  ssl_early_data_ticket_age_skew* = enum_ssl_early_data_reason_t(12)
  ssl_early_data_quic_parameter_mismatch* = enum_ssl_early_data_reason_t(13)
  ssl_early_data_alps_mismatch* = enum_ssl_early_data_reason_t(14)
  ssl_early_data_reason_max_value* = ssl_early_data_alps_mismatch

  ssl_renegotiate_never* = enum_ssl_renegotiate_mode_t(0)
  ssl_renegotiate_once* = enum_ssl_renegotiate_mode_t(1)
  ssl_renegotiate_freely* = enum_ssl_renegotiate_mode_t(2)
  ssl_renegotiate_ignore* = enum_ssl_renegotiate_mode_t(3)
  ssl_renegotiate_explicit* = enum_ssl_renegotiate_mode_t(4)

  ssl_select_cert_disable_ech* = enum_ssl_select_cert_result_t(-2)
  ssl_select_cert_error* = enum_ssl_select_cert_result_t(-1)
  ssl_select_cert_retry* = enum_ssl_select_cert_result_t(0)
  ssl_select_cert_success* = enum_ssl_select_cert_result_t(1)

  ssl_compliance_policy_none* = enum_ssl_compliance_policy_t(0)
  ssl_compliance_policy_fips_202205* = enum_ssl_compliance_policy_t(1)
  ssl_compliance_policy_wpa3_192_202304* = enum_ssl_compliance_policy_t(2)
  ssl_compliance_policy_cnsa_202407* = enum_ssl_compliance_policy_t(3)
  ssl_compliance_policy_cnsa1_202603* = enum_ssl_compliance_policy_t(4)
  ssl_compliance_policy_cnsa2_202603* = enum_ssl_compliance_policy_t(5)
