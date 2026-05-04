# English Learning App

Ứng dụng Flutter phục vụ bài tập nhóm: thiết kế layout thống nhất cho 3 màn hình **Home**, **Content**, **About** và xây dựng **Navigation Bar** ở cuối mỗi trang.

## 1. Thông tin dự án

- Tên ứng dụng: English Learning App
- Chủ đề: Quản lý học viên học tiếng Anh
- Công nghệ: Flutter, Dart, Material Design 3
- Màu chủ đạo: xanh lá nhạt
- Font chữ: sử dụng font mặc định của Flutter/Material, kích thước và độ đậm thống nhất trong toàn bộ app

## 2. Mockup screen

![Mockup screen](mockup_screen.png)

Thiết kế tổng quát của mỗi màn hình:

```text
+--------------------------------+
| Header / Banner                |
| Tên màn hình + mô tả ngắn       |
+--------------------------------+
| Content                        |
| Dữ liệu, danh sách, chức năng   |
+--------------------------------+
| Footer / Thông tin bổ sung      |
+--------------------------------+
| Home | Content | About          |
+--------------------------------+
```

Ba màn hình chính:

1. **Home**: giới thiệu ứng dụng và hiển thị thống kê nhanh.
2. **Content**: hiển thị Generics Data, dữ liệu học viên và chức năng CRUD.
3. **About**: giới thiệu ứng dụng, công nghệ sử dụng và mô tả cấu trúc layout.

Mockup nhóm đã thiết kế:

```text
Home Mockup    | Content Mockup              | About Mockup
Header/Banner  | Header/Banner               | Header/Banner
Content        | Generics Data               | App Info
Footer/Card    | CRUD & Students List        | Mockup Layout
NavigationBar  | NavigationBar               | NavigationBar
```

## 3. Chức năng chính

- Hiển thị dữ liệu học viên bằng `List`, `Map`, `List<Map<String, String>>`.
- Xây dựng `GenericsClass<T>` để minh họa sử dụng Generics trong Dart.
- Xây dựng class `Student` để biểu diễn đối tượng học viên.
- Xây dựng class `ListStudent` để quản lý danh sách học viên.
- Thực hiện các thao tác CRUD:
  - Create: thêm học viên mới.
  - Read: đọc danh sách học viên.
  - Edit: chỉnh sửa thông tin học viên.
  - Delete: xóa học viên.
- Sử dụng `NavigationBar` để chuyển giữa 3 màn hình: Home, Content, About.

## 4. Cấu trúc code chính

```text
lib/
├── main.dart          # Layout chính, Home/Content/About, Navigation Bar
├── student.dart       # Class Student
└── list_student.dart  # Class ListStudent và các hàm CRUD
```

## 5. Code chính phần Layout

Phần layout chính nằm trong file `main.dart`, class `MainLayout`.

Các widget quan trọng:

- `headerBanner()`: tạo banner đầu trang cho từng màn hình.
- `appCard()`: tạo khung nội dung thống nhất.
- `buildHomePage()`: layout màn hình Home.
- `buildContentPage()`: layout màn hình Content.
- `buildAboutPage()`: layout màn hình About.
- `buildStudentCard()`: hiển thị thông tin từng học viên.

## 6. Code chính phần Navigation Bar

```dart
bottomNavigationBar: NavigationBar(
  selectedIndex: currentIndex,
  onDestinationSelected: (index) {
    setState(() {
      currentIndex = index;
    });
  },
  destinations: const [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.article_outlined),
      selectedIcon: Icon(Icons.article),
      label: 'Content',
    ),
    NavigationDestination(
      icon: Icon(Icons.info_outline),
      selectedIcon: Icon(Icons.info),
      label: 'About',
    ),
  ],
),
```



##  Link Github

Repo nhóm:

```text
https://github.com/VoThuan02052005/Ung_dunghoctienganh_Thuan_Vu_1_2026/tree/vu
```

Link README sau khi push:

```text
https://github.com/VoThuan02052005/Ung_dunghoctienganh_Thuan_Vu_1_2026/blob/vu/README.md
```

-----------------------------------------------------------------------------------------------------------------------------------------------------------
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
