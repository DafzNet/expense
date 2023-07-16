// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:expense/dbs/budget_db.dart';
import 'package:expense/dbs/category_db.dart';
import 'package:expense/dbs/expense.dart';
import 'package:expense/dbs/income_db.dart';
import 'package:expense/dbs/plan_exp_db.dart';
import 'package:expense/dbs/planner_db.dart';
import 'package:expense/dbs/saving_db.dart';
import 'package:expense/dbs/vault_db.dart';
import 'package:expense/dbs/versions.dart';
import 'package:expense/firebase/db/budget/budget.dart';
import 'package:expense/firebase/db/category/category.dart';
import 'package:expense/firebase/db/expense/fs_expense.dart';
import 'package:expense/firebase/db/income/income.dart';
import 'package:expense/firebase/db/planner_exp/planner_exp.dart';
import 'package:expense/firebase/db/planners/planners.dart';
import 'package:expense/firebase/db/savings/savings.dart';
import 'package:expense/firebase/db/vault/vault.dart';
import 'package:expense/firebase/db/vesion/version.dart';
import 'package:sembast/sembast.dart';

import '../../models/version.dart';
import '../month.dart';

class BackupAndSync{
  final uid;
  final context;
  
  BackupAndSync(
    this.uid,
    {this.context}
    );

  ///Get all local dbs
    final expenseDb = ExpenseDb();
    final incomeDb = IncomeDb();
    final savingsDb = SavingsDb();
    final budgetDb = BudgetDb();
    final categoryDb = CategoryDb();
    final vaultDb = VaultDb();
    final plannerDb = PlannerDb();
    final plannerExpDb = PlannerExpDb();
    final versionDb = VersionDb();

