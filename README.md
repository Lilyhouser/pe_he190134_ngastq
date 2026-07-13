viết cho tôi 1 app flutter có đủ các yêu cầu sau:

1. Yêu cầu chung & kỹ thuật
   ✅ MVVM
   ✅ Riverpod
   ✅ SQLite
   ✅ CRUD
   ✅ Navigation
   ✅ Dialog xác nhận xóa
   ✅ UI đẹp, Material 3, có responsive (hiển thị tốt trên cả Phone - hiển thị 1 cột dọc, 2 cột ngang - và Tablet - hiển thị 2 cột dạng grid/list)

2. Cấu trúc dữ liệu và quy tắc kiểm tra (Validate)

✅ - Tạo lớp Uẻ chứa các thuộc tính sau. Yêu cầu hiển thị thông báo lỗi rõ ràng dưới từng trường nhập liệu khi dữ liệu không hợp lệ

✅ * id (int): khóa chính, tự động tăng
✅ * fullName (string): không được để trống, tối thiểu 2 ký tự
✅ * email (string): bắt buộc nhập, phải đúng định dạng email (vd: abc@gmail.com)
✅ * avatar (string): bắt buộc có, chọn từ ảnh trong template project cung cấp (folder assets)

3. Chức năng và giao diện
   Ứng dụng bao gồm 2 màn hình chính với các chức năng tương ứng:
   A. Màn hình Danh sách (Home Screen)

✅ - Phần nhập liệu (phía trên): gồm các ô nhập Họ tên, Email, Avatar và nút Add. Khi thêm thành công, danh sách bên dưới phải được cập nhật ngay lập tức
✅ - Phần hiển thị (phía dưới): Danh sách người dùng

✅ * giao diện item: Gồm avatar nhỏ, Họ tên, Email và 2 nút hành động là Edit (icon bút) và delete (icon thùng rác)
✅ * tương tác: Chạm vào phần nội dung của Item để chuyển sang màn hình Chi tiết

✅ - Chức năng tương tác:

✅ * sửa: nhấn nút edit trên Item thì hiển thị thông tin người dùng lên các widget phía trên và sửa Add user thành Edit user, chỉnh sửa thông tin, nhấn Update user lưu lại và danh sách phải tự động cập nhật
✅ * Xóa: nhấn nút Delete, hiển thị hộp thoại xác nhận trước khi tiến hành xóa khỏi cơ sở dữ liệu và giao diện
✅ * Khi người dùng nhấn vào Item thì chuyển sang màn User Detail
