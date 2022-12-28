class FilterModel {
  final String filterBy;
  final String filterName;
  bool selected;

  FilterModel({required this.filterBy, this.selected = false, required this.filterName});
}
