import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/user_notifier.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/user_form.dart';
import '../widgets/user_item.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userProvider);
    final users = state.users;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'User Manager',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 28),
            onPressed: () {
              ref.read(userProvider.notifier).clearForm();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Form đã được đặt lại để thêm người dùng mới'),
                  duration: Duration(milliseconds: 700),
                ),
              );
            },
            tooltip: 'Thêm mới (Đặt lại form)',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ResponsiveLayout(
        mobilePortrait: users.isEmpty
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    const UserForm(),
                    const Divider(
                      height: 24,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    _buildEmptyState(),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: users.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const UserForm();
                  } else if (index == 1) {
                    return const Divider(
                      height: 24,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                    );
                  }
                  final user = users[index - 2];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: UserItem(user: user),
                  );
                },
              ),

        mobileLandscape: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: const SingleChildScrollView(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
                child: UserForm(),
              ),
            ),
            const VerticalDivider(
              width: 16,
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
            Expanded(
              flex: 6,
              child: users.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        bottom: 8.0,
                        right: 8.0,
                      ),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return UserItem(user: users[index]);
                      },
                    ),
            ),
          ],
        ),

        tablet: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 360,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: UserForm(),
              ),
            ),
            const VerticalDivider(
              width: 1,
              thickness: 1,
              indent: 24,
              endIndent: 24,
            ),
            Expanded(
              child: users.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3.5,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Card(
                          color: Colors.white,
                          elevation: 1,
                          shadowColor: Colors.black12,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade100),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: UserItem(user: user),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group_outlined, size: 72, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'Chưa có người dùng nào',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Vui lòng nhập thông tin phía trên để thêm người dùng mới.',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
