class RecipeModel {
  late String app_label;
  late String app_img_uri;
  late String app_calories;
  late String app_url;
  RecipeModel(
      {this.app_label = "",
      this.app_img_uri = "",
      this.app_calories = "",
      this.app_url = ""});
  factory RecipeModel.fromMap(Map recipe) {
    return RecipeModel(
        app_label: recipe["label"],
        app_calories: (recipe["calories"]).toString(),
        app_img_uri: recipe["image"],
        app_url: recipe["url"]);
  }
}
