class MindTreeTreeData {
  int id;
  String label;
  List<MindTreeTreeData> _children;
  MindTreeTreeData(this.id, this.label)
      : _children = [];

  MindTreeTreeData.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        label = json['label'],
        _children = (json['children'] as List<dynamic>)
            .map((j) => MindTreeTreeData.fromJson(j))
            .toList();

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'children': _children.map((e) => e),
  };

  List<MindTreeTreeData> get children => _children;
}
