
class Products {
  int? errorCode;
  String? errorMsg;
  String? message;
  String? result;
  List<ResultList>? resultList;

  Products(
      {this.errorCode,
        this.errorMsg,
        this.message,
        this.result,
        this.resultList});

  Products.fromJson(Map<String, dynamic> json) {
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
    message = json['message'];
    result = json['result'];
    if (json['resultList'] != null) {
      resultList = <ResultList>[];
      json['resultList'].forEach((v) {
        resultList!.add(ResultList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['errorCode'] = errorCode;
    data['errorMsg'] = errorMsg;
    data['message'] = message;
    data['result'] = result;
    if (resultList != null) {
      data['resultList'] = resultList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResultList {
  String? accountType;
  bool? signedUp;

  ResultList({this.accountType, this.signedUp});

  ResultList.fromJson(Map<String, dynamic> json) {
    accountType = json['accountType'];
    signedUp = json['signedUp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['accountType'] = accountType;
    data['signedUp'] = signedUp;
    return data;
  }

  static Map<String, dynamic> productDescription =
  { "SMC": "Secure Message Connect",
    "VIDEOCONNECT": "Send and receive video message",
    "ADVANCECONNECT": "Fund or manage your prepaid calling account",
    "EMESSAGE": "Send and receive messages",
    "VIDEOGRAM": "Record or send from gallery a 30-second video!",
    "SNAPSEND": "Take a photo and instantly send",
    "SECURUSDEBIT": "Fund an individual's Securus account",
    "TEXTCONNECT": "Send and receive text messages"
  };

  static Map<String, dynamic> productTitle =
  { "SMC": "SMC",
    "VIDEOCONNECT": "VIDEO CONNECT",
    "ADVANCECONNECT": "ADVANCE CONNECT",
    "EMESSAGE": " eMESSAGING™",
    "VIDEOGRAM": "VIDEOGRAM",
    "SNAPSEND": "SNAP n' SEND®",
    "SECURUSDEBIT": "SECURUS DEBIT",
    "TEXTCONNECT": "TEXT CONNECT"
  };
}

