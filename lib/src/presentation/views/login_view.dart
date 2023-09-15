import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:cocktail_app/src/config/router/app_router.dart';
import 'package:cocktail_app/src/domain/models/requests/login_request.dart';
import 'package:cocktail_app/src/presentation/cubits/remote_login/remote_login_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

@RoutePage()
class LoginView extends HookWidget {

  LoginView({Key? key}) : super (key: key);

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final remoteLoginCubit = BlocProvider.of<RemoteLoginCubit>(context);

    useEffect(() {
      remoteLoginCubit.isAlreadyLoggedIn();
      return ;
    }, const []);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocBuilder<RemoteLoginCubit, RemoteLoginState>(
        builder: (context, state) {
          if (state.runtimeType == RemoteLoginLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.runtimeType == RemoteLoginFailed) {
            return _buildLoginForm(context, remoteLoginCubit, state.exception);
          } else {
            return _buildLoginForm(context, remoteLoginCubit, null);
          }
        },
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, RemoteLoginCubit remoteLoginCubit, DioException? error) {
    return Container(
      child: Center(
        child: Column(
          children: [
            Container(
              width: 600,
              height: 300,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent.withOpacity(0.4),
              ),
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                        TextField(
                          controller: usernameController,
                          cursorColor: Colors.deepPurple,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.deepPurple, style: BorderStyle.solid, width: 1.5)
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Username',
                          ),
                        ),
                        TextField(
                          controller: passwordController,
                          cursorColor: Colors.deepPurple,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.deepPurple, style: BorderStyle.solid, width: 1.5)
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Password',
                          ),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.blue),
                            textStyle: MaterialStateProperty.all(const TextStyle(color: Colors.white)),
                            padding: MaterialStateProperty.all(const EdgeInsets.all(8)),
                          ),
                          onPressed: () {
                            remoteLoginCubit.logIn(request : LoginRequest(
                                username: usernameController.text,
                                password: passwordController.text
                            ));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                              child: const Text("Log in",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),)
                          ),
                        ),
                      ],
                    ),
                ),
            ),
            Visibility(
              visible: error != null,
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                child: Center(
                    child: Text(error == null ? "" : error.response?.data["errors"][0]["detail"] ?? "",
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
