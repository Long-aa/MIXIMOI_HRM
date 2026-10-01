<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- ============================================================
     MODAL: Web-FaceID AI Biometric Scanner (Chống giả mạo Anti-Spoofing)
     ============================================================ --%>
<div class="modal fade" id="faceIdScannerModal" tabindex="-1" aria-labelledby="faceIdScannerModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width: 460px;">
        <div class="modal-content border-0 shadow-lg text-white" style="border-radius: 20px; overflow: hidden; background: #0f172a;">
            <div class="modal-header border-0 pb-0 pt-4 px-4 d-flex justify-content-between align-items-center">
                <div class="d-flex align-items-center gap-2">
                    <div class="rounded-circle text-white p-2 d-flex align-items-center justify-content-center" style="background: rgba(168, 85, 247, 0.25); width:38px; height:38px;">
                        <i class="bi bi-person-bounding-box" style="color: #c084fc; font-size:1.2rem;"></i>
                    </div>
                    <div>
                        <h6 class="modal-title fw-bold text-white mb-0" id="faceIdScannerModalLabel" style="font-size:0.95rem;">Sinh trắc học AI (FaceID)</h6>
                        <small style="color: #94a3b8; font-size: 0.72rem;">Facial Recognition &bull; Landmark Vector</small>
                    </div>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" onclick="stopFaceCamera()"></button>
            </div>
            
            <div class="modal-body p-4 text-center">
                <!-- GPS Geofencing Status Pill -->
                <div class="d-flex justify-content-center mb-3">
                    <div id="faceGeoPill" class="geofence-pill checking">
                        <i class="bi bi-geo-alt"></i>
                        <span id="faceGeoText">Đang xác thực tọa độ GPS...</span>
                    </div>
                </div>

                <!-- Video/Scanner Frame -->
                <div class="position-relative mx-auto mb-3" style="width: 260px; height: 260px; border-radius: 20px; overflow: hidden; background: #020617; border: 2px solid #3b82f6; box-shadow: 0 0 30px rgba(59, 130, 246, 0.35);">
                    <video id="faceCameraVideo" autoplay playsinline muted style="width:100%; height:100%; object-fit:cover; display:none;"></video>
                    
                    <!-- Liveness Pulse Ring -->
                    <div class="liveness-guide-box" id="livenessGuideRing"></div>

                    <!-- Simulated Scanner Visual -->
                    <div id="faceSimulatedView" style="width:100%; height:100%; display:flex; flex-direction:column; align-items:center; justify-content:center; background: radial-gradient(circle, #1e293b 0%, #0f172a 100%);">
                        <div class="rounded-circle bg-primary bg-opacity-25 d-flex align-items-center justify-content-center mb-2" style="width:105px; height:105px; border:3px solid #38bdf8; overflow:hidden;">
                            <i class="bi bi-person-fill" style="font-size: 4.2rem; color: #38bdf8;"></i>
                        </div>
                        <div class="text-white fw-bold" style="font-size: 0.9rem;">${sessionScope.currentUser.fullName}</div>
                        <div style="font-size: 0.72rem; color: #94a3b8;">${sessionScope.currentUser.role} &bull; ${not empty sessionScope.currentUser.employeeCode ? sessionScope.currentUser.employeeCode : 'NV-ACTIVE'}</div>
                    </div>

                    <!-- Holographic Target Grid & Animated Scan Line -->
                    <div class="position-absolute top-0 start-0 w-100 h-100" style="pointer-events: none;">
                        <div class="scan-laser-line"></div>
                        <div class="scanner-bracket-corner tl"></div>
                        <div class="scanner-bracket-corner tr"></div>
                        <div class="scanner-bracket-corner bl"></div>
                        <div class="scanner-bracket-corner br"></div>
                    </div>
                </div>

                <!-- Liveness Anti-Spoofing Instruction Box -->
                <div id="livenessAlertBox" class="mb-3 p-2 rounded text-center liveness-box">
                    <i class="bi bi-eye me-1" id="livenessIcon"></i>
                    <span id="livenessInstructionText">Vui lòng nhìn thẳng vào camera và chớp mắt nhẹ...</span>
                </div>

                <!-- Recognition Status Badge -->
                <div id="faceStatusBadge" class="d-inline-flex align-items-center gap-2 px-3 py-1 rounded-pill mb-3" style="background: rgba(245, 158, 11, 0.15); border: 1px solid rgba(245, 158, 11, 0.3); font-size: 0.78rem; color: #fbbf24;">
                    <i class="bi bi-hourglass-split" id="faceStatusIcon"></i>
                    <span id="faceStatusText">Đang phân tích sinh trắc học &amp; Liveness...</span>
                </div>

                <div class="text-secondary mb-3" style="font-size: 0.78rem;">
                    Nhân sự: <strong>${sessionScope.currentUser.fullName}</strong>. Hệ thống tự động kích hoạt nút điểm danh sau khi vượt qua kiểm tra chống giả mạo.
                </div>

                <form method="post" action="${pageContext.request.contextPath}/attendance" class="w-100" id="faceCheckinForm">
                    <input type="hidden" name="action" value="checkin">
                    <input type="hidden" name="method" value="FaceID">
                    <input type="hidden" name="latitude" id="faceLatitude" value="">
                    <input type="hidden" name="longitude" id="faceLongitude" value="">
                    <button type="submit" id="btnSubmitFaceCheckin" class="btn btn-primary w-100 py-2.5 fw-bold d-flex align-items-center justify-content-center gap-2 shadow" style="border-radius: 12px; background: linear-gradient(135deg, #7c3aed 0%, #3b82f6 100%); border:none; font-size: 0.92rem;" disabled>
                        <i class="bi bi-check2-circle fs-5"></i>
                        <span>Xác nhận Check-in FaceID</span>
                    </button>
                </form>
            </div>
            <div class="modal-footer border-0 p-3 pt-0 justify-content-center">
                <small style="color: #64748b; font-size: 0.72rem;"><i class="bi bi-shield-lock me-1"></i>Bảo mật SSL 256-bit &bull; Chống giả mạo ảnh tĩnh (Anti-Spoofing)</small>
            </div>
        </div>
    </div>
</div>
