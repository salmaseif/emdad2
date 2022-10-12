class UserInfoModel {
  int id;
  String name;
  String method;
  String fName;
  String lName;
  String phone;
  String image;
  String email;
  String emailVerifiedAt;
  String createdAt;
  String updatedAt;
  String imageDoc1;
  String imageDoc2;
  String isVerifiedDoc;
  String isVerifiedPhone;
  String isVerifiedAddress;
  int isComplete;
  int isDoc;
  int isDocReq;
  String treadType;
  String categorySelected;
  String saleAmount;

  UserInfoModel(
      {this.id, this.name, this.method, this.fName, this.lName, this.phone, this.image, this.imageDoc1, this.imageDoc2, this.email, this.emailVerifiedAt, this.createdAt, this.updatedAt, this.isComplete, this.isDoc, this.isDocReq, this.treadType, this.categorySelected, this.saleAmount});

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    method = json['_method'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    image = json['image'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageDoc1 = json['imageDoc1'];
    imageDoc2 = json['imageDoc2'];
    isComplete = int.parse(json['isComplete']);
    isDoc = int.parse(json['isDoc']);
    isDocReq = int.parse(json['isDocReq']);
    treadType = json['treadType'];
    categorySelected = json['categorySelected'];
    saleAmount = json['sale_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['_method'] = this.method;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['imageDoc1'] = this.imageDoc1;
    data['imageDoc2'] = this.imageDoc2;
    data['isComplete'] = this.isComplete;
    data['isDoc'] = this.isDoc;
    data['isDocReq'] = this.isDocReq;
    data['treadType'] = this.treadType;
    data['categorySelected'] = this.categorySelected;
    data['sale_amount'] = this.saleAmount;
    return data;
  }
}