  Future backup({bool force = false})async{

    final firebaseVersionDb = FirebaseVersionDb(uid: uid);

    ///////////////////////////////////////////////////////////////
    ///All remote dbs
    final fbexpenseDb = FirebaseExpenseDb(uid: uid);
    final fbincomeDb = FirebaseIncomeDb(uid: uid);
    final fbsavingsDb = FirebaseSavingsDb(uid: uid);
    final fbbudgetDb = FirebaseBudgetDb(uid: uid);
    final fbcategoryDb = FirebaseCategoryDb(uid: uid);
    final fbvaultDb = FirebaseVaultDb(uid: uid);
    final fbplannerDb = FirebasePlannerDb(uid: uid);
    final fbplannerExpDb = FirebasePlannerExpDb(uid: uid);


    await firebaseVersionDb.createVersion(
       VersionModel(
          id: DateTime.now().millisecondsSinceEpoch
        )
    );

    VersionModel firebaseVersion = await firebaseVersionDb.getVersion;
    VersionModel? localVersion = await versionDb.retrieveData();

    //compare both version to know what to backup
    
    //compare expenses
    //if local version is greater, then, check the exps not in remote version and add them
      if (force || localVersion.expenseDbVersion > firebaseVersion.expenseDbVersion){
        final expenses = await expenseDb.retrieveBasedOn(
          Filter.and(
            [
              Filter.equals('month', Month().currentMonthNumber),
              Filter.equals('year', DateTime.now().year)
          ]
        )
      );

      if (expenses.isNotEmpty) {
        for (var exp in expenses) {
          await fbexpenseDb.addExpense(exp);
        }
      }

      firebaseVersion = firebaseVersion.copyWith(
        expenseDbVersion: localVersion.expenseDbVersion
      );
    }

    ////////////////////////////////////////////
    ///backup income
    if (force || localVersion.incomeDbVersion > firebaseVersion.incomeDbVersion){
        final incomes = await incomeDb.retrieveBasedOn(
          Filter.and(
            [
              Filter.equals('month', Month().currentMonthNumber),
              Filter.equals('year', DateTime.now().year)
          ]
        )
      );

      if (incomes.isNotEmpty) {
        for (var income in incomes) {
          await fbincomeDb.addIncome(income);
        }
      }

      firebaseVersion = firebaseVersion.copyWith(
        incomeDbVersion: localVersion.incomeDbVersion
      );
    }

    ////////////////////////////////////////////////////////////////
    ///savings
    if (force || localVersion.savingsDbVersion > firebaseVersion.savingsDbVersion){
        final savings = await savingsDb.retrieveData();

      if (savings.isNotEmpty) {
        for (var saving in savings) {
          await fbsavingsDb.addSaving(saving);
        }
      }

      firebaseVersion = firebaseVersion.copyWith(
        savingsDbVersion: localVersion.savingsDbVersion
      );
    }

    ///////////////////////////////////////////////////////////////////////
    ///budgets
    if (force || localVersion.budgetDbVersion > firebaseVersion.budgetDbVersion){
        final budgets = await budgetDb.retrieveData();

      if (budgets.isNotEmpty) {
        for (var budget in budgets) {
          await fbbudgetDb.addBudget(budget);
        }
      }

      firebaseVersion = firebaseVersion.copyWith(
        budgetDbVersion: localVersion.budgetDbVersion
      );
    }


    ///////////////////////////////////////////////////////////////////////
    ///Categories
    if (force || localVersion.categoryDbVersion > firebaseVersion.categoryDbVersion){
        final cats = await categoryDb.retrieveData();

      if (cats.isNotEmpty) {
        for (var cat in cats) {
          await fbcategoryDb.addcategory(cat);
        }
      }

      firebaseVersion = firebaseVersion.copyWith(
        categoryDbVersion: localVersion.categoryDbVersion
      );
    }


    ///////////////////////////////////////////////////////////////////////
    ///Vaults
    if (force || localVersion.vaultDbVersion > firebaseVersion.vaultDbVersion){
        final vaults = await vaultDb.retrieveData();

      if (vaults.isNotEmpty) {
        for (var vault in vaults) {
          await fbvaultDb.addVault(vault);
        }
      }

      firebaseVersion = firebaseVersion.copyWith(
        vaultDbVersion: localVersion.vaultDbVersion
      );
    }


    ///////////////////////////////////////////////////////////////////////
    ///Planners
    if (force || localVersion.plannerDbVersion > firebaseVersion.plannerDbVersion){
        final planners = await plannerDb.retrieveData();

      if (planners.isNotEmpty) {
        for (var planner in planners) {
          await fbplannerDb.addPlanner(planner);
        }
      }

      firebaseVersion = firebaseVersion.copyWith(
        plannerDbVersion: localVersion.plannerDbVersion
      );
    }


    ///////////////////////////////////////////////////////////////////////
    ///planner Exps
    if (force || localVersion.plannerExpDbVersion > firebaseVersion.plannerExpDbVersion){
        final plansExps = await plannerExpDb.retrieveData();

      if (plansExps.isNotEmpty) {
        for (var plan in plansExps) {
          await fbplannerExpDb.addPlannerExp(plan);
        }
      }

      firebaseVersion = firebaseVersion.copyWith(
        plannerExpDbVersion: localVersion.plannerExpDbVersion
      );

      await firebaseVersionDb.update(firebaseVersion);
    }

    return true;
    }
  

/////////////////////////////////////////////////////Sync
  Future sync({bool force = false})async{

    final firebaseVersionDb = FirebaseVersionDb(uid: uid);

    ///////////////////////////////////////////////////////////////
    ///All remote dbs
    final fbexpenseDb = FirebaseExpenseDb(uid: uid);
    final fbincomeDb = FirebaseIncomeDb(uid: uid);
    final fbsavingsDb = FirebaseSavingsDb(uid: uid);
    final fbbudgetDb = FirebaseBudgetDb(uid: uid);
    final fbcategoryDb = FirebaseCategoryDb(uid: uid);
    final fbvaultDb = FirebaseVaultDb(uid: uid);
    final fbplannerDb = FirebasePlannerDb(uid: uid);
    final fbplannerExpDb = FirebasePlannerExpDb(uid: uid);


    await firebaseVersionDb.createVersion(
       VersionModel(
          id: DateTime.now().millisecondsSinceEpoch
        )
    );

    VersionModel firebaseVersion = await firebaseVersionDb.getVersion;
    VersionModel? localVersion = await versionDb.retrieveData();

    //compare both version to know what to backup
    
    //compare expenses
    //if local version is greater, then, check the exps not in remote version and add them
      if (force || localVersion.expenseDbVersion < firebaseVersion.expenseDbVersion){
        final expenses = await fbexpenseDb.getExpenses();

      if (expenses.isNotEmpty) {
        await expenseDb.addExpenses(expenses);
      }

      localVersion = localVersion.copyWith(
        expenseDbVersion: firebaseVersion.expenseDbVersion
      );
    }

    ////////////////////////////////////////////
    ///backup income
    if (force || localVersion.incomeDbVersion < firebaseVersion.incomeDbVersion){
      final incomes = await fbincomeDb.getIncomes();
      await incomeDb.addIncomes(incomes);

      localVersion = localVersion.copyWith(
        incomeDbVersion: firebaseVersion.incomeDbVersion
      );
    }

    ////////////////////////////////////////////////////////////////
    ///savings
    if (force || localVersion.savingsDbVersion < firebaseVersion.savingsDbVersion){
      final savings = await fbsavingsDb.getSavings();

      if (savings.isNotEmpty) {
        await savingsDb.addSavings(savings);
      }

      localVersion = localVersion.copyWith(
        savingsDbVersion: firebaseVersion.savingsDbVersion
      );
    }

    ///////////////////////////////////////////////////////////////////////
    ///budgets
    if (force || localVersion.budgetDbVersion < firebaseVersion.budgetDbVersion){
        final budgets = await fbbudgetDb.getBudgets();

      if (budgets.isNotEmpty) {
        await budgetDb.addBudgets(budgets);
      }

      localVersion = localVersion.copyWith(
        budgetDbVersion: firebaseVersion.budgetDbVersion
      );
    }


    ///////////////////////////////////////////////////////////////////////
    ///Categories
    if (force || localVersion.categoryDbVersion < firebaseVersion.categoryDbVersion){
        final cats = await fbcategoryDb.getCategory();

      if (cats.isNotEmpty) {
        await categoryDb.addCategories(cats);
      }

      localVersion = localVersion.copyWith(
        categoryDbVersion: firebaseVersion.categoryDbVersion
      );
    }


    ///////////////////////////////////////////////////////////////////////
    ///Vaults
    if (force || localVersion.vaultDbVersion < firebaseVersion.vaultDbVersion){
        final vaults = await fbvaultDb.getVaults();

      if (vaults.isNotEmpty) {
        await vaultDb.addVaults(vaults);
      }

      localVersion = localVersion.copyWith(
        vaultDbVersion: firebaseVersion.vaultDbVersion
      );
    }


    ///////////////////////////////////////////////////////////////////////
    ///Planners
    if (force || localVersion.plannerDbVersion < firebaseVersion.plannerDbVersion){
        final planners = await fbplannerDb.getPlanners();

      if (planners.isNotEmpty) {
        await plannerDb.addPlanners(planners);
      }

      localVersion = localVersion.copyWith(
        plannerDbVersion: firebaseVersion.plannerDbVersion
      );
    }


    ///////////////////////////////////////////////////////////////////////
    ///planner Exps
    if (force || localVersion.plannerExpDbVersion < firebaseVersion.plannerExpDbVersion){
        final plansExps = await fbplannerExpDb.getPlannerExps();

      if (plansExps.isNotEmpty) {
        await plannerExpDb.addPlanExps(plansExps);
      }

      localVersion = localVersion.copyWith(
        plannerExpDbVersion: firebaseVersion.plannerExpDbVersion
      );

      
    }

    await versionDb.addData(localVersion);

    return true;
    }
  }