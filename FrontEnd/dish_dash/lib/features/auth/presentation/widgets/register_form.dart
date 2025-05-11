import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import 'gender_selector.dart';
import 'level_dropdown.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _gender;
  int? _level;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().register(
        userName: _userNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        gender: _gender,
        level: _level,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '✨',
                  style: TextStyle(
                    fontSize: 46,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'DM Sans',
                  ),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Create account',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 15),

              // Username
              const Text(
                'Username',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'DM Sans'),
              ),
              const SizedBox(height: 3),
              TextFormField(
                controller: _userNameController,
                decoration: InputDecoration(
                  hintText: 'Your username',
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Username is required' : null,
              ),
              const SizedBox(height: 6),

              // Email
              const Text(
                'Email',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'DM Sans'),
              ),
              const SizedBox(height: 3),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Your email',
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Email is required';
                  if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Invalid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 6),

              // Password
              const Text(
                'Password',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'DM Sans'),
              ),
              const SizedBox(height: 3),
              TextFormField(
                controller: _passwordController,
                obscureText: !_showPassword,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  suffixIcon: IconButton(
                    icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _showPassword = !_showPassword),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Password is required';
                  if (value.length < 8) return 'Password too short';
                  return null;
                },
              ),
              const SizedBox(height: 6),

              // Confirm Password
              const Text(
                'Confirm Password',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'DM Sans'),
              ),
              const SizedBox(height: 3),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_showConfirmPassword,
                decoration: InputDecoration(
                  hintText: 'Enter confirm password',
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  suffixIcon: IconButton(
                    icon: Icon(_showConfirmPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Confirm your password';
                  if (value != _passwordController.text) return 'Passwords do not match';
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Optional Section
              const Text(
                'Optional:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),

              // Level Dropdown
              LevelDropdown(
                selected: _level,
                onChanged: (val) => setState(() => _level = val),
              ),
              const SizedBox(height: 6),

              // Gender Selector
              GenderSelector(
                selected: _gender,
                onChanged: (val) => setState(() => _gender = val),
              ),
              const SizedBox(height: 15),

              // Sign Up Button
              GestureDetector(
                onTap: _submit,
                child: Container(
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFC23435),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 17),

              // Navigate to Login
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/login'),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(color: Colors.black54),
                      children: [
                        TextSpan(
                          text: 'Log in',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
