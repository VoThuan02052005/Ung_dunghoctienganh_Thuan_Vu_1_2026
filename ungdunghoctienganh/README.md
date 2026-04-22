# Câu 1: Static là gì? Cách sử dụng, ưu điểm và nhược điểm

## 1. Static là gì?

Trong Dart, `static` là từ khóa dùng để khai báo biến hoặc phương thức thuộc về **class** thay vì thuộc về từng **đối tượng** được tạo từ class đó. Điều này có nghĩa là thành phần được khai báo `static` sẽ được dùng chung cho toàn bộ class và có thể được truy cập trực tiếp thông qua tên class mà không cần khởi tạo object.

Nói đơn giản, nếu một thuộc tính hay phương thức mang tính chất dùng chung, không phụ thuộc vào từng đối tượng riêng lẻ, thì có thể sử dụng `static`. Ví dụ, tên ứng dụng, cấu hình chung, hoặc một hàm tiện ích tính toán thường là những trường hợp phù hợp.

## 2. Cách sử dụng static

`static` thường được dùng cho hai loại chính: biến tĩnh và phương thức tĩnh.

- **Biến static** dùng để lưu dữ liệu chung cho toàn bộ class.
- **Phương thức static** dùng để thực hiện các chức năng chung mà không cần tạo đối tượng.

Khi sử dụng, ta gọi trực tiếp bằng tên class. Đây là điểm khác biệt lớn nhất so với thành viên thông thường, vì thành viên thường phải thông qua object mới truy cập được.

## 3. Ưu điểm của static

Ưu điểm đầu tiên là giúp chương trình **gọn hơn**, vì không cần tạo đối tượng để sử dụng. Ưu điểm thứ hai là phù hợp với các dữ liệu hoặc chức năng mang tính **dùng chung**, từ đó giảm lặp lại và giúp tổ chức mã nguồn rõ ràng hơn. Ngoài ra, `static` còn giúp tiết kiệm thao tác khởi tạo object trong các trường hợp không cần thiết.

Trong thực tế, `static` đặc biệt hữu ích với các lớp hỗ trợ như lớp cấu hình, lớp kiểm tra dữ liệu, lớp tính toán hoặc các giá trị cố định của hệ thống.

## 4. Nhược điểm của static

Bên cạnh ưu điểm, `static` cũng có hạn chế. Trước hết, nó **không phù hợp với dữ liệu riêng** của từng đối tượng. Nếu lạm dụng `static`, chương trình sẽ giảm tính hướng đối tượng và khó mở rộng hơn về sau. Ngoài ra, vì dữ liệu static được dùng chung, nếu thay đổi không cẩn thận thì có thể ảnh hưởng đến nhiều phần khác trong chương trình.

## 5. Kết luận

Tóm lại, `static` là công cụ rất hữu ích khi cần quản lý dữ liệu hoặc chức năng dùng chung ở cấp class. Nó giúp mã nguồn ngắn gọn, dễ dùng và rõ ràng hơn. Tuy nhiên, cần sử dụng đúng chỗ, vì nếu dùng sai hoặc lạm dụng sẽ làm mất đi tính linh hoạt của lập trình hướng đối tượng.
