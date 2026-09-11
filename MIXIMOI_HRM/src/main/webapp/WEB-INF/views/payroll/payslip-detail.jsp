<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <jsp:include page="/WEB-INF/views/common/head.jsp">
        <jsp:param name="title" value="Phiếu Lương Điện Tử A4 - Nguyễn Văn An (NV001) - MIXIMOI HRM" />
    </jsp:include>
</head>
<body class="hrm-app-body">
<div class="app-layout">
    <!-- Sidebar -->
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

    <div class="app-main">
        <!-- Topbar -->
        <jsp:include page="/WEB-INF/views/common/topbar.jsp" />

        <!-- Main Content Area -->
        <main class="app-content p-3 p-lg-4">
            <!-- Alert if sent -->
            <c:if test="${param.success eq 'sent'}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 mb-3" role="alert">
                    <i class="bi bi-check-circle-fill fs-5"></i>
                    <div>Đã gửi phiếu lương điện tử trực tiếp đến hòm thư <strong>an.nguyen@miximoi.vn</strong> và thông báo đẩy App!</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Sticky Action Topbar for Payslip -->
            <div class="payslip-action-topbar mb-4">
                <div class="d-flex align-items-center gap-3">
                    <a href="${pageContext.request.contextPath}/payslip" class="btn btn-outline-secondary btn-sm d-flex align-items-center gap-1">
                        <i class="bi bi-arrow-left"></i>
                        <span>Quay lại danh sách</span>
                    </a>
                    <div class="d-none d-md-flex align-items-center gap-2 border-start ps-3">
                        <span class="badge bg-success-subtle text-success border border-success-subtle d-inline-flex align-items-center gap-1">
                            <i class="bi bi-patch-check-fill"></i> Xác thực chữ ký số SHA-256 hợp lệ
                        </span>
                        <span class="text-muted small font-monospace">Mã tra cứu: e3b0c4429...52b855</span>
                    </div>
                </div>

                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-outline-dark btn-sm d-flex align-items-center gap-1" onclick="window.print()">
                        <i class="bi bi-printer"></i>
                        <span>In phiếu lương</span>
                    </button>
                    <button type="button" class="btn btn-outline-primary btn-sm d-flex align-items-center gap-1" onclick="alert('Đang tạo và tải xuống file PDF khổ A4 có nhúng chứng thư số HSM...');">
                        <i class="bi bi-file-earmark-pdf"></i>
                        <span>Tải PDF ký số</span>
                    </button>
                    <form method="post" action="${pageContext.request.contextPath}/payslip" class="m-0">
                        <input type="hidden" name="action" value="send_single">
                        <input type="hidden" name="code" value="${empCode != null ? empCode : 'NV001'}">
                        <button type="submit" class="btn btn-primary btn-sm d-flex align-items-center gap-1 shadow-sm">
                            <i class="bi bi-send-fill"></i>
                            <span>Gửi cho nhân viên</span>
                        </button>
                    </form>
                </div>
            </div>

            <!-- A4 Document Wrapper -->
            <div class="payslip-a4-wrapper">
                <div class="payslip-paper-card position-relative">
                    <!-- Watermark -->
                    <div class="payslip-watermark">MIXIMOI</div>

                    <!-- Header with Company Info & Slip Code -->
                    <div class="d-flex justify-content-between align-items-start border-bottom pb-3 mb-3">
                        <div class="d-flex align-items-center gap-3">
                            <div class="d-flex align-items-center justify-content-center bg-primary text-white rounded-3 shadow-sm" style="width: 46px; height: 46px; font-size: 1.4rem;">
                                <i class="bi bi-building-fill-gear"></i>
                            </div>
                            <div>
                                <h2 class="h6 fw-bold text-dark mb-0 text-uppercase" style="letter-spacing: 0.5px;">CÔNG TY TNHH MIXIMOI VIỆT NAM</h2>
                                <div class="text-muted" style="font-size: 0.76rem;">Tầng 25, Landmark 81, 720A Điện Biên Phủ, P.22, Q. Bình Thạnh, TP.HCM</div>
                                <div class="text-muted" style="font-size: 0.74rem;">Mã số thuế: <strong>0316888999</strong> • Hotline: 1900 6868 • Email: hr@miximoi.vn</div>
                            </div>
                        </div>
                        <div class="text-end">
                            <div class="fw-bold text-primary font-monospace" style="font-size: 0.95rem;">MÃ PHIẾU: PL-202609-001</div>
                            <div class="text-muted" style="font-size: 0.76rem;">Ngày phát hành: <strong>05/10/2026</strong></div>
                            <span class="badge bg-success-subtle text-success border border-success-subtle mt-1" style="font-size: 0.7rem;">
                                <i class="bi bi-check-circle-fill"></i> ĐÃ THANH TOÁN
                            </span>
                        </div>
                    </div>

                    <!-- Title Section -->
                    <div class="text-center my-3">
                        <h1 class="payslip-official-title">PHIẾU LƯƠNG NHÂN VIÊN</h1>
                        <div class="text-muted fw-semibold" style="font-size: 0.85rem;">
                            KỲ LƯƠNG: THÁNG 09/2026 • Từ ngày 01/09/2026 đến ngày 30/09/2026
                        </div>
                    </div>

                    <!-- Employee Details Grid -->
                    <div class="payslip-meta-grid">
                        <div class="payslip-meta-item">
                            <span class="payslip-meta-label">Họ và tên nhân viên:</span>
                            <span class="payslip-meta-value text-primary fs-6">Nguyễn Văn An</span>
                        </div>
                        <div class="payslip-meta-item">
                            <span class="payslip-meta-label">Mã số nhân viên:</span>
                            <span class="payslip-meta-value font-monospace">NV001 (MXM-0102)</span>
                        </div>
                        <div class="payslip-meta-item">
                            <span class="payslip-meta-label">Chức vụ / Vị trí:</span>
                            <span class="payslip-meta-value">Senior Software Developer</span>
                        </div>
                        <div class="payslip-meta-item">
                            <span class="payslip-meta-label">Phòng ban:</span>
                            <span class="payslip-meta-value">Phòng Kỹ thuật & Công nghệ</span>
                        </div>
                        <div class="payslip-meta-item">
                            <span class="payslip-meta-label">Ngày công chuẩn:</span>
                            <span class="payslip-meta-value">22.0 ngày</span>
                        </div>
                        <div class="payslip-meta-item">
                            <span class="payslip-meta-label">Ngày công thực tế:</span>
                            <span class="payslip-meta-value text-success">22.0 / 22.0 ngày (100%)</span>
                        </div>
                        <div class="payslip-meta-item">
                            <span class="payslip-meta-label">Giờ làm thêm (OT):</span>
                            <span class="payslip-meta-value">8.5 giờ (Hệ số 1.5x)</span>
                        </div>
                        <div class="payslip-meta-item">
                            <span class="payslip-meta-label">Tài khoản nhận lương:</span>
                            <span class="payslip-meta-value font-monospace">Techcombank - 1903 4567 89012</span>
                        </div>
                    </div>

                    <!-- Two-Column Financial Tables: Earnings vs Deductions -->
                    <div class="row g-4 my-2">
                        <!-- Column 1: Gross Income -->
                        <div class="col-12 col-md-6">
                            <div class="payslip-section-title d-flex justify-content-between">
                                <span>I. Các khoản thu nhập</span>
                                <span>Số tiền (VNĐ)</span>
                            </div>
                            <table class="payslip-table-detail">
                                <tbody>
                                    <tr>
                                        <td>1. Lương cơ bản theo hợp đồng</td>
                                        <td class="text-end fw-semibold">14.500.000</td>
                                    </tr>
                                    <tr>
                                        <td>2. Phụ cấp trách nhiệm / Dự án</td>
                                        <td class="text-end fw-semibold">1.500.000</td>
                                    </tr>
                                    <tr>
                                        <td>3. Phụ cấp ăn trưa (Miễn thuế)</td>
                                        <td class="text-end fw-semibold">730.000</td>
                                    </tr>
                                    <tr>
                                        <td>4. Phụ cấp xăng xe, điện thoại</td>
                                        <td class="text-end fw-semibold">500.000</td>
                                    </tr>
                                    <tr>
                                        <td>5. Lương làm thêm giờ (OT 8.5h)</td>
                                        <td class="text-end fw-semibold">770.000</td>
                                    </tr>
                                    <tr>
                                        <td>6. Thưởng hiệu suất công việc (KPI)</td>
                                        <td class="text-end fw-semibold">500.000</td>
                                    </tr>
                                    <tr class="fw-bold bg-light">
                                        <td class="py-2 text-dark">TỔNG THU NHẬP (GROSS)</td>
                                        <td class="py-2 text-end text-primary fs-6">18.500.000</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- Column 2: Deductions -->
                        <div class="col-12 col-md-6">
                            <div class="payslip-section-title d-flex justify-content-between text-danger">
                                <span>II. Các khoản khấu trừ</span>
                                <span>Số tiền (VNĐ)</span>
                            </div>
                            <table class="payslip-table-detail">
                                <tbody>
                                    <tr>
                                        <td>1. Bảo hiểm Xã hội (BHXH 8.0%)</td>
                                        <td class="text-end fw-semibold text-danger">1.160.000</td>
                                    </tr>
                                    <tr>
                                        <td>2. Bảo hiểm Y tế (BHYT 1.5%)</td>
                                        <td class="text-end fw-semibold text-danger">217.500</td>
                                    </tr>
                                    <tr>
                                        <td>3. Bảo hiểm Thất nghiệp (BHTN 1.0%)</td>
                                        <td class="text-end fw-semibold text-danger">122.500</td>
                                    </tr>
                                    <tr>
                                        <td>4. Thuế Thu nhập cá nhân (TNCN)</td>
                                        <td class="text-end fw-semibold text-muted">0</td>
                                    </tr>
                                    <tr>
                                        <td>5. Tạm ứng lương trong kỳ</td>
                                        <td class="text-end fw-semibold text-muted">0</td>
                                    </tr>
                                    <tr>
                                        <td>6. Các khoản thu hồi / Kỷ luật khác</td>
                                        <td class="text-end fw-semibold text-muted">0</td>
                                    </tr>
                                    <tr class="fw-bold bg-light">
                                        <td class="py-2 text-dark">TỔNG CÁC KHOẢN KHẤU TRỪ</td>
                                        <td class="py-2 text-end text-danger fs-6">-1.500.000</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Net Take-Home Highlight Box -->
                    <div class="payslip-net-box">
                        <div>
                            <div class="text-uppercase fw-bold opacity-75 small" style="letter-spacing: 0.5px;">LƯƠNG THỰC LĨNH (NET TAKE-HOME PAY)</div>
                            <div class="mt-1" style="font-size: 0.85rem; font-style: italic;">
                                Số tiền bằng chữ: <strong>Mười bảy triệu đồng chẵn.</strong>
                            </div>
                        </div>
                        <div class="text-end">
                            <div class="payslip-net-number">17.000.000 <span class="fs-5 fw-normal">VNĐ</span></div>
                        </div>
                    </div>

                    <!-- Confirmation Note -->
                    <div class="p-2 px-3 bg-light rounded text-muted small mb-4" style="font-size: 0.76rem;">
                        <i class="bi bi-info-circle-fill text-primary me-1"></i>
                        Lương đã được chi trả thành công vào tài khoản Techcombank <strong>1903456789012</strong> qua lệnh chi số <strong>FT262539102948</strong> lúc 09:15:22 ngày 10/09/2026. Nếu có thắc mắc, vui lòng gửi phản hồi về phòng Nhân sự trong vòng 03 ngày làm việc.
                    </div>

                    <!-- 3 Digital Signatures Grid -->
                    <div class="payslip-sign-grid">
                        <!-- Signer 1 -->
                        <div>
                            <div class="payslip-sign-role">NGƯỜI LẬP BIỂU</div>
                            <div class="payslip-sign-sub">(Ký, ghi rõ họ tên)</div>
                            <div class="payslip-digital-stamp">
                                <i class="bi bi-patch-check-fill text-success fs-6"></i>
                                <div class="fw-bold mt-1">ĐÃ KÝ ĐIỆN TỬ</div>
                                <div style="font-size: 0.65rem;">04/10/2026 15:30:22</div>
                            </div>
                            <div class="payslip-signer-name">Trần Thị Thu Thảo</div>
                            <small class="text-muted">Chuyên viên C&B</small>
                        </div>

                        <!-- Signer 2 -->
                        <div>
                            <div class="payslip-sign-role">KẾ TOÁN TRƯỞNG</div>
                            <div class="payslip-sign-sub">(Ký, ghi rõ họ tên)</div>
                            <div class="payslip-digital-stamp">
                                <i class="bi bi-patch-check-fill text-success fs-6"></i>
                                <div class="fw-bold mt-1">ĐÃ KÝ ĐIỆN TỬ</div>
                                <div style="font-size: 0.65rem;">04/10/2026 17:45:10</div>
                            </div>
                            <div class="payslip-signer-name">Lê Hoàng Nam</div>
                            <small class="text-muted">Trưởng phòng Kế toán</small>
                        </div>

                        <!-- Signer 3 -->
                        <div>
                            <div class="payslip-sign-role">TỔNG GIÁM ĐỐC</div>
                            <div class="payslip-sign-sub">(Ký duyệt, đóng dấu)</div>
                            <div class="payslip-digital-stamp" style="border-color: #2563eb; background: #eff6ff; color: #1d4ed8;">
                                <i class="bi bi-shield-check text-primary fs-6"></i>
                                <div class="fw-bold mt-1">KÝ SỐ HSM CA</div>
                                <div style="font-size: 0.65rem;">05/10/2026 08:20:15</div>
                            </div>
                            <div class="payslip-signer-name">Vũ Trọng Khang</div>
                            <small class="text-muted">Tổng Giám Đốc Điều Hành</small>
                        </div>
                    </div>

                    <!-- Bottom Security Hash Bar -->
                    <div class="payslip-hash-bar">
                        <span>SHA-256: e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855</span>
                        <span>Xác thực số: hrm.miximoi.vn/verify/PL-202609-001</span>
                    </div>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <jsp:include page="/WEB-INF/views/common/footer.jsp" />
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
