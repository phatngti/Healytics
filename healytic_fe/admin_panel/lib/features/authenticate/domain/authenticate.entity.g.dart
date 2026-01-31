// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticate.entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SignInRequestEntity _$SignInRequestEntityFromJson(Map<String, dynamic> json) =>
    _SignInRequestEntity(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$SignInRequestEntityToJson(
  _SignInRequestEntity instance,
) => <String, dynamic>{'email': instance.email, 'password': instance.password};

_SignInResponseEntity _$SignInResponseEntityFromJson(
  Map<String, dynamic> json,
) => _SignInResponseEntity(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  role: json['role'] as String,
  verificationStatus: json['verificationStatus'] as String?,
  verificationCompletedAt: json['verificationCompletedAt'] as String?,
);

Map<String, dynamic> _$SignInResponseEntityToJson(
  _SignInResponseEntity instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'role': instance.role,
  'verificationStatus': instance.verificationStatus,
  'verificationCompletedAt': instance.verificationCompletedAt,
};

_SendOtpResponseEntity _$SendOtpResponseEntityFromJson(
  Map<String, dynamic> json,
) => _SendOtpResponseEntity(
  emailToken: json['emailToken'] as String,
  message: json['message'] as String,
);

Map<String, dynamic> _$SendOtpResponseEntityToJson(
  _SendOtpResponseEntity instance,
) => <String, dynamic>{
  'emailToken': instance.emailToken,
  'message': instance.message,
};

_VerifyOtpResponseEntity _$VerifyOtpResponseEntityFromJson(
  Map<String, dynamic> json,
) => _VerifyOtpResponseEntity(
  otpToken: json['otpToken'] as String,
  message: json['message'] as String,
);

Map<String, dynamic> _$VerifyOtpResponseEntityToJson(
  _VerifyOtpResponseEntity instance,
) => <String, dynamic>{
  'otpToken': instance.otpToken,
  'message': instance.message,
};

_AccountRequestEntity _$AccountRequestEntityFromJson(
  Map<String, dynamic> json,
) => _AccountRequestEntity(
  username: json['username'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$AccountRequestEntityToJson(
  _AccountRequestEntity instance,
) => <String, dynamic>{
  'username': instance.username,
  'email': instance.email,
  'password': instance.password,
};

_PartnerRequestEntity _$PartnerRequestEntityFromJson(
  Map<String, dynamic> json,
) => _PartnerRequestEntity(
  taxCode: json['taxCode'] as String,
  legalName: json['legalName'] as String,
  brandName: json['brandName'] as String,
  businessType: json['businessType'] as String,
  provinceId: json['provinceId'] as String,
  districtId: json['districtId'] as String,
  wardId: json['wardId'] as String,
  streetAddress: json['streetAddress'] as String,
  phoneNumber: json['phoneNumber'] as String?,
);

Map<String, dynamic> _$PartnerRequestEntityToJson(
  _PartnerRequestEntity instance,
) => <String, dynamic>{
  'taxCode': instance.taxCode,
  'legalName': instance.legalName,
  'brandName': instance.brandName,
  'businessType': instance.businessType,
  'provinceId': instance.provinceId,
  'districtId': instance.districtId,
  'wardId': instance.wardId,
  'streetAddress': instance.streetAddress,
  'phoneNumber': instance.phoneNumber,
};

_AuthorizationEntity _$AuthorizationEntityFromJson(Map<String, dynamic> json) =>
    _AuthorizationEntity(
      isAuthorizedUser: json['isAuthorizedUser'] as bool,
      authLetterDocUrl: json['authLetterDocUrl'] as String?,
    );

Map<String, dynamic> _$AuthorizationEntityToJson(
  _AuthorizationEntity instance,
) => <String, dynamic>{
  'isAuthorizedUser': instance.isAuthorizedUser,
  'authLetterDocUrl': instance.authLetterDocUrl,
};

_PartnerDocumentVerificationEntity _$PartnerDocumentVerificationEntityFromJson(
  Map<String, dynamic> json,
) => _PartnerDocumentVerificationEntity(
  fileType: json['fileType'] as String,
  type: json['type'] as String,
  documentKey: json['documentKey'] as String,
  urls:
      (json['urls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$PartnerDocumentVerificationEntityToJson(
  _PartnerDocumentVerificationEntity instance,
) => <String, dynamic>{
  'fileType': instance.fileType,
  'type': instance.type,
  'documentKey': instance.documentKey,
  'urls': instance.urls,
};

_LegalRepresentativeEntity _$LegalRepresentativeEntityFromJson(
  Map<String, dynamic> json,
) => _LegalRepresentativeEntity(
  fullName: json['fullName'] as String,
  position: json['position'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  idType: json['idType'] as String,
  idNumber: json['idNumber'] as String,
  idIssueDate: json['idIssueDate'] as String,
  documents:
      (json['documents'] as List<dynamic>?)
          ?.map(
            (e) => PartnerDocumentVerificationEntity.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$LegalRepresentativeEntityToJson(
  _LegalRepresentativeEntity instance,
) => <String, dynamic>{
  'fullName': instance.fullName,
  'position': instance.position,
  'phoneNumber': instance.phoneNumber,
  'idType': instance.idType,
  'idNumber': instance.idNumber,
  'idIssueDate': instance.idIssueDate,
  'documents': instance.documents.map((e) => e.toJson()).toList(),
};

_RegisterPartnerRequestEntity _$RegisterPartnerRequestEntityFromJson(
  Map<String, dynamic> json,
) => _RegisterPartnerRequestEntity(
  account: AccountRequestEntity.fromJson(
    json['account'] as Map<String, dynamic>,
  ),
  partner: PartnerRequestEntity.fromJson(
    json['partner'] as Map<String, dynamic>,
  ),
  legalRepresentative: LegalRepresentativeEntity.fromJson(
    json['legalRepresentative'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$RegisterPartnerRequestEntityToJson(
  _RegisterPartnerRequestEntity instance,
) => <String, dynamic>{
  'account': instance.account.toJson(),
  'partner': instance.partner.toJson(),
  'legalRepresentative': instance.legalRepresentative.toJson(),
};

_RegisterPartnerResponseEntity _$RegisterPartnerResponseEntityFromJson(
  Map<String, dynamic> json,
) => _RegisterPartnerResponseEntity(
  accountId: json['accountId'] as String,
  businessEntityId: json['businessEntityId'] as String,
  status: json['status'] as String,
  message: json['message'] as String,
  accessToken: json['accessToken'] as String,
  accessExpiresIn: json['accessExpiresIn'] as String,
  refreshToken: json['refreshToken'] as String,
  refreshExpiresIn: json['refreshExpiresIn'] as String,
);

Map<String, dynamic> _$RegisterPartnerResponseEntityToJson(
  _RegisterPartnerResponseEntity instance,
) => <String, dynamic>{
  'accountId': instance.accountId,
  'businessEntityId': instance.businessEntityId,
  'status': instance.status,
  'message': instance.message,
  'accessToken': instance.accessToken,
  'accessExpiresIn': instance.accessExpiresIn,
  'refreshToken': instance.refreshToken,
  'refreshExpiresIn': instance.refreshExpiresIn,
};

_SignUpRequestEntity _$SignUpRequestEntityFromJson(Map<String, dynamic> json) =>
    _SignUpRequestEntity(
      companyName: json['companyName'] as String? ?? '',
      taxRegistrationCode: json['taxRegistrationCode'] as String? ?? '',
      businessEmail: json['businessEmail'] as String? ?? '',
      businessPhone: json['businessPhone'] as String? ?? '',
      serviceCategories:
          (json['serviceCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      country: json['country'] as String? ?? '',
      city: json['city'] as String? ?? '',
      district: json['district'] as String? ?? '',
      detailedAddress: json['detailedAddress'] as String? ?? '',
      representativeName: json['representativeName'] as String? ?? '',
      governmentIdNumber: json['governmentIdNumber'] as String? ?? '',
      frontIdUrl: json['frontIdUrl'] as String?,
      backIdUrl: json['backIdUrl'] as String?,
      requiresAuthorizationLetter:
          json['requiresAuthorizationLetter'] as bool? ?? false,
      authorizationLetterUrl: json['authorizationLetterUrl'] as String?,
      password: json['password'] as String? ?? '',
    );

Map<String, dynamic> _$SignUpRequestEntityToJson(
  _SignUpRequestEntity instance,
) => <String, dynamic>{
  'companyName': instance.companyName,
  'taxRegistrationCode': instance.taxRegistrationCode,
  'businessEmail': instance.businessEmail,
  'businessPhone': instance.businessPhone,
  'serviceCategories': instance.serviceCategories,
  'country': instance.country,
  'city': instance.city,
  'district': instance.district,
  'detailedAddress': instance.detailedAddress,
  'representativeName': instance.representativeName,
  'governmentIdNumber': instance.governmentIdNumber,
  'frontIdUrl': instance.frontIdUrl,
  'backIdUrl': instance.backIdUrl,
  'requiresAuthorizationLetter': instance.requiresAuthorizationLetter,
  'authorizationLetterUrl': instance.authorizationLetterUrl,
  'password': instance.password,
};
