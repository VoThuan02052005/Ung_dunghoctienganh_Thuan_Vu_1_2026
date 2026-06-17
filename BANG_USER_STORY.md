# BẢNG USER STORY (CÂU CHUYỆN NGƯỜI DÙNG) — ENGLISHMASTER

**Dự án:** EnglishMaster — Ứng dụng học tiếng Anh  
**Người thực hiện:** Thuan Vu  
**Môn học:** Lập trình ứng dụng di động  
**Trường:** Đại học Phenikaa | **Ngày:** 15/06/2026

---

## BẢNG 10 USER STORY

| STT | Mã US | Vai trò | Câu chuyện người dùng | Tiêu chí chấp nhận (Acceptance Criteria) | Ưu tiên | Story Point |
|-----|-------|---------|----------------------|------------------------------------------|---------|-------------|
| 1 | US_01 | Người học mới | **Là** một người học mới, **tôi muốn** đăng nhập vào ứng dụng bằng tên và mật khẩu, **để** truy cập nội dung học tập một cách bảo mật. | - Màn hình Login có 2 trường: Tên và Mật khẩu<br>- Hiển thị lỗi nếu để trống hoặc tên < 2 ký tự<br>- Đăng nhập thành công chuyển sang Dashboard<br>- Không vào được Dashboard khi chưa đăng nhập | Cao | 3 |
| 2 | US_02 | Người học | **Là** một người học, **tôi muốn** xem tổng quan tiến độ học tập trên trang chủ, **để** biết mình đã học được bao nhiêu và cần học thêm gì hôm nay. | - Hiển thị số từ đã học, Streak (ngày liên tiếp), điểm XP<br>- Có "Mục tiêu hôm nay" với thanh tiến trình<br>- Có danh sách bài học gợi ý<br>- Dữ liệu cập nhật sau mỗi phiên học | Cao | 5 |
| 3 | US_03 | Người học | **Là** một người học, **tôi muốn** duyệt danh sách bài học theo chủ đề và cấp độ, **để** chọn bài học phù hợp với trình độ của mình. | - Hiển thị lưới bài học dạng card: emoji, tiêu đề, cấp độ, % tiến trình<br>- Chip lọc: Tất cả / Beginner / Intermediate / Advanced<br>- Nhấn card mở màn hình Chi tiết bài học<br>- Lọc chính xác theo cấp độ đã chọn | Cao | 3 |
| 4 | US_04 | Người học | **Là** một người học, **tôi muốn** học từ vựng qua thẻ Flashcard có thể lật, **để** ghi nhớ nghĩa, phát âm và ví dụ một cách trực quan. | - Mặt trước: từ tiếng Anh + phiên âm IPA<br>- Nhấn thẻ: lật hiển thị nghĩa tiếng Việt có animation<br>- Hiển thị ví dụ câu bên dưới<br>- Nút yêu thích để lưu từ quan trọng | Cao | 5 |
| 5 | US_05 | Người học | **Là** một người học, **tôi muốn** đánh dấu từ vựng là "Đã học", **để** theo dõi từ đã nắm vững và phân biệt với từ chưa học. | - Nút "Đánh dấu đã học" ở màn hình chi tiết từ vựng<br>- Sau khi nhấn: đổi màu xanh lá, hiện "Đã học ✓"<br>- Icon trong danh sách cập nhật trạng thái (✅ / ○)<br>- Nhấn lại để bỏ đánh dấu (toggle) | Trung bình | 2 |
| 6 | US_06 | Người học | **Là** một người học, **tôi muốn** làm bài kiểm tra trắc nghiệm (Quiz), **để** củng cố kiến thức và biết mình đã nhớ được bao nhiêu từ. | - Mỗi câu có 4 đáp án A/B/C/D<br>- Phản hồi tức thì: đúng nền xanh (✓), sai nền đỏ (✗)<br>- Thanh tiến trình hiển thị câu hiện tại / tổng số câu<br>- Nút "Câu tiếp theo" chỉ hiện sau khi chọn đáp án | Cao | 8 |
| 7 | US_07 | Người học | **Là** một người học, **tôi muốn** xem kết quả sau khi hoàn thành Quiz, **để** biết điểm số, phần trăm chính xác và XP nhận được. | - Hiển thị: điểm X/Y câu, % chính xác<br>- Emoji thành tích: 🏆 (>=80%) / 🌟 (>=60%) / 💪 (<60%)<br>- Hiển thị số XP kiếm được<br>- Nút "Làm lại" để thực hiện quiz từ đầu | Trung bình | 3 |
| 8 | US_08 | Người học | **Là** một người học, **tôi muốn** xem hồ sơ cá nhân với biểu đồ kỹ năng, **để** nhận biết điểm mạnh và điểm yếu trong quá trình học. | - Hồ sơ hiển thị: avatar, tên, vai trò<br>- 3 chỉ số: Tổng từ / Ngày Streak / Điểm XP<br>- Biểu đồ tiến trình 4 kỹ năng: Listening / Speaking / Reading / Writing<br>- Hiển thị phần trăm từng kỹ năng | Trung bình | 5 |
| 9 | US_09 | Người học | **Là** một người học, **tôi muốn** chuyển đổi giữa chế độ Sáng và Tối (Dark Mode), **để** học thoải mái trong mọi điều kiện ánh sáng. | - Mục "Giao diện" trong Cài đặt hiển thị chế độ hiện tại<br>- Nhấn vào chuyển chế độ ngay lập tức toàn app<br>- Icon thay đổi theo chế độ: sáng (☀️) / tối (🌙)<br>- Tất cả màn hình hỗ trợ cả 2 chế độ | Thấp | 3 |
| 10 | US_10 | Người học | **Là** một người học, **tôi muốn** đăng xuất khỏi tài khoản an toàn, **để** bảo vệ dữ liệu cá nhân khi dùng thiết bị chung. | - Nút "Đăng xuất" màu đỏ ở cuối phần Cài đặt<br>- Nhấn vào: xóa session, chuyển về màn hình Login<br>- Không thể nhấn Back quay lại Dashboard sau đăng xuất<br>- Màn hình Login trống, không lưu thông tin phiên cũ | Cao | 2 |

---

## THỐNG KÊ

| Mức ưu tiên | Số lượng | Tổng Story Point |
|-------------|----------|-----------------|
| Cao (High) | 6 | 21 |
| Trung bình (Medium) | 3 | 10 |
| Thấp (Low) | 1 | 3 |
| **Tổng cộng** | **10** | **34** |

### Phân loại theo Module

| Module | User Story |
|--------|-----------|
| Xác thực | US_01, US_10 |
| Trang chủ | US_02 |
| Bài học & Từ vựng | US_03, US_04, US_05 |
| Quiz | US_06, US_07 |
| Hồ sơ & Cài đặt | US_08, US_09 |

> **Định dạng chuẩn:** "As a [vai trò], I want [mong muốn], So that [lợi ích]"  
> **Story Point:** 1-2 = Đơn giản | 3-5 = Trung bình | 8 = Phức tạp
