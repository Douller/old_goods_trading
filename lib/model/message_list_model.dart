class MessageListModel {
  String? id;
  String? isRead;
  String? type;
  String? title;
  String? content;
  String? createTime;
  String? thumb;
  Jump? jump;

  MessageListModel(
      {this.id,
        this.isRead,
        this.type,
        this.title,
        this.content,
        this.createTime,
        this.thumb,
        this.jump});

  MessageListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isRead = json['is_read'];
    type = json['type'];
    title = json['title'];
    content = json['content'];
    createTime = json['create_time'];
    thumb = json['thumb'];
    jump = json['jump'] != null ?  Jump.fromJson(json['jump']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['is_read'] = isRead;
    data['type'] = type;
    data['title'] = title;
    data['content'] = content;
    data['create_time'] = createTime;
    data['thumb'] = thumb;
    if (jump != null) {
      data['jump'] = jump?.toJson();
    }
    return data;
  }
}

class Jump {
  String? type;
  String? data;

  Jump({this.type, this.data});

  Jump.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['type'] = type;
    data['data'] = data;
    return data;
  }
}
