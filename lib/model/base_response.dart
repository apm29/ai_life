class BaseResp<T> {
  String status;
  T data;
  String token;
  String text;

  BaseResp(this.status, this.data, this.token, this.text);

  BaseResp.error({String message = "失败", T data}) {
    this.status = "0";
    this.data = null;
    this.token = null;
    this.text = message;
  }

  BaseResp.success({String message = "成功"}) {
    this.status = "1";
    this.data = null;
    this.token = null;
    this.text = message;
  }

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{\r\n');
    sb.write("\"status\":\"$status\"");
    sb.write(",\r\n\"token\":$token");
    sb.write(",\r\n\"text\":\"$text\"");
    sb.write(",\r\n\"data\":\"$data\"");
    sb.write('\r\n}');
    return sb.toString();
  }

  bool get success => status == "1";
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

  Announcement({
    this.noticeId,
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
    this.commentNum,
  });

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

class DistrictDetail {
  int districtId;
  String districtName;
  String districtInfo;
  String districtAddr;
  String districtPic;
  int orderNo;

  DistrictDetail(
      {this.districtId,
      this.districtName,
      this.districtInfo,
      this.districtAddr,
      this.districtPic,
      this.orderNo});

  DistrictDetail.fromJson(Map<String, dynamic> json) {
    districtId = json['districtId'];
    districtName = json['districtName'];
    districtInfo = json['districtInfo'];
    districtAddr = json['districtAddr'];
    districtPic = json['districtPic'];
    orderNo = json['orderNo'];
  }

  @override
  bool operator ==(other) {
    if (other == null || other is! DistrictDetail) {
      return false;
    } else if (other is DistrictDetail) {
      return districtId == other.districtId &&
          districtName == other.districtName &&
          districtInfo == other.districtInfo &&
          districtAddr == other.districtAddr &&
          districtPic == other.districtPic &&
          orderNo == other.orderNo;
    }
    return false;
  }

  @override
  int get hashCode {
    return super.hashCode;
  }

  @override
  String toString() {
    return 'DistrictDetail{districtId: $districtId, districtName: $districtName, districtInfo: $districtInfo, districtAddr: $districtAddr, districtPic: $districtPic, orderNo: $orderNo}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['districtId'] = this.districtId;
    data['districtName'] = this.districtName;
    data['districtInfo'] = this.districtInfo;
    data['districtAddr'] = this.districtAddr;
    data['districtPic'] = this.districtPic;
    data['orderNo'] = this.orderNo;
    return data;
  }
}

class Index {
  String area;
  List<MenuItem> menu;

  @override
  String toString() {
    return '{"area":"$area","menu":[${menu.join(",")}]}';
  }

  Index.fromJson(Map<String, dynamic> json) {
    this.area = json['area'];
    if (json['menu'] != null) {
      menu = new List<MenuItem>();
      json['menu'].forEach((v) {
        menu.add(new MenuItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['area'] = this.area;
    if (this.menu != null) {
      data['menu'] = this.menu.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MenuItem {
  String id;
  String remark;
  String url;

  MenuItem(this.id, this.remark, this.url);

  @override
  String toString() {
    return '{"id":"$id","remark":"$remark","url":"$url"}';
  }

  MenuItem.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.remark = json['remark'];
    this.url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['remark'] = this.remark;
    data['url'] = this.url;
    return data;
  }
}

class UserVerifyStatus {
  ///
  /// code 0 未认证
  /// code 1 有房认证中
  /// code 2 无房认证中
  /// code 3 有房认证成功
  /// code 4 无房认证成功
  /// code 5 有房认证失败
  /// code 6 无房认证失败
  ///
  int code;

  UserVerifyStatus({this.code});

  UserVerifyStatus.fromJson(Map<String, dynamic> json) {
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    return data;
  }

  bool hasHouse() {
    return code == 1 || code == 3 || code == 5;
  }

  bool isVerified() {
    return code == 3 || code == 4;
  }

  String getVerifyText() {
    String text;
    switch (code) {
      case 0:
        text = "未认证";
        break;
      case 1:
        text = "认证中";
        break;
      case 2:
        text = "认证中";
        break;
      case 3:
        text = "已认证";
        break;
      case 4:
        text = "已认证";
        break;
      case 5:
        text = "认证失败";
        break;
      case 6:
        text = "认证失败";
        break;
      default:
        text = "--";
        break;
    }
    return text;
  }

  @override
  String toString() {
    return '{"code": $code}';
  }
}


class UserType {
  int id;
  String userId;

  ///物业人员 1
  ///有房认证用户 2
  ///民警 3
  ///无房认证用户 4
  ///家庭成员 5
  ///无认证用户 6
  String roleCode;

  UserType({this.id, this.userId, this.roleCode});

  UserType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    roleCode = json['roleCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['roleCode'] = this.roleCode;
    return data;
  }

  @override
  String toString() {
    return 'UserType{id: $id, userId: $userId, roleCode: $roleCode}';
  }
}