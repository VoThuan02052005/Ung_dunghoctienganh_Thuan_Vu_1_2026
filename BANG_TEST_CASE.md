# BẢNG KIỂM THỬ (TEST CASE) — ỨNG DỤNG ENGLISHMASTER

**Dự án:** EnglishMaster — Ứng dụng học tiếng Anh  
**Người thực hiện:** Thuan Vu  
**Môn học:** Lập trình ứng dụng di động  
**Trường:** Đại học Phenikaa  
**Ngày kiểm thử:** 15/06/2026  
**Phiên bản:** 1.0.0  

---

## BẢNG 18 TEST CASE

| STT | Mã TC | Tên chức năng | Mô tả | Điều kiện tiên quyết | Bước thực hiện | Dữ liệu đầu vào | Kết quả mong đợi | Trạng thái |
|-----|-------|---------------|-------|----------------------|----------------|-----------------|------------------|------------|
| 1 | TC_01 | Đăng nhập thành công | Kiểm tra đăng nhập với thông tin hợp lệ | App đang ở màn hình Login | 1. Mở app / 2. Nhập tên / 3. Nhập mật khẩu / 4. Nhấn "Đăng nhập" | Tên: `Thuan Vu` / Mật khẩu: `123456` | Chuyển sang Dashboard thành công | ✅ PASS |
| 2 | TC_02 | Đăng nhập — Bỏ trống tên | Kiểm tra validation khi để trống tên | App ở màn hình Login | 1. Để trống tên / 2. Nhập mật khẩu / 3. Nhấn "Đăng nhập" | Tên: *(trống)* / Mật khẩu: `abc123` | Hiển thị lỗi: "Vui lòng nhập tên của bạn" | ✅ PASS |
| 3 | TC_03 | Đăng nhập — Tên quá ngắn | Kiểm tra validation tên < 2 ký tự | App ở màn hình Login | 1. Nhập 1 ký tự / 2. Nhập mật khẩu / 3. Nhấn "Đăng nhập" | Tên: `A` / Mật khẩu: `123456` | Hiển thị lỗi: "Tên phải có ít nhất 2 ký tự" | ✅ PASS |
| 4 | TC_04 | Hiển thị Dashboard | Kiểm tra màn hình Trang chủ đủ thông tin sau đăng nhập | Đã đăng nhập (TC_01) | 1. Đăng nhập thành công / 2. Quan sát Dashboard | — | Hiển thị: tên user, Streak 7 ngày, 240 XP, 42 từ đã học, mục tiêu hôm nay, danh sách bài học | ✅ PASS |
| 5 | TC_05 | Xem danh sách bài học | Kiểm tra tab Bài học hiển thị lưới và bộ lọc | Đã đăng nhập, ở màn hình chính | 1. Nhấn tab "Bài học" / 2. Quan sát giao diện | — | Hiển thị lưới bài học, 4 chip lọc: Tất cả / Beginner / Intermediate / Advanced | ✅ PASS |
| 6 | TC_06 | Lọc bài học theo cấp độ | Kiểm tra chip lọc Beginner | Đang ở tab Bài học | 1. Nhấn chip "Beginner" / 2. Quan sát kết quả | Cấp độ: `Beginner` | Chỉ hiển thị bài học level Beginner, các cấp khác bị ẩn | ✅ PASS |
| 7 | TC_07 | Mở chi tiết bài học | Kiểm tra điều hướng sang màn hình Chi tiết | Đang ở tab Bài học | 1. Nhấn vào một bài học bất kỳ / 2. Quan sát màn hình mới | — | Mở màn hình Chi tiết: emoji, tiêu đề, số từ, 2 tab "Từ vựng" & "Thông tin", nút "Bắt đầu học" | ✅ PASS |
| 8 | TC_08 | Xem danh sách từ vựng | Kiểm tra tab Từ vựng trong Chi tiết bài học | Đang ở màn hình Chi tiết bài học | 1. Chọn tab "Từ vựng" / 2. Quan sát danh sách | — | Danh sách từ có: STT, từ tiếng Anh, phát âm IPA, nghĩa tiếng Việt, icon trạng thái đã học | ✅ PASS |
| 9 | TC_09 | Lật Flashcard xem nghĩa | Kiểm tra animation lật thẻ từ vựng | Đang ở màn hình Chi tiết từ vựng | 1. Nhấn vào thẻ Flashcard / 2. Quan sát hiệu ứng | — | Thẻ lật, đổi màu gradient (tím → xanh lá), hiển thị nghĩa tiếng Việt. Nhấn lại để lật về | ✅ PASS |
| 10 | TC_10 | Đánh dấu từ vựng đã học | Kiểm tra nút toggle "Đánh dấu đã học" | Đang ở màn hình Chi tiết từ vựng | 1. Nhấn nút "Đánh dấu đã học" / 2. Kiểm tra trạng thái nút | — | Nút đổi thành "Đã học ✓" màu xanh lá. Nhấn lần 2 để bỏ đánh dấu | ✅ PASS |
| 11 | TC_11 | Yêu thích từ vựng | Kiểm tra icon yêu thích (trái tim) | Đang ở màn hình Chi tiết từ vựng | 1. Nhấn icon trái tim trên AppBar / 2. Quan sát thay đổi | — | Icon chuyển từ `favorite_border` → `favorite` (đỏ). Nhấn lại để bỏ yêu thích | ✅ PASS |
| 12 | TC_12 | Làm bài Quiz đầy đủ | Kiểm tra toàn bộ luồng làm quiz | Đang ở màn hình chính, đã đăng nhập | 1. Nhấn tab "Quiz" / 2. Chọn đáp án / 3. Nhấn tiếp theo đến hết | — | Mỗi câu: 4 đáp án A/B/C/D; sau chọn: đúng nền xanh (✓), sai nền đỏ (✗); thanh tiến trình cập nhật | ✅ PASS |
| 13 | TC_13 | Xem kết quả Quiz | Kiểm tra màn hình kết quả sau khi hoàn thành | Đã làm hết câu hỏi (TC_12) | 1. Nhấn "Xem kết quả" / 2. Quan sát màn hình kết quả | — | Hiển thị: emoji thành tích, điểm số, % chính xác, XP nhận được, nút "Làm lại" | ✅ PASS |
| 14 | TC_14 | Xem hồ sơ cá nhân | Kiểm tra tab Hồ sơ hiển thị đúng | Đang ở màn hình chính | 1. Nhấn tab "Hồ sơ" / 2. Quan sát thông tin | — | Hiển thị: avatar, tên, vai trò, 3 chỉ số (từ/ngày/XP), biểu đồ 4 kỹ năng (Listening/Speaking/Reading/Writing) | ✅ PASS |
| 15 | TC_15 | Dialog Thông tin cá nhân | Kiểm tra dialog chi tiết thông tin người dùng | Đang ở tab Hồ sơ | 1. Nhấn "Thông tin cá nhân" trong Cài đặt / 2. Quan sát dialog | — | Dialog hiển thị: avatar, Họ tên, Email, Vai trò, Ngày tham gia. Có nút "Đóng" để thoát | ✅ PASS |
| 16 | TC_16 | Bật/Tắt Dark Mode | Kiểm tra chuyển đổi giao diện Tối/Sáng toàn ứng dụng | Đang ở tab Hồ sơ, đang ở Light Mode | 1. Nhấn "Giao diện: Sáng" / 2. Quan sát giao diện / 3. Nhấn lại để về Sáng | — | Toàn bộ app chuyển sang nền tối ngay lập tức, icon đổi thành 🌙. Nhấn lại → Light Mode 🔆 | ✅ PASS |
| 17 | TC_17 | Cài đặt Thông báo | Kiểm tra dialog cài đặt nhắc nhở học tập | Đang ở tab Hồ sơ | 1. Nhấn "Thông báo" / 2. Bật/tắt Switch / 3. Nhấn "Lưu" | — | Dialog hiển thị Switch "Nhắc nhở hàng ngày"; toggle hoạt động được; nút "Lưu" đóng dialog | ✅ PASS |
| 18 | TC_18 | Đăng xuất | Kiểm tra chức năng thoát tài khoản và về màn hình Login | Đang ở tab Hồ sơ, đã đăng nhập | 1. Nhấn "Đăng xuất" (màu đỏ) / 2. Quan sát điều hướng | — | App xóa session, điều hướng về màn hình Đăng nhập. Không thể nhấn Back để quay lại | ✅ PASS |

---

## TỔNG KẾT

| Chỉ số | Giá trị |
|--------|---------|
| **Tổng số Test Case** | 18 |
| **Số TC PASS** | 18 |
| **Số TC FAIL** | 0 |
| **Tỷ lệ PASS** | **100%** |

### Phân loại theo Module

| Module | Số TC | PASS | FAIL |
|--------|-------|------|------|
| Xác thực (Authentication) | 3 | 3 | 0 |
| Trang chủ (Dashboard) | 1 | 1 | 0 |
| Bài học & Chi tiết | 3 | 3 | 0 |
| Học từ vựng (Flashcard) | 3 | 3 | 0 |
| Kiểm tra (Quiz) | 2 | 2 | 0 |
| Hồ sơ & Cài đặt | 4 | 4 | 0 |
| Đăng xuất | 1 | 1 | 0 |
| **Tổng cộng** | **18** | **18** | **0** |

> **Ghi chú:** Kiểm thử thực hiện trên **Flutter Web (Chrome 148)** và **Flutter Linux Desktop**.  
> Toàn bộ chức năng hoạt động đúng theo đặc tả thiết kế.
