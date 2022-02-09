import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarkett/screens/products/cubit/products_cubit.dart';
import 'package:supermarkett/screens/receipt/receipt_screen.dart';
import 'package:supermarkett/screens/splash_screen/splash_screen.dart';
import 'package:supermarkett/shared/bloc_observer/bloc_observer.dart';
import 'network/local/cache_helper/cache_helper.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Cache_Helper.sharedprefInstance();

  BlocOverrides.runZoned (() {
    runApp(MyApp());
  },
  blocObserver: MyBlocObserver(),
  );

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductsCubit>(create: (_)=>ProductsCubit(),),
      ],
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            color:Colors.teal
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.teal[300]
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
              )
          ),
          dataTableTheme: DataTableThemeData(
            headingRowColor:MaterialStateProperty.all<Color>(Color(0xff8E1600)),
            headingTextStyle: const TextStyle(
              color: Colors.white
            )
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}

