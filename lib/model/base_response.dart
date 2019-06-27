class BaseResp<T>{
  String status;
  T data;
  String token;
  String text;

  BaseResp(this.status, this.data, this.token, this.text);

  BaseResp.error({String message = "失败"}){
    this.status = "0";
    this.data = null;
    this.token = null;
    this.text = message;
  }

  BaseResp.success({String message = "成功"}){
    this.status = "1";
    this.data = null;
    this.token = null;
    this.text = message;
  }

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"status\":\"$status\"");
    sb.write(",\"token\":$token");
    sb.write(",\"text\":\"$text\"");
    sb.write(",\"data\":\"$data\"");
    sb.write('}');
    return sb.toString();
  }

  bool get success=>status == "1";

}



class UserInfoWrapper {
  UserInfo userInfo;

  UserInfoWrapper(this.userInfo);

  @override
  String toString() {
    return "{\"userInfo\":$userInfo}";
  }

  UserInfoWrapper.fromJson(Map<String, dynamic> json) {
    userInfo =
        UserInfo.fromJson(json["userInfo"] is Map ? json["userInfo"] : {});
  }
}

class UserInfo {
  String userId;
  String userName;
  String mobile;

  UserInfo({this.userId, this.userName, this.mobile});

  @override
  String toString() {
    return '{"userId": "$userId", "userName": "$userName", "mobile": "$mobile"}';
  }

  UserInfo.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['mobile'] = this.mobile;
    return data;
  }
}

class AnnouncementType {
  int typeId;
  int typeUid;
  String typeName;

  AnnouncementType({this.typeId, this.typeUid, this.typeName});

  AnnouncementType.fromJson(Map<String, dynamic> json) {
    typeId = json['typeId'];
    typeUid = json['typeUid'];
    typeName = json['typeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['typeId'] = this.typeId;
    data['typeUid'] = this.typeUid;
    data['typeName'] = this.typeName;
    return data;
  }
}


class Announcement {
  int noticeId;
  String noticeTitle;
  String noticeContent;
  List<String> noticeBanner;
  int noticeType;
  String noticeScope;
  int districtId;
  String userId;
  int companyId;
  String userName;
  String companyName;
  String createTime;
  Null orderNo;
  int likeNum;
  int commentNum;

  Announcement(
      {this.noticeId,
        this.noticeTitle,
        this.noticeContent,
        this.noticeBanner,
        this.noticeType,
        this.noticeScope,
        this.districtId,
        this.userId,
        this.companyId,
        this.userName,
        this.companyName,
        this.createTime,
        this.orderNo,
        this.likeNum,
        this.commentNum,});

  Announcement.fromJson(Map<String, dynamic> json) {
    noticeId = json['noticeId'];
    noticeTitle = json['noticeTitle'];
    noticeContent = json['noticeContent'];
    noticeBanner = json['noticeBanner'].cast<String>();
    noticeType = json['noticeType'];
    noticeScope = json['noticeScope'];
    districtId = json['districtId'];
    userId = json['userId'];
    companyId = json['companyId'];
    userName = json['userName'];
    companyName = json['companyName'];
    createTime = json['createTime'];
    orderNo = json['orderNo'];
    likeNum = json['likeNum'];
    commentNum = json['commentNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['noticeId'] = this.noticeId;
    data['noticeTitle'] = this.noticeTitle;
    data['noticeContent'] = this.noticeContent;
    data['noticeBanner'] = this.noticeBanner;
    data['noticeType'] = this.noticeType;
    data['noticeScope'] = this.noticeScope;
    data['districtId'] = this.districtId;
    data['userId'] = this.userId;
    data['companyId'] = this.companyId;
    data['userName'] = this.userName;
    data['companyName'] = this.companyName;
    data['createTime'] = this.createTime;
    data['orderNo'] = this.orderNo;
    data['likeNum'] = this.likeNum;
    data['commentNum'] = this.commentNum;
    return data;
  }
}



