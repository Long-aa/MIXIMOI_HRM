# 🏢 MIXIMOI HRM & PAYROLL

<div align="center">

![Java](https://img.shields.io/badge/Java-17-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![JSP](https://img.shields.io/badge/JSP-Servlet-007396?style=for-the-badge&logo=java&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Bootstrap](https://img.shields.io/badge/Bootstrap-5-7952B3?style=for-the-badge&logo=bootstrap&logoColor=white)
![Tomcat](https://img.shields.io/badge/Apache_Tomcat-10-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=black)
![Maven](https://img.shields.io/badge/Maven-C71A36?style=for-the-badge&logo=apachemaven&logoColor=white)
![Status](https://img.shields.io/badge/Status-In_Development-orange?style=for-the-badge)

**Ứng dụng web quản lý nhân sự và tiền lương cho Công ty MixiMoi**

*Xây dựng bằng Java JSP + Servlet + JDBC + PostgreSQL theo kiến trúc MVC + DAO + Service*

</div>

---

## 📌 Mục lục

- [Giới thiệu](#-giới-thiệu)
- [Mục tiêu dự án](#-mục-tiêu-dự-án)
- [Đối tượng sử dụng](#-đối-tượng-sử-dụng)
- [Công nghệ sử dụng](#️-công-nghệ-sử-dụng)
- [Kiến trúc hệ thống](#️-kiến-trúc-hệ-thống)
- [Luồng hoạt động tổng thể](#-luồng-hoạt-động-tổng-thể)
- [Các module chức năng](#-các-module-chức-năng)
- [Thiết kế cơ sở dữ liệu](#️-thiết-kế-cơ-sở-dữ-liệu)
- [Cấu trúc project](#-cấu-trúc-project)
- [Cài đặt và chạy dự án](#-cài-đặt-và-chạy-dự-án)
- [Bảo mật](#️-bảo-mật)
- [Testing](#-testing)
- [Roadmap](#-roadmap)
- [Git Branch Convention](#-git-branch-convention)
- [Định hướng phát triển](#-định-hướng-phát-triển)
- [Kiến thức áp dụng](#-kiến-thức-áp-dụng)
- [Trạng thái dự án](#-trạng-thái-dự-án)
- [License](#-license)

---

## 🌟 Giới thiệu

**MIXIMOI HRM & PAYROLL** là hệ thống web hỗ trợ Công ty MixiMoi quản lý tập trung các nghiệp vụ nhân sự và tiền lương.

Hệ thống được xây dựng nhằm **số hóa** các công việc thường gặp của bộ phận Nhân sự (HR), Kế toán, Quản lý và Nhân viên, hạn chế việc quản lý thủ công bằng Excel và giúp dữ liệu nhân sự – chấm công – tiền lương được **liên kết chặt chẽ** với nhau.

### Các nghiệp vụ chính

| STT | Nghiệp vụ |
|-----|-----------|
| 01 | Quản lý nhân viên |
| 02 | Quản lý phòng ban |
| 03 | Quản lý chức vụ |
| 04 | Quản lý loại nhân viên |
| 05 | Quản lý hợp đồng lao động |
| 06 | Quản lý ca làm việc |
| 07 | Quản lý chấm công |
| 08 | Quản lý nghỉ phép |
| 09 | Quản lý tăng ca |
| 10 | Quản lý lương cơ bản |
| 11 | Quản lý phụ cấp |
| 12 | Quản lý thưởng |
| 13 | Quản lý khấu trừ |
| 14 | Tính lương |
| 15 | Quản lý bảng lương |
| 16 | Thanh toán lương |
| 17 | Phiếu lương |
| 18 | Báo cáo và thống kê |
| 19 | Quản lý tài khoản và phân quyền |
| 20 | Thông báo |
| 21 | Nhật ký hoạt động (Audit Log) |

---

## 🎯 Mục tiêu dự án

- ✅ Quản lý **tập trung** thông tin nhân sự
- ✅ Hỗ trợ quản lý phòng ban và chức vụ
- ✅ Theo dõi quá trình làm việc của nhân viên
- ✅ Quản lý chấm công và thời gian làm việc
- ✅ Quản lý nghỉ phép và tăng ca
- ✅ **Tự động hóa** quy trình tính lương
- ✅ Quản lý phụ cấp, thưởng và các khoản khấu trừ
- ✅ Hỗ trợ lập bảng lương hàng tháng
- ✅ Theo dõi quá trình thanh toán lương
- ✅ Cho phép nhân viên xem phiếu lương cá nhân
- ✅ Cung cấp báo cáo và thống kê cho nhà quản lý
- ✅ Phân quyền người dùng theo chức năng
- ✅ Giao diện đơn giản, trực quan và dễ sử dụng

---

## 👥 Đối tượng sử dụng

| Vai trò | Quyền sử dụng |
|---------|---------------|
| **Admin** | Quản trị toàn bộ hệ thống |
| **HR** | Quản lý nhân sự, hợp đồng, chấm công, nghỉ phép |
| **Kế toán** | Quản lý bảng lương, tính lương, thanh toán |
| **Manager** | Theo dõi nhân sự và phê duyệt nghiệp vụ |
| **Employee** | Xem thông tin cá nhân, chấm công, nghỉ phép, phiếu lương |

---

## 🛠️ Công nghệ sử dụng

| Công nghệ | Phiên bản | Vai trò |
|-----------|-----------|---------|
| **Java** | 17 | Ngôn ngữ lập trình chính |
| **JSP** | — | Xây dựng giao diện (View) |
| **Servlet** | Jakarta EE | Controller, xử lý Request/Response |
| **JDBC** | — | Kết nối và thao tác Database |
| **PostgreSQL** | 15+ | Hệ quản trị cơ sở dữ liệu |
| **HTML5** | — | Cấu trúc trang web |
| **CSS3** | — | Thiết kế giao diện |
| **JavaScript** | ES6+ | Tương tác phía client |
| **Bootstrap** | 5 | Responsive UI |
| **Apache Tomcat** | 10+ | Web / Servlet Container |
| **Maven** | 3+ | Quản lý dependency và build |
| **JUnit** | 5 | Unit Test |
| **Git / GitHub** | — | Quản lý mã nguồn |

> ⚠️ **Lưu ý quan trọng:** Project **không sử dụng** Spring Boot, Spring MVC, Spring Data JPA, Hibernate hoặc Thymeleaf.
> Việc truy cập PostgreSQL được thực hiện **trực tiếp** thông qua JDBC.

---

## 🏗️ Kiến trúc hệ thống

Project sử dụng mô hình **MVC + DAO + Service**:

```
┌─────────────────────────────┐
│            JSP              │
│            VIEW             │
│   HTML / CSS / JavaScript   │
└──────────────┬──────────────┘
               │ HTTP Request
               ▼
┌─────────────────────────────┐
│          SERVLET            │
│         CONTROLLER          │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│          SERVICE            │
│       BUSINESS LOGIC        │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│            DAO              │
│     DATABASE OPERATIONS     │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│            JDBC             │
│ Connection / PreparedStmt   │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│         PostgreSQL          │
└─────────────────────────────┘
```

### Nguyên tắc phân tầng

| Tầng | Trách nhiệm |
|------|-------------|
| **JSP** | Hiển thị giao diện — **không** truy vấn Database trực tiếp |
| **Servlet** | Nhận Request, điều hướng, trả Response |
| **Service** | Xử lý nghiệp vụ (Business Logic) |
| **DAO** | Thực thi SQL thông qua JDBC |
| **PostgreSQL** | Lưu trữ toàn bộ dữ liệu |

---

## 🔄 Luồng hoạt động tổng thể

```
                  ┌──────────────┐
                  │   ĐĂNG NHẬP  │
                  └──────┬───────┘
                         ↓
                  ┌──────────────┐
                  │ XÁC THỰC TK │
                  └──────┬───────┘
                         ↓
                  ┌──────────────┐
                  │  PHÂN QUYỀN  │
                  └──────┬───────┘
                         ↓
                  ┌──────────────┐
                  │  DASHBOARD   │
                  └──────┬───────┘
                         │
     ┌───────────────────┼───────────────────┐
     ↓                   ↓                   ↓
┌──────────┐       ┌──────────┐        ┌──────────┐
│  NHÂN SỰ │       │ CHẤM CÔNG│        │ NGHỈ PHÉP│
└────┬─────┘       └────┬─────┘        └────┬─────┘
     └───────────────────┴───────────────────┘
                         ↓
                  ┌──────────────┐
                  │  TÍNH LƯƠNG  │
                  └──────┬───────┘
                         ↓
                  ┌──────────────┐
                  │  BẢNG LƯƠNG  │
                  └──────┬───────┘
                         ↓
                  ┌──────────────┐
                  │   PHÊ DUYỆT  │
                  └──────┬───────┘
                         ↓
                  ┌──────────────┐
                  │  THANH TOÁN  │
                  └──────┬───────┘
                         ↓
                  ┌──────────────┐
                  │  PHIẾU LƯƠNG │
                  └──────┬───────┘
                         ↓
                  ┌──────────────┐
                  │   BÁO CÁO   │
                  └──────────────┘
```

---

## 📂 Các module chức năng

### 👤 Module quản lý nhân sự

#### 1. Quản lý nhân viên

| Chức năng | Mô tả |
|-----------|-------|
| Thêm nhân viên | Tạo hồ sơ nhân viên mới |
| Sửa thông tin | Cập nhật thông tin nhân viên |
| Xóa nhân viên | Xóa hoặc vô hiệu hóa hồ sơ |
| Xem chi tiết | Xem toàn bộ thông tin nhân viên |
| Tìm kiếm & Lọc | Tìm theo tên, mã, phòng ban, trạng thái |
| Lịch sử công tác | Theo dõi lịch sử làm việc |

**Thông tin nhân viên:**

| Trường | Mô tả |
|--------|-------|
| Mã nhân viên | Mã định danh duy nhất |
| Họ tên | Tên đầy đủ |
| Ngày sinh | Ngày / tháng / năm sinh |
| Giới tính | Nam / Nữ / Khác |
| Số điện thoại | Liên hệ |
| Email | Email nội bộ |
| Địa chỉ | Địa chỉ thường trú |
| Phòng ban | Đơn vị công tác |
| Chức vụ | Vị trí trong tổ chức |
| Loại nhân viên | Chính thức / Thử việc / Thời vụ... |
| Ngày vào làm | Ngày bắt đầu công tác |
| Trạng thái | Đang làm / Nghỉ việc / Tạm nghỉ |

#### 2. Quản lý phòng ban

Chức năng: Thêm, sửa, xóa phòng ban; Xem danh sách nhân viên theo phòng ban; Thống kê số lượng nhân viên.

**Ví dụ phòng ban:**

| Phòng ban |
|-----------|
| Ban Giám đốc |
| Phòng Nhân sự |
| Phòng Kế toán |
| Phòng Kinh doanh |
| Phòng Marketing |
| Phòng Kỹ thuật |

#### 3. Quản lý chức vụ

Chức năng: Thêm, sửa, xóa chức vụ; Gắn chức vụ cho nhân viên.

#### 4. Quản lý loại nhân viên

| Loại | Mô tả |
|------|-------|
| Nhân viên chính thức | Hợp đồng không xác định thời hạn |
| Nhân viên thử việc | Trong thời gian thử việc |
| Nhân viên thời vụ | Hợp đồng ngắn hạn theo mùa |
| Cộng tác viên | Làm việc theo hợp đồng dịch vụ |

---

### 📄 Module hợp đồng lao động

| Thông tin | Mô tả |
|-----------|-------|
| Mã hợp đồng | Mã định danh hợp đồng |
| Nhân viên | Người ký hợp đồng |
| Loại hợp đồng | Xác định / Không xác định thời hạn |
| Ngày bắt đầu | Ngày hiệu lực |
| Ngày kết thúc | Ngày hết hạn (nếu có) |
| Mức lương | Mức lương ghi trong hợp đồng |
| Trạng thái | Đang hiệu lực / Sắp hết hạn / Đã hết hạn / Đã thanh lý |
| Ghi chú | Thông tin bổ sung |

> ⚠️ **Cảnh báo tự động:** Hệ thống thông báo khi hợp đồng sắp hết hạn.
> *Ví dụ:* `⚠ Hợp đồng NV001 sẽ hết hạn sau 15 ngày.`

---

### ⏰ Module chấm công

#### Ca làm việc

| Ca | Thông tin lưu trữ |
|----|------------------|
| Ca sáng | Tên ca, giờ bắt đầu, giờ kết thúc, số giờ tiêu chuẩn |
| Ca chiều | Tên ca, giờ bắt đầu, giờ kết thúc, số giờ tiêu chuẩn |
| Ca tối | Tên ca, giờ bắt đầu, giờ kết thúc, số giờ tiêu chuẩn |
| Ca linh hoạt | Tên ca, giờ bắt đầu, giờ kết thúc, số giờ tiêu chuẩn |

#### Chấm công hàng ngày

| Thông tin | Mô tả |
|-----------|-------|
| Nhân viên | Người chấm công |
| Ngày | Ngày làm việc |
| Giờ vào | Thời điểm bắt đầu |
| Giờ ra | Thời điểm kết thúc |
| Tổng giờ | Số giờ làm thực tế |
| Trạng thái | Đúng giờ / Đi muộn / Về sớm / Nghỉ / Tăng ca |
| Ghi chú | Lý do / Giải thích |

---

### 🏖️ Module nghỉ phép

**Luồng xử lý đơn nghỉ phép:**

```
Nhân viên tạo đơn
       ↓
Chọn loại nghỉ + ngày nghỉ + lý do
       ↓
Gửi đơn lên hệ thống
       ↓
Quản lý/HR kiểm tra
       ↓
  Duyệt / Từ chối
       ↓
Cập nhật bảng công
```

**Trạng thái đơn nghỉ phép:**

```
Chờ duyệt → Đã duyệt
          → Từ chối
          → Đã hủy
```

---

### ⏱️ Module tăng ca (Overtime)

| Thông tin | Mô tả |
|-----------|-------|
| Nhân viên | Người tăng ca |
| Ngày tăng ca | Ngày thực hiện |
| Số giờ | Tổng giờ tăng ca |
| Hệ số tăng ca | 1.5x / 2x / 3x (theo quy định) |
| Tiền tăng ca | Tính theo hệ số và lương cơ bản |
| Trạng thái | Chờ duyệt / Đã duyệt / Từ chối |

**Luồng xử lý:**

```
Nhân viên / Manager tạo yêu cầu
       ↓
Phê duyệt
       ↓
Ghi nhận tăng ca
       ↓
Tính tiền OT
       ↓
Đưa vào bảng lương
```

---

### 💰 Module tiền lương

#### Công thức tính lương thực nhận

```
  Lương cơ bản
+ Phụ cấp
+ Thưởng
+ Tiền tăng ca (OT)
- Khấu trừ (BHXH, BHYT, BHTN, Thuế TNCN, ...)
- Các khoản giảm trừ khác
──────────────────────────
= LƯƠNG THỰC NHẬN
```

#### Các thành phần lương

**Lương cơ bản:** Quản lý mức lương, ngày áp dụng, lịch sử thay đổi.

**Phụ cấp:**

| Loại phụ cấp |
|-------------|
| Phụ cấp ăn trưa |
| Phụ cấp xăng xe |
| Phụ cấp điện thoại |
| Phụ cấp chức vụ |
| Phụ cấp khác |

**Thưởng:**

| Loại thưởng |
|------------|
| Thưởng hiệu suất |
| Thưởng doanh số |
| Thưởng ngày lễ |
| Thưởng Tết |
| Thưởng khác |

**Khấu trừ:**

| Loại khấu trừ | Ghi chú |
|--------------|---------|
| Bảo hiểm xã hội (BHXH) | Theo quy định nhà nước |
| Bảo hiểm y tế (BHYT) | Theo quy định nhà nước |
| Bảo hiểm thất nghiệp (BHTN) | Theo quy định nhà nước |
| Thuế thu nhập cá nhân (TNCN) | Theo biểu thuế lũy tiến |
| Khấu trừ khác | Theo quy định công ty |

> 📌 Công thức và tỷ lệ cụ thể được **cấu hình linh hoạt** theo quy định nghiệp vụ — không hard-code trong JSP.

---

### 🧮 Quy trình tính lương

```
KỲ LƯƠNG
    ↓
Tổng hợp danh sách nhân viên trong kỳ
    ↓
Tổng hợp bảng công (ngày công thực tế)
    ↓
Cộng tiền tăng ca (OT)
    ↓
Cộng phụ cấp
    ↓
Cộng thưởng
    ↓
Trừ các khoản khấu trừ
    ↓
TÍNH LƯƠNG THỰC NHẬN
    ↓
KIỂM TRA & SOÁT XÉT
    ↓
PHÊ DUYỆT (Manager / Admin)
    ↓
THANH TOÁN
    ↓
PHIẾU LƯƠNG
```

---

### 🧾 Module bảng lương

| Thành phần | Nội dung |
|-----------|---------|
| Nhân viên | Người nhận lương |
| Kỳ lương | Tháng / Năm |
| Lương cơ bản | Mức lương hợp đồng |
| Ngày công | Số ngày làm thực tế |
| Tăng ca | Tiền OT |
| Phụ cấp | Tổng phụ cấp |
| Thưởng | Tổng thưởng |
| Khấu trừ | Tổng khấu trừ |
| Thực nhận | Lương cuối cùng |
| Trạng thái | Trạng thái xử lý |

**Vòng đời trạng thái bảng lương:**

```
NHÁP → CHỜ DUYỆT → ĐÃ DUYỆT → ĐANG THANH TOÁN → ĐÃ THANH TOÁN
```

---

### 💳 Module thanh toán

| Thông tin | Mô tả |
|-----------|-------|
| Mã thanh toán | Mã định danh giao dịch |
| Mã bảng lương | Tham chiếu tới bảng lương |
| Nhân viên | Người nhận thanh toán |
| Số tiền | Giá trị thanh toán |
| Ngày thanh toán | Ngày thực hiện |
| Phương thức | Chuyển khoản / Tiền mặt |
| Trạng thái | Đang xử lý / Đã thanh toán |
| Ghi chú | Thông tin bổ sung |

---

### 🧾 Module phiếu lương

Nhân viên có thể xem phiếu lương với đầy đủ thông tin:

```
┌────────────────────────────────────────┐
│        PHIẾU LƯƠNG THÁNG XX/XXXX       │
├────────────────────────────────────────┤
│ Nhân viên  : [Họ tên]   Mã: [NV-XXX]  │
│ Phòng ban  : [Tên phòng ban]           │
│ Chức vụ   : [Tên chức vụ]             │
├────────────────────────────────────────┤
│ Lương cơ bản          :   XX.XXX.XXX  │
│ Ngày công             :      XX ngày   │
│ Tiền tăng ca (OT)     :    X.XXX.XXX  │
│ Phụ cấp               :    X.XXX.XXX  │
│ Thưởng                :    X.XXX.XXX  │
├────────────────────────────────────────┤
│ Khấu trừ BHXH         :   -X.XXX.XXX  │
│ Khấu trừ BHYT         :     -XXX.XXX  │
│ Khấu trừ BHTN         :     -XXX.XXX  │
│ Thuế TNCN             :   -X.XXX.XXX  │
├────────────────────────────────────────┤
│ LƯƠNG THỰC NHẬN       :  XX.XXX.XXX đ │
└────────────────────────────────────────┘
```

> 📌 Có thể mở rộng: **In phiếu lương · Xuất PDF · Gửi email**

---

### 📊 Module báo cáo & thống kê

#### Báo cáo nhân sự
- Danh sách toàn bộ nhân viên
- Nhân viên theo phòng ban / chức vụ
- Nhân viên mới trong kỳ
- Nhân viên nghỉ việc

#### Báo cáo chấm công
- Bảng công tháng
- Danh sách đi muộn / về sớm
- Thống kê nghỉ phép
- Thống kê tăng ca

#### Báo cáo lương
- Tổng quỹ lương toàn công ty
- Lương theo phòng ban
- Chi phí lương theo tháng / quý / năm
- Tổng thưởng / Tổng phụ cấp / Tổng khấu trừ
- Tổng tiền đã thanh toán

> 📌 Hỗ trợ xuất: **Excel · PDF · Print**

---

### 📈 Dashboard

Giao diện tổng quan cung cấp thông tin nhanh cho nhà quản lý:

| Chỉ số | Mô tả |
|--------|-------|
| Tổng nhân viên | Số lượng nhân viên đang làm việc |
| Nhân viên mới | Nhân viên gia nhập trong tháng |
| Quỹ lương | Tổng chi phí lương kỳ gần nhất |
| Đơn nghỉ phép chờ duyệt | Số đơn cần xử lý |

**Biểu đồ trực quan:**
- 🍕 Nhân viên theo phòng ban (Pie Chart)
- 📊 Nhân viên theo trạng thái (Bar Chart)
- 💰 Quỹ lương theo phòng ban (Bar Chart)
- 📈 Chi phí lương theo tháng (Line Chart)

---

## 🔐 Đăng nhập & phân quyền

### Các role trong hệ thống

| Role | Chức năng truy cập |
|------|-------------------|
| **ADMIN** | Toàn quyền hệ thống, quản lý tài khoản, xem audit log |
| **HR** | Nhân viên, phòng ban, chức vụ, hợp đồng, chấm công, nghỉ phép |
| **ACCOUNTANT** | Tính lương, bảng lương, thanh toán, báo cáo lương |
| **MANAGER** | Theo dõi nhân viên, duyệt nghỉ phép, duyệt tăng ca, xem báo cáo |
| **EMPLOYEE** | Thông tin cá nhân, chấm công, nghỉ phép, tăng ca, phiếu lương, thông báo |

### Servlet Mapping

```
/login          → Đăng nhập
/logout         → Đăng xuất
/employees      → Quản lý nhân viên
/departments    → Quản lý phòng ban
/positions      → Quản lý chức vụ
/contracts      → Quản lý hợp đồng
/attendance     → Quản lý chấm công
/leave          → Quản lý nghỉ phép
/overtime       → Quản lý tăng ca
/payroll        → Quản lý bảng lương
/payment        → Quản lý thanh toán
/reports        → Báo cáo & thống kê
```

---

## 🔔 Thông báo

Hệ thống hiển thị thông báo tự động:

| Loại thông báo | Đối tượng nhận |
|----------------|----------------|
| Đơn nghỉ phép mới | Manager / HR |
| Đơn nghỉ phép được duyệt / từ chối | Nhân viên |
| Hợp đồng sắp hết hạn | HR / Admin |
| Bảng lương đã được duyệt | Kế toán / Nhân viên |
| Kỳ lương mới được tạo | Kế toán |
| Thông báo chung từ HR | Toàn bộ nhân viên |

---

## 📝 Audit Log

Ghi lại toàn bộ thao tác quan trọng trên hệ thống:

| Trường | Mô tả |
|--------|-------|
| Người thực hiện | Tài khoản đã đăng nhập |
| Hành động | CREATE / UPDATE / DELETE / APPROVE / REJECT... |
| Đối tượng | Module / Bảng bị tác động |
| Thời gian | Timestamp chính xác |
| Nội dung | Mô tả chi tiết thao tác |

**Ví dụ:**

```
[08/09/2026 08:30]  ADMIN    → Thêm nhân viên NV025
[08/09/2026 09:15]  HR       → Cập nhật thông tin nhân viên NV015
[08/09/2026 10:20]  MANAGER  → Duyệt đơn nghỉ phép LP001
```

---

## 🗄️ Thiết kế cơ sở dữ liệu

### Tạo Database PostgreSQL

```sql
CREATE DATABASE miximoi_hrm;
```

### Danh sách các bảng

| Nhóm | Bảng |
|------|------|
| **Tài khoản & Phân quyền** | `users`, `roles` |
| **Nhân sự** | `employees`, `departments`, `positions`, `employee_types` |
| **Hợp đồng** | `contracts` |
| **Chấm công** | `work_shifts`, `attendance` |
| **Nghỉ phép & Tăng ca** | `leave_requests`, `overtime` |
| **Cấu hình lương** | `salary_configs`, `allowances`, `bonuses`, `deductions` |
| **Bảng lương** | `payroll`, `payroll_details` |
| **Thanh toán** | `payments` |
| **Hệ thống** | `notifications`, `audit_logs` |

### Quan hệ nghiệp vụ

```
DEPARTMENT ──┬── EMPLOYEE ──── POSITION
             │       │
             │       ├── CONTRACT
             │       ├── ATTENDANCE
             │       ├── LEAVE_REQUEST
             │       ├── OVERTIME
             │       └── PAYROLL ──── PAYROLL_DETAILS
             │                              │
             │                           PAYMENT
             └── (thống kê nhân viên theo phòng ban)
```

---

## 📁 Cấu trúc project

```
miximoi-hrm/
│
├── src/
│   └── main/
│       ├── java/
│       │   └── com/miximoi/hrm/
│       │       │
│       │       ├── controller/           # Servlet — Controller Layer
│       │       │   ├── LoginServlet.java
│       │       │   ├── LogoutServlet.java
│       │       │   ├── EmployeeServlet.java
│       │       │   ├── DepartmentServlet.java
│       │       │   ├── PositionServlet.java
│       │       │   ├── ContractServlet.java
│       │       │   ├── AttendanceServlet.java
│       │       │   ├── LeaveServlet.java
│       │       │   ├── OvertimeServlet.java
│       │       │   ├── PayrollServlet.java
│       │       │   ├── PaymentServlet.java
│       │       │   └── ReportServlet.java
│       │       │
│       │       ├── dao/                  # Data Access Object Layer
│       │       │   ├── UserDAO.java
│       │       │   ├── EmployeeDAO.java
│       │       │   ├── DepartmentDAO.java
│       │       │   ├── PositionDAO.java
│       │       │   ├── ContractDAO.java
│       │       │   ├── AttendanceDAO.java
│       │       │   ├── LeaveDAO.java
│       │       │   ├── OvertimeDAO.java
│       │       │   ├── PayrollDAO.java
│       │       │   └── PaymentDAO.java
│       │       │
│       │       ├── model/                # Entity / POJO
│       │       │   ├── User.java
│       │       │   ├── Employee.java
│       │       │   ├── Department.java
│       │       │   ├── Position.java
│       │       │   ├── Contract.java
│       │       │   ├── Attendance.java
│       │       │   ├── LeaveRequest.java
│       │       │   ├── Overtime.java
│       │       │   └── Payroll.java
│       │       │
│       │       ├── service/              # Business Logic Layer
│       │       │   ├── EmployeeService.java
│       │       │   ├── AttendanceService.java
│       │       │   ├── LeaveService.java
│       │       │   └── PayrollService.java
│       │       │
│       │       └── util/                 # Tiện ích dùng chung
│       │           ├── DBConnection.java
│       │           ├── PasswordUtil.java
│       │           └── ValidationUtil.java
│       │
│       └── webapp/                       # Tài nguyên Web
│           ├── index.jsp
│           ├── login.jsp
│           ├── css/                      # Stylesheet
│           ├── js/                       # JavaScript
│           ├── images/                   # Hình ảnh
│           ├── dashboard/                # JSP Dashboard
│           ├── employee/                 # JSP Nhân viên
│           ├── department/               # JSP Phòng ban
│           ├── position/                 # JSP Chức vụ
│           ├── contract/                 # JSP Hợp đồng
│           ├── attendance/               # JSP Chấm công
│           ├── leave/                    # JSP Nghỉ phé
│           ├── payroll/                  # JSP Bảng lươngp
│           ├── overtime/                 # JSP Tăng ca
│           ├── payment/                  # JSP Thanh toán
│           ├── report/                   # JSP Báo cáo
│           └── admin/                    # JSP Quản trị
│
├── database/
│   ├── schema.sql                        # DDL tạo bảng
│   └── sample-data.sql                   # Dữ liệu mẫu
│
├── docs/
│   ├── use-case.md
│   ├── database-design.md
│   └── system-design.md
│
├── pom.xml                               # Maven dependencies
├── .gitignore
└── README.md
```

---

## 🚀 Cài đặt và chạy dự án

### Yêu cầu môi trường

| Phần mềm | Phiên bản |
|----------|----------|
| JDK | 17+ |
| Maven | 3.8+ |
| PostgreSQL | 13+ |
| Apache Tomcat | 10+ |
| IDE | NetBeans / IntelliJ IDEA / Eclipse |
| Git | 2.x+ |

### Bước 1 — Clone project

```bash
git clone <repository-url>
cd miximoi-hrm
```

### Bước 2 — Tạo Database

```sql
CREATE DATABASE miximoi_hrm;
```

Chạy script tạo bảng và dữ liệu mẫu:

```bash
psql -U postgres -d miximoi_hrm -f database/schema.sql
psql -U postgres -d miximoi_hrm -f database/sample-data.sql
```

### Bước 3 — Cấu hình kết nối JDBC

Mở file `src/main/java/com/miximoi/hrm/util/DBConnection.java` và cập nhật:

```java
package com.miximoi.hrm.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
        "jdbc:postgresql://localhost:5432/miximoi_hrm";

    private static final String USER = "postgres";

    private static final String PASSWORD = "your_password"; // Thay mật khẩu thực

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
```

> 🔒 **Bảo mật:** Không commit mật khẩu Database thật lên GitHub!

### Bước 4 — Cấu hình pom.xml

```xml
<!-- PostgreSQL JDBC Driver -->
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <version>42.7.4</version>
</dependency>

<!-- Jakarta Servlet API — dành cho Tomcat 10+ -->
<dependency>
    <groupId>jakarta.servlet</groupId>
    <artifactId>jakarta.servlet-api</artifactId>
    <version>6.0.0</version>
    <scope>provided</scope>
</dependency>

<!-- JSTL -->
<dependency>
    <groupId>jakarta.servlet.jsp.jstl</groupId>
    <artifactId>jakarta.servlet.jsp.jstl-api</artifactId>
    <version>3.0.0</version>
</dependency>
```

> ⚠️ **Lưu ý phiên bản Tomcat:**
> - **Tomcat 10+** → dùng `jakarta.servlet.*`
> - **Tomcat 9** → dùng `javax.servlet.*`
>
> **Không trộn lẫn** `javax.servlet` và `jakarta.servlet` trong cùng một project!

### Bước 5 — Build project

```bash
mvn clean package
```

### Bước 6 — Deploy và chạy

Deploy file `target/miximoi-hrm.war` vào thư mục `webapps/` của Apache Tomcat, sau đó truy cập:

```
http://localhost:8080/miximoi-hrm/
```

---

## 🛡️ Bảo mật

| Biện pháp | Mô tả |
|-----------|-------|
| Xác thực đăng nhập | Kiểm tra username / password |
| Quản lý Session | Phiên làm việc có thời hạn |
| Phân quyền theo role | Kiểm tra quyền tại mỗi Servlet |
| Hash mật khẩu | BCrypt / SHA-256 — không lưu plaintext |
| PreparedStatement | Chống SQL Injection |
| Validate phía server | Kiểm tra và làm sạch dữ liệu đầu vào |
| Audit Log | Ghi lại toàn bộ thao tác quan trọng |
| Không commit credential | Password DB không đưa lên GitHub |

**Ví dụ sử dụng PreparedStatement:**

```java
String sql = "SELECT * FROM employees WHERE employee_code = ?";
PreparedStatement ps = connection.prepareStatement(sql);
ps.setString(1, employeeCode);
ResultSet rs = ps.executeQuery();
```

**Ví dụ kiểm tra phân quyền trong Servlet:**

```java
@WebServlet("/employees")
public class EmployeeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        // Xử lý lấy danh sách nhân viên...
    }
}
```

---

## 🧪 Testing

Sử dụng **JUnit 5** để kiểm thử các nghiệp vụ chính:

### Authentication

| Test Case | Kỳ vọng |
|-----------|---------|
| Đăng nhập đúng thông tin | Đăng nhập thành công, tạo session |
| Sai username | Trả về lỗi "Tài khoản không tồn tại" |
| Sai password | Trả về lỗi "Mật khẩu không đúng" |
| Đăng xuất | Hủy session thành công |
| Truy cập khi chưa đăng nhập | Redirect về trang login |

### Employee

| Test Case | Kỳ vọng |
|-----------|---------|
| Thêm nhân viên hợp lệ | Lưu vào DB thành công |
| Sửa thông tin nhân viên | Cập nhật DB thành công |
| Xóa nhân viên | Xóa hoặc vô hiệu hóa thành công |
| Tìm kiếm theo mã / tên | Trả về đúng kết quả |
| Validate dữ liệu đầu vào | Báo lỗi khi thiếu trường bắt buộc |

### Attendance

| Test Case | Kỳ vọng |
|-----------|---------|
| Ghi nhận chấm công | Lưu giờ vào / giờ ra |
| Tính tổng giờ làm | Kết quả chính xác |
| Phát hiện đi muộn | Đánh dấu trạng thái đúng |
| Phát hiện về sớm | Đánh dấu trạng thái đúng |

### Payroll

| Test Case | Kỳ vọng |
|-----------|---------|
| Tính lương cơ bản theo ngày công | Kết quả chính xác |
| Tính tiền tăng ca (OT) | Đúng hệ số nhân |
| Cộng phụ cấp | Tổng phụ cấp đúng |
| Cộng thưởng | Tổng thưởng đúng |
| Tính khấu trừ BHXH / BHYT / TNCN | Đúng tỷ lệ |
| Tính lương thực nhận | Kết quả cuối đúng |

---

## 📋 Roadmap

### Phase 1 — Cơ sở hạ tầng
- [ ] Tạo Maven Web Project
- [ ] Cấu hình Apache Tomcat
- [ ] Cấu hình kết nối PostgreSQL
- [ ] Xây dựng DBConnection (JDBC)
- [ ] Thiết kế & tạo Database Schema
- [ ] Module đăng nhập / đăng xuất
- [ ] Quản lý Session & Phân quyền theo role

### Phase 2 — Quản lý nhân sự
- [ ] CRUD Nhân viên
- [ ] CRUD Phòng ban
- [ ] CRUD Chức vụ
- [ ] CRUD Loại nhân viên
- [ ] Quản lý Hợp đồng lao động
- [ ] Cảnh báo hợp đồng sắp hết hạn

### Phase 3 — Chấm công
- [ ] Quản lý Ca làm việc
- [ ] Chấm công hàng ngày
- [ ] Bảng công tháng
- [ ] Quản lý Nghỉ phép (CRUD + phê duyệt)
- [ ] Quản lý Tăng ca (CRUD + phê duyệt)

### Phase 4 — Tiền lương
- [ ] Cấu hình Lương cơ bản
- [ ] Quản lý Phụ cấp
- [ ] Quản lý Thưởng
- [ ] Quản lý Khấu trừ
- [ ] Module Tính lương tự động
- [ ] Quản lý Bảng lương
- [ ] Phiếu lương cá nhân
- [ ] Module Thanh toán

### Phase 5 — Báo cáo & Dashboard
- [ ] Dashboard tổng quan (biểu đồ)
- [ ] Báo cáo nhân sự
- [ ] Báo cáo chấm công
- [ ] Báo cáo tiền lương
- [ ] Xuất Excel
- [ ] Xuất PDF

### Phase 6 — Mở rộng
- [ ] Module Thông báo
- [ ] Nhật ký Audit Log
- [ ] QR Code chấm công
- [ ] Gửi email tự động
- [ ] KPI & Đánh giá hiệu suất
- [ ] Quản lý tuyển dụng
- [ ] Quản lý đào tạo & onboarding

---

## 🌿 Git Branch Convention

### Cấu trúc nhánh đề xuất

```
main
└── develop
    ├── feature/login
    ├── feature/employee
    ├── feature/department
    ├── feature/attendance
    ├── feature/leave
    ├── feature/overtime
    ├── feature/payroll
    ├── feature/payment
    └── feature/report
```

### Quy tắc đặt tên commit

| Prefix | Ý nghĩa |
|--------|---------|
| `feat:` | Thêm tính năng mới |
| `fix:` | Sửa lỗi |
| `style:` | Chỉnh sửa giao diện, CSS |
| `refactor:` | Cải thiện cấu trúc code (không đổi tính năng) |
| `test:` | Thêm hoặc sửa unit test |
| `docs:` | Cập nhật tài liệu |
| `chore:` | Cấu hình, build, dependency |

**Ví dụ commit message:**

```bash
git commit -m "feat: add employee management CRUD"
git commit -m "feat: implement payroll calculation logic"
git commit -m "feat: add leave request approval flow"
git commit -m "fix: fix attendance time calculation bug"
git commit -m "refactor: improve EmployeeDAO query performance"
git commit -m "test: add unit tests for PayrollService"
git commit -m "docs: update README with installation guide"
git commit -m "style: update dashboard UI layout"
```

---

## 🌱 Định hướng phát triển

### QR Code chấm công

```
Nhân viên quét QR Code
       ↓
Xác thực danh tính
       ↓
Ghi nhận thời gian vào / ra
       ↓
Cập nhật bảng công tự động
```

### Email Notification tự động

| Sự kiện | Email gửi tới |
|---------|--------------|
| Đơn nghỉ phép được duyệt / từ chối | Nhân viên |
| Phiếu lương tháng mới | Nhân viên |
| Hợp đồng sắp hết hạn | HR / Admin |
| Thông báo từ ban quản lý | Toàn bộ nhân viên |

### Responsive Design

Tối ưu giao diện cho mọi thiết bị:
- 🖥️ Desktop
- 💻 Laptop
- 📱 Tablet
- 📱 Mobile

---

## 📚 Kiến thức áp dụng

| Nhóm | Kiến thức |
|------|-----------|
| **Ngôn ngữ** | Java 17, HTML5, CSS3, JavaScript ES6+ |
| **Java Web** | JSP, Servlet, JSTL, Session Management |
| **Database** | PostgreSQL, SQL, JDBC, PreparedStatement |
| **Design Pattern** | MVC, DAO Pattern, Service Layer |
| **Nghiệp vụ** | CRUD, Authentication, Authorization |
| **Bảo mật** | BCrypt / SHA-256, SQL Injection Prevention |
| **UI / UX** | Bootstrap 5, Responsive Design |
| **Build Tool** | Maven |
| **Testing** | JUnit 5 |
| **DevOps** | Git, GitHub, Apache Tomcat |

---

## 📊 Trạng thái dự án

> 🚧 **IN DEVELOPMENT** — Đang phát triển tích cực

| Phase | Nội dung | Trạng thái |
|-------|----------|-----------|
| Phase 1 | Cơ sở hạ tầng | 🔄 Đang thực hiện |
| Phase 2 | Quản lý nhân sự | ⏳ Chưa bắt đầu |
| Phase 3 | Chấm công | ⏳ Chưa bắt đầu |
| Phase 4 | Tiền lương | ⏳ Chưa bắt đầu |
| Phase 5 | Báo cáo & Dashboard | ⏳ Chưa bắt đầu |
| Phase 6 | Mở rộng | ⏳ Chưa bắt đầu |

---

## 📜 License

Project **MIXIMOI HRM & PAYROLL** được xây dựng với mục đích **học tập và nghiên cứu** môn học Công nghệ Java.

---

<div align="center">

## ⭐ MIXIMOI HRM & PAYROLL

**Java 17 · JSP · Servlet · JDBC · PostgreSQL · Apache Tomcat · Bootstrap 5**

*Xây dựng ứng dụng web quản lý nhân sự và tiền lương cho Công ty MixiMoi*

---

*© 2026 MixiMoi — Built for educational purposes*

</div>