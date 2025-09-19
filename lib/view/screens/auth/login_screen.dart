import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override void dispose(){_email.dispose();_password.dispose();super.dispose();}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In'), backgroundColor: AppColors.accentBlue, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            const SizedBox(height: 24),
            TextFormField(
              controller: _email, keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (v)=> v!=null && v.contains('@') ? null : 'Enter a valid email',
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _password, obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: (v)=> (v??'').length>=6 ? null : 'Min 6 chars',
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : () async {
                  if(!_formKey.currentState!.validate()) return;
                  setState(()=>_loading=true);
                  await Future.delayed(const Duration(milliseconds: 600));
                  if(!mounted) return;
                  context.go(RouteNames.dashboard);
                },
                child: _loading ? const CircularProgressIndicator() : const Text('Login'),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(onPressed: ()=>_showResetDialog(context), child: const Text('Forgot password?')),
            const Divider(height: 32),
            OutlinedButton.icon(onPressed: (){}, icon: const Icon(Icons.account_circle), label: const Text('Continue with Google')),
            const SizedBox(height: 8),
            OutlinedButton.icon(onPressed: (){}, icon: const Icon(Icons.apple), label: const Text('Continue with Apple')),
          ]),
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext ctx){
    showDialog(context: ctx, builder: (_)=> AlertDialog(
      title: const Text('Reset Password'),
      content: const Text('A password reset link will be sent to your email.'),
      actions: [ TextButton(onPressed: ()=>Navigator.pop(ctx), child: const Text('OK')) ],
    ));
  }
}
