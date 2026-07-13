import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../repositories/database_helper.dart';

class UserState {
  final List<User> users;
  final bool isLoading;
  final String? error;

  final String? fullNameError;
  final String? emailError;
  final String? avatarError;
  final String fullName;
  final String email;
  final String avatar;

  final User? editingUser;

  UserState({
    this.users = const [],
    this.isLoading = false,
    this.error,
    this.fullNameError,
    this.emailError,
    this.avatarError,
    this.fullName = '',
    this.email = '',
    this.avatar = '',
    this.editingUser,
  });

  UserState copyWith({
    List<User>? users,
    bool? isLoading,
    String? Function()? error,
    String? Function()? fullNameError,
    String? Function()? emailError,
    String? Function()? avatarError,
    String? fullName,
    String? email,
    String? avatar,
    User? editingUser,
    bool clearEditingUser = false,
  }) {
    return UserState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      error: error != null ? error() : this.error,
      fullNameError: fullNameError != null
          ? fullNameError()
          : this.fullNameError,
      emailError: emailError != null ? emailError() : this.emailError,
      avatarError: avatarError != null ? avatarError() : this.avatarError,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      editingUser: clearEditingUser ? null : (editingUser ?? this.editingUser),
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  UserNotifier() : super(UserState()) {
    loadUsers();
  }

  final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  Future<void> loadUsers() async {
    state = state.copyWith(isLoading: true);
    try {
      final users = await _dbHelper.getUsers();
      state = state.copyWith(users: users, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: () => e.toString(), isLoading: false);
    }
  }

  void updateFullName(String value) {
    String? error;
    if (value.trim().isEmpty) {
      error = 'Họ và tên không được để trống';
    } else if (value.trim().length < 2) {
      error = 'Họ và tên phải có tối thiểu 2 ký tự';
    }
    state = state.copyWith(fullName: value, fullNameError: () => error);
  }

  void updateEmail(String value) {
    String? error;
    if (value.trim().isEmpty) {
      error = 'Email không được để trống';
    } else if (!_emailRegExp.hasMatch(value.trim())) {
      error = 'Email không đúng định dạng (vd: abc@gmail.com)';
    }
    state = state.copyWith(email: value, emailError: () => error);
  }

  void updateAvatar(String value) {
    String? error;
    if (value.trim().isEmpty) {
      error = 'Vui lòng chọn ảnh đại diện';
    }
    state = state.copyWith(avatar: value, avatarError: () => error);
  }

  void setEditingUser(User user) {
    state = state.copyWith(
      editingUser: user,
      fullName: user.fullName,
      email: user.email,
      avatar: user.avatar,
      fullNameError: () => null,
      emailError: () => null,
      avatarError: () => null,
    );
  }

  void clearForm() {
    state = state.copyWith(
      fullName: '',
      email: '',
      avatar: '',
      fullNameError: () => null,
      emailError: () => null,
      avatarError: () => null,
      clearEditingUser: true,
    );
  }

  bool validateAll() {
    updateFullName(state.fullName);
    updateEmail(state.email);
    updateAvatar(state.avatar);

    return state.fullNameError == null &&
        state.emailError == null &&
        state.avatarError == null;
  }

  Future<bool> submitForm() async {
    if (!validateAll()) return false;

    state = state.copyWith(isLoading: true);
    try {
      if (state.editingUser == null) {
        final newUser = User(
          fullName: state.fullName.trim(),
          email: state.email.trim(),
          avatar: state.avatar,
        );
        await _dbHelper.insertUser(newUser);
      } else {
        final updatedUser = state.editingUser!.copyWith(
          fullName: state.fullName.trim(),
          email: state.email.trim(),
          avatar: state.avatar,
        );
        await _dbHelper.updateUser(updatedUser);
      }
      clearForm();
      await loadUsers();
      return true;
    } catch (e) {
      state = state.copyWith(error: () => e.toString(), isLoading: false);
      return false;
    }
  }

  Future<void> deleteUser(int id) async {
    state = state.copyWith(isLoading: true);
    try {
      await _dbHelper.deleteUser(id);
      if (state.editingUser?.id == id) {
        clearForm();
      }
      await loadUsers();
    } catch (e) {
      state = state.copyWith(error: () => e.toString(), isLoading: false);
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
