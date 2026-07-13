# AGENT.md - Tài liệu ghi nhận các thay đổi thực hiện dự án User Manager

Dưới đây là chi tiết các thay đổi đã được thực hiện để hoàn thành các yêu cầu trong [README.md](file:///d:/SUMMER2026/PRM/pe_he190134/README.md).

---

## 1. Yêu cầu chung & kỹ thuật

- **MVVM Architecture & Riverpod**: Cấu trúc lại thư mục dự án theo mô hình MVVM (Model - View - ViewModel) và sử dụng Riverpod làm trình quản lý trạng thái.
- **SQLite**: Tích hợp cơ sở dữ liệu SQLite cục bộ phục vụ cho việc lưu trữ thông tin người dùng với cơ chế tự động cấu hình FFI trên môi trường desktop (Windows).
- **CRUD Operations**: Xử lý đầy đủ chức năng Thêm (Create), Đọc (Read), Cập nhật (Update), và Xóa (Delete) người dùng.
- **Navigation**: Điều hướng chuyển đổi mượt mà giữa màn hình chính (`HomeScreen`) và màn hình chi tiết (`UserDetailScreen`).
- **Dialog xác nhận xóa**: Xây dựng hộp thoại xác nhận trước khi tiến hành xóa người dùng khỏi cơ sở dữ liệu.
- **Responsive UI**: Tự động thay đổi giao diện theo kích thước và hướng của thiết bị:
  - **Phone Portrait (Dọc)**: Hiển thị 1 cột dọc (Form nhập liệu ở trên, danh sách người dùng cuộn ở dưới).
  - **Phone Landscape (Ngang)**: Hiển thị 2 cột ngang (Form bên trái, Danh sách người dùng bên phải).
  - **Tablet**: Hiển thị 2 cột (Form bên trái, Danh sách người dùng bên phải hiển thị dạng Grid 2 cột tuyệt đẹp).

---

## 2. Chi tiết các file thay đổi và tạo mới

### A. Cấu hình dự án
- **[MODIFY] [pubspec.yaml](file:///d:/SUMMER2026/PRM/pe_he190134/pubspec.yaml)**:
  - Đăng ký thư mục `assets/` dưới mục `flutter: assets` để cho phép ứng dụng truy cập tệp hình ảnh ảnh đại diện `assets/default_avatar.jpg`.

### B. Lớp dữ liệu (Model)
- **[NEW] [user.dart](file:///d:/SUMMER2026/PRM/pe_he190134/lib/models/user.dart)**:
  - Tạo lớp `User` chứa các thuộc tính: `id` (int?, tự tăng), `fullName` (String), `email` (String), và `avatar` (String).
  - Cung cấp các phương thức `toMap()` và `fromMap()` giúp ánh xạ dữ liệu trực tiếp từ SQLite.

### C. Quản lý Cơ sở dữ liệu (Service)
- **[NEW] [database_helper.dart](file:///d:/SUMMER2026/PRM/pe_he190134/lib/services/database_helper.dart)**:
  - Quản lý vòng đời và kết nối cơ sở dữ liệu SQLite thông qua cơ chế Singleton.
  - Tích hợp hàm `sqfliteFfiInit()` và `databaseFactoryFfi` giúp cơ sở dữ liệu chạy mượt mà ngay trên Windows Desktop.
  - Định nghĩa cấu trúc bảng dữ liệu `users` và các phương thức CRUD (`insertUser`, `getUsers`, `updateUser`, `deleteUser`).

### D. Bộ điều khiển trạng thái & Kiểm tra dữ liệu (ViewModel)
- **[NEW] [user_notifier.dart](file:///d:/SUMMER2026/PRM/pe_he190134/lib/viewmodels/user_notifier.dart)**:
  - Tạo lớp `UserNotifier` kế thừa `StateNotifier` quản lý trạng thái biểu mẫu (form fields, errors) và danh sách người dùng.
  - **Quy tắc Validate**:
    - `fullName`: Không được để trống, độ dài tối thiểu 2 ký tự.
    - `email`: Bắt buộc nhập, kiểm tra định dạng email chuẩn qua biểu thức chính quy (Regex).
    - `avatar`: Bắt buộc chọn.
  - Thực hiện các logic tương tác nghiệp vụ như lưu chỉnh sửa, thêm mới hoặc xóa.

### E. Giao diện (View)
- **[NEW] [responsive_layout.dart](file:///d:/SUMMER2026/PRM/pe_he190134/lib/views/responsive_layout.dart)**:
  - Cung cấp Widget hỗ trợ phân tích độ rộng màn hình thực tế và chọn bố cục tương ứng cho điện thoại (dọc/ngang) và máy tính bảng.
- **[NEW] [user_form.dart](file:///d:/SUMMER2026/PRM/pe_he190134/lib/views/widgets/user_form.dart)**:
  - Thiết kế biểu mẫu nhập thông tin. Hiển thị thông báo lỗi trực quan màu đỏ ngay dưới mỗi ô nhập khi dữ liệu không hợp lệ.
  - Tích hợp chức năng chọn Avatar thông qua Modal Bottom Sheet hiển thị danh sách ảnh có trong thư mục `assets`.
  - Thay đổi nút hành động linh hoạt giữa `ADD USER` (Thêm) và `EDIT USER` (Sửa) khi kích hoạt chế độ chỉnh sửa.
- **[NEW] [user_item.dart](file:///d:/SUMMER2026/PRM/pe_he190134/lib/views/widgets/user_item.dart)**:
  - Hiển thị từng dòng thông tin người dùng chứa avatar tròn nhỏ, Họ tên, Email, nút chỉnh sửa (icon cây bút) và nút xóa (icon thùng rác màu đỏ).
  - Tích hợp hộp thoại cảnh báo `AlertDialog` xác nhận xóa bằng tiếng Việt: "Bạn có chắc chắn muốn xóa người dùng...".
  - Cho phép chạm vào bất cứ vùng trống nào trên item để xem chi tiết.
- **[NEW] [home_screen.dart](file:///d:/SUMMER2026/PRM/pe_he190134/lib/views/home_screen.dart)**:
  - Màn hình chính điều phối biểu mẫu nhập liệu và danh sách người dùng dựa vào `ResponsiveLayout`.
  - Tích hợp nút `+` góc phải thanh ứng dụng giúp đặt lại biểu mẫu (clear form) để thêm người dùng mới khi đang ở chế độ chỉnh sửa.
- **[NEW] [user_detail_screen.dart](file:///d:/SUMMER2026/PRM/pe_he190134/lib/views/user_detail_screen.dart)**:
  - Màn hình chi tiết người dùng chứa avatar tròn lớn ở chính giữa và các thông tin chi tiết: ID, Họ tên, Email căn lề trái như hình thiết kế mockup `image_1.png`.
- **[MODIFY] [main.dart](file:///d:/SUMMER2026/PRM/pe_he190134/lib/main.dart)**:
  - Khởi tạo ứng dụng Flutter và bọc toàn bộ bằng `ProviderScope` để khởi chạy Riverpod. Điều hướng màn hình mặc định về `HomeScreen()`.

### F. Kiểm thử
- **[MODIFY] [widget_test.dart](file:///d:/SUMMER2026/PRM/pe_he190134/test/widget_test.dart)**:
  - Cập nhật bài kiểm thử giao diện để đảm bảo ứng dụng tải đúng màn hình `HomeScreen` và không gặp bất kỳ lỗi logic nào.

---

## 3. Nhật ký sửa lỗi (Bug Fixes)

- **Sửa lỗi copyWith không xóa được các thông báo lỗi (Error Messages)**: 
  - *Vấn đề*: Trong lớp `UserState`, phương thức `copyWith` trước đó sử dụng biểu thức `fullNameError ?? this.fullNameError`. Khi các trường đã nhập đúng và lỗi trở về `null`, lệnh `state.copyWith(fullNameError: null)` sẽ giữ nguyên lỗi cũ do toán tử `??` bỏ qua giá trị `null` được truyền vào.
  - *Giải pháp*: Cập nhật tham số của phương thức `copyWith` nhận các hàm callback dạng `String? Function()?` để phân biệt rõ ràng giữa việc "không cập nhật" và "cập nhật giá trị thành null". Thay đổi toàn bộ các hàm cập nhật trạng thái tương ứng trong `UserNotifier` để sửa lỗi này triệt để. Nút `ADD USER` / `EDIT USER` hiện hoạt động hoàn toàn chính xác.

- **Sửa lỗi không xóa giá trị trong các ô nhập liệu sau khi thêm mới thành công**:
  - *Vấn đề*: Khi thêm người dùng thành công, biểu mẫu gọi `clearForm()` đặt các giá trị trong `UserState` về `''` (rỗng). Tuy nhiên, hàm `ref.listen` trong `UserForm` chỉ lắng nghe khi trạng thái `editingUser` thay đổi. Vì khi thêm người dùng mới, `editingUser` luôn là `null` trước và sau khi lưu, sự kiện thay đổi này không kích hoạt nên `TextEditingController` không được dọn dẹp.
  - *Giải pháp*: Bổ sung thêm điều kiện trong hàm `ref.listen` để kiểm tra khi dữ liệu nhập trong State đã được đặt lại về rỗng (`next.fullName.isEmpty && next.email.isEmpty && next.editingUser == null`), nếu đúng sẽ tiến hành gọi `.clear()` trên các `TextEditingController` để làm rỗng ô nhập liệu trên giao diện.
