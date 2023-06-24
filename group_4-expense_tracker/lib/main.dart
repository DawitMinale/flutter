import 'package:expense_app/screens/budget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:expense_app/blocs/app_blocs.dart';
import 'package:expense_app/repositories/repositories.dart';

void main() async {
  // Google Fonts License
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  const MyApp({
    required this.sharedPreferences,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TransactionsRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<TransactionsBloc>(
            create: (context) => TransactionsBloc(transactionsRepository: context.read<TransactionsRepository>(),),
          ),
          BlocProvider<BudgetsBloc>(
            create: (context) => BudgetsBloc(
              budgetsRepository: context.read<TransactionsRepository>(),
            )..add(GetBudgets()),
          ),
          BlocProvider(
            create: (context) => ThemeCubit(
              preferences: sharedPreferences,
            ),
          ),
        ],
        child: const ExpenseTrackerApp(),
      ),
    );
  }
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Expense Tracker',
          home: BudgetScreen(),
          theme: state.theme,
        );
      },
    );
  }
}
