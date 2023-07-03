import 'package:expense/models/budget.dart';

class PlanModel{
  dynamic id;
  BudgetModel budget;
  String name;
  String? description;

  PlanModel(
    {
      this.id,
      required this.budget,
      required this.name,
      this.description
    }
  );

}