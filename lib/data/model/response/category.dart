class Category {
  int _id;
  String _name;
  String _slug;
  String _icon;
  int _parentId;
  int _position;
  String _createdAt;
  String _updatedAt;
  bool isSelected;
  List<SubCategory> _subCategories;

  Category(
      {
        int id,
        String name,
        String slug,
        String icon,
        int parentId,
        int position,
        String createdAt,
        String updatedAt,
        bool isSelected = false,
        List<SubCategory> subCategories
      }) {
    this._id = id;
    this._name = name;
    this._slug = slug;
    this._icon = icon;
    this._parentId = parentId;
    this._position = position;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this.isSelected = isSelected;
    this._subCategories = subCategories;
  }

  int get id => _id;
  String get name => _name;
  String get slug => _slug;
  String get icon => _icon;
  int get parentId => _parentId;
  int get position => _position;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  List<SubCategory> get subCategories => _subCategories;

  Category.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _slug = json['slug'];
    _icon = json['icon'];
    _parentId = json['parent_id'];
    _position = json['position'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    if (json['isSelected'] != null) {
      isSelected = json['isSelected'];
    } else {
      isSelected = false;
    }
    if (json['childes'] != null) {
      _subCategories = [];
      json['childes'].forEach((v) {
        _subCategories.add(new SubCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['slug'] = this._slug;
    data['icon'] = this._icon;
    data['parent_id'] = this._parentId;
    data['position'] = this._position;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['isSelected'] = this.isSelected;
    if (this._subCategories != null) {
      data['childes'] = this._subCategories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategory {
  int _id;
  String _name;
  String _slug;
  String _icon;
  int _parentId;
  int _position;
  String _createdAt;
  String _updatedAt;
  bool _isSelect;
  List<SubSubCategory> _subSubCategories;

  SubCategory(
      {int id,
        String name,
        String slug,
        String icon,
        int parentId,
        int position,
        String createdAt,
        String updatedAt,
        bool isSelect,
        List<SubSubCategory> subSubCategories}) {
    this._id = id;
    this._name = name;
    this._slug = slug;
    this._icon = icon;
    this._parentId = parentId;
    this._position = position;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._isSelect = isSelect;
    this._subSubCategories = subSubCategories;
  }

  int get id => _id;
  String get name => _name;
  String get slug => _slug;
  String get icon => _icon;
  int get parentId => _parentId;
  int get position => _position;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  bool get isSelect => _isSelect;
  List<SubSubCategory> get subSubCategories => _subSubCategories;

  SubCategory.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _slug = json['slug'];
    _icon = json['icon'];
    _parentId = json['parent_id'];
    _position = json['position'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    if (json['isSelect'] != null) {
      _isSelect = json['isSelect'];
    } else {
      _isSelect = false;
    }
    if (json['childes'] != null) {
      _subSubCategories = [];
      json['childes'].forEach((v) {
        _subSubCategories.add(new SubSubCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['slug'] = this._slug;
    data['icon'] = this._icon;
    data['parent_id'] = this._parentId;
    data['position'] = this._position;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['isSelect'] = this._isSelect;
    if (this._subSubCategories != null) {
      data['childes'] = this._subSubCategories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubSubCategory {
  int _id;
  String _name;
  String _slug;
  String _icon;
  int _parentId;
  int _position;
  String _createdAt;
  String _updatedAt;

  SubSubCategory(
      {int id,
        String name,
        String slug,
        String icon,
        int parentId,
        int position,
        String createdAt,
        String updatedAt}) {
    this._id = id;
    this._name = name;
    this._slug = slug;
    this._icon = icon;
    this._parentId = parentId;
    this._position = position;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }

  int get id => _id;
  String get name => _name;
  String get slug => _slug;
  String get icon => _icon;
  int get parentId => _parentId;
  int get position => _position;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  SubSubCategory.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _slug = json['slug'];
    _icon = json['icon'];
    _parentId = json['parent_id'];
    _position = json['position'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['slug'] = this._slug;
    data['icon'] = this._icon;
    data['parent_id'] = this._parentId;
    data['position'] = this._position;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}