class BaseDatabaseModel{
  BaseDatabaseModel();
  factory BaseDatabaseModel.fromMap(Map<String, dynamic> json) => BaseDatabaseModel();
  Map<String, dynamic> toMap() =>{};
}