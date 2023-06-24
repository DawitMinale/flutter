part of 'theme_cubit.dart';

enum ThemeColor {
  red,
  purple,
  blue,
  green,
}

const appBarTheme = AppBarTheme(titleTextStyle: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 20));

final purpleTheme = ThemeData(
  primarySwatch: Colors.purple,
  secondaryHeaderColor: Colors.amber,
  fontFamily: 'Poppins',
  appBarTheme: appBarTheme,
);

final greenTheme = ThemeData(
  primarySwatch: Colors.green,
  secondaryHeaderColor: Colors.amber,
  fontFamily: 'Poppins',
  appBarTheme: appBarTheme,
);

final redTheme = ThemeData(
  primarySwatch: Colors.red,
  secondaryHeaderColor: Colors.grey[350],
  fontFamily: 'Poppins',
  appBarTheme: appBarTheme,
);

final blueTheme = ThemeData(
  primarySwatch: Colors.blue,
  secondaryHeaderColor: Colors.blueGrey.shade200,
  fontFamily: 'Poppins',
  appBarTheme: appBarTheme,
);

class ThemeState extends Equatable {
  final ThemeColor color;
  final ThemeData theme;

  ThemeState({
    required this.color,
    required this.theme,
  });

  factory ThemeState.initial() {
    return ThemeState(color: ThemeColor.green, theme: greenTheme);
  }

  @override
  List<Object> get props => [color, theme];

  ThemeState copyWith({
    ThemeColor? color,
    ThemeData? theme,
  }) {
    return ThemeState(
      color: color ?? this.color,
      theme: theme ?? this.theme,
    );
  }
}
