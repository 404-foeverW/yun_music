// 验证操作
class Verify {
  int? actionCode;
  int verifyType;
  int verifyId;
  String verifyUrl;
  String blockText;
  String? verifyToken;
  String btnText;
  String orpheusUrl;
  int? frontRuleIds;
  Map<String, dynamic> params;
  String url;
  int urlAutoOpen;
  int? orpheusUrlParamAppend;

  Verify({
    this.actionCode,
    required this.verifyType,
    required this.verifyId,
    required this.verifyUrl,
    required this.blockText,
    this.verifyToken,
    required this.btnText,
    required this.orpheusUrl,
    this.frontRuleIds,
    required this.params,
    required this.url,
    required this.urlAutoOpen,
    this.orpheusUrlParamAppend,
  });

  factory Verify.fromJson(Map<String, dynamic> json) {
    return Verify(
      actionCode: json['actionCode'],
      verifyType: json['verifyType'],
      verifyId: json['verifyId'],
      verifyUrl: json['verifyUrl'],
      blockText: json['blockText'],
      verifyToken: json['verifyToken'] ?? '',
      btnText: json['btnText'],
      orpheusUrl: json['orpheusUrl'],
      frontRuleIds: json['frontRuleIds'],
      params: json['params'],
      url: json['url'],
      urlAutoOpen: json['urlAutoOpen'],
      orpheusUrlParamAppend: json['orpheusUrlParamAppend'],
    );
  }
}