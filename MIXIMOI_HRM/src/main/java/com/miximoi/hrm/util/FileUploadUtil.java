package com.miximoi.hrm.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

/**
 * Tiện ích upload và lưu trữ file an toàn (Avatar, CCCD, File Hợp đồng, Hồ sơ đính kèm).
 */
public class FileUploadUtil {

    // Danh sách phần mở rộng bị cấm tuyệt đối (bảo mật hệ thống)
    private static final Set<String> FORBIDDEN_EXTENSIONS = new HashSet<>(Arrays.asList(
            ".jsp", ".jspx", ".exe", ".bat", ".cmd", ".sh", ".php", ".asp", ".aspx", ".jar", ".war", ".class", ".dll", ".vbs"
    ));

    // Cấu hình giới hạn kích thước theo thư mục (bytes)
    private static final long MAX_AVATAR_SIZE = 5 * 1024 * 1024;    // 5MB
    private static final long MAX_DOC_SIZE = 10 * 1024 * 1024;      // 10MB

    // Phần mở rộng hợp lệ theo phân loại
    private static final Set<String> ALLOWED_AVATAR_EXT = new HashSet<>(Arrays.asList(
            ".jpg", ".jpeg", ".png", ".webp", ".gif"
    ));
    private static final Set<String> ALLOWED_CCCD_EXT = new HashSet<>(Arrays.asList(
            ".jpg", ".jpeg", ".png", ".webp", ".pdf"
    ));
    private static final Set<String> ALLOWED_RESUME_EXT = new HashSet<>(Arrays.asList(
            ".pdf", ".docx", ".doc", ".jpg", ".jpeg", ".png"
    ));
    private static final Set<String> ALLOWED_CONTRACT_EXT = new HashSet<>(Arrays.asList(
            ".pdf", ".docx", ".doc", ".jpg", ".jpeg", ".png"
    ));

    /**
     * Kiểm tra tính hợp lệ của tệp tải lên (kích thước, phần mở rộng)
     */
    public static void validateFile(Part part, String subDir) {
        if (part == null || part.getSize() <= 0) {
            return;
        }

        String submittedName = part.getSubmittedFileName();
        if (submittedName == null || submittedName.trim().isEmpty()) {
            return;
        }

        String fileName = Paths.get(submittedName).getFileName().toString();
        String ext = "";
        int dotIdx = fileName.lastIndexOf('.');
        if (dotIdx >= 0) {
            ext = fileName.substring(dotIdx).toLowerCase();
        }

        if (FORBIDDEN_EXTENSIONS.contains(ext)) {
            throw new IllegalArgumentException("Loại tệp [" + ext + "] bị từ chối vì lý do an ninh hệ thống.");
        }

        long size = part.getSize();
        if ("avatars".equalsIgnoreCase(subDir)) {
            if (size > MAX_AVATAR_SIZE) {
                throw new IllegalArgumentException("Ảnh chân dung [" + fileName + "] vượt quá dung lượng tối đa cho phép 5MB.");
            }
            if (!ALLOWED_AVATAR_EXT.contains(ext)) {
                throw new IllegalArgumentException("Ảnh chân dung chỉ hỗ trợ định dạng JPG, PNG, WEBP (tệp nhận được: " + fileName + ").");
            }
        } else if ("cccd".equalsIgnoreCase(subDir)) {
            if (size > MAX_DOC_SIZE) {
                throw new IllegalArgumentException("Bản quét CCCD [" + fileName + "] vượt quá dung lượng tối đa cho phép 10MB.");
            }
            if (!ALLOWED_CCCD_EXT.contains(ext)) {
                throw new IllegalArgumentException("Bản quét CCCD chỉ hỗ trợ định dạng PDF, JPG, PNG, WEBP (tệp nhận được: " + fileName + ").");
            }
        } else if ("resumes".equalsIgnoreCase(subDir)) {
            if (size > MAX_DOC_SIZE) {
                throw new IllegalArgumentException("Hồ sơ đính kèm [" + fileName + "] vượt quá dung lượng tối đa cho phép 10MB.");
            }
            if (!ALLOWED_RESUME_EXT.contains(ext)) {
                throw new IllegalArgumentException("Hồ sơ đính kèm chỉ hỗ trợ định dạng PDF, DOCX, DOC (tệp nhận được: " + fileName + ").");
            }
        } else if ("contracts".equalsIgnoreCase(subDir)) {
            if (size > MAX_DOC_SIZE) {
                throw new IllegalArgumentException("Tệp hợp đồng [" + fileName + "] vượt quá dung lượng tối đa cho phép 10MB.");
            }
            if (!ALLOWED_CONTRACT_EXT.contains(ext)) {
                throw new IllegalArgumentException("Tệp hợp đồng chỉ hỗ trợ định dạng PDF, DOCX, DOC (tệp nhận được: " + fileName + ").");
            }
        }
    }

    /**
     * Lưu Part file tải lên vào thư mục webapp/uploads/<subDir> và trả về đường dẫn tương đối.
     * @param part Part từ request.getPart(...)
     * @param subDir Tên thư mục con: "avatars", "cccd", "resumes", "contracts"
     * @param request HttpServletRequest
     * @return Đường dẫn URL tương đối (VD: "/uploads/avatars/avatars_12345.jpg") hoặc null nếu không có file
     */
    public static String saveFile(Part part, String subDir, HttpServletRequest request) throws IOException {
        if (part == null || part.getSize() <= 0) {
            return null;
        }

        String submittedName = part.getSubmittedFileName();
        if (submittedName == null || submittedName.trim().isEmpty()) {
            return null;
        }

        // Kiểm tra dung lượng & định dạng file an toàn
        validateFile(part, subDir);

        submittedName = Paths.get(submittedName).getFileName().toString();
        String ext = "";
        int dotIdx = submittedName.lastIndexOf('.');
        if (dotIdx >= 0) {
            ext = submittedName.substring(dotIdx).toLowerCase();
        }

        String safeFileName = subDir + "_" + System.currentTimeMillis() + "_" + UUID.randomUUID().toString().substring(0, 8) + ext;

        // 1. Lưu vào deploy directory thực tế của webapp trên Tomcat (để web server phục vụ ngay)
        String deployUploadPath = request.getServletContext().getRealPath("/uploads/" + subDir);
        File deploySavedFile = null;
        if (deployUploadPath != null) {
            File deployDir = new File(deployUploadPath);
            if (!deployDir.exists()) {
                deployDir.mkdirs();
            }
            deploySavedFile = new File(deployDir, safeFileName);
            try (InputStream in = part.getInputStream()) {
                Files.copy(in, deploySavedFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }
        }

        // 2. Lưu đồng thời vào source directory dự án để không bị mất khi redeploy / rebuild lại
        File workspaceDir = resolveWorkspaceUploadDir(subDir);
        if (workspaceDir != null) {
            if (!workspaceDir.exists()) {
                workspaceDir.mkdirs();
            }
            File srcSavedFile = new File(workspaceDir, safeFileName);
            if (deploySavedFile != null && deploySavedFile.exists()) {
                Files.copy(deploySavedFile.toPath(), srcSavedFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
            } else {
                try (InputStream in = part.getInputStream()) {
                    Files.copy(in, srcSavedFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
            }
        }

        return "/uploads/" + subDir + "/" + safeFileName;
    }

    /**
     * Tự động xác định đường dẫn thư mục uploads trong mã nguồn dự án
     */
    private static File resolveWorkspaceUploadDir(String subDir) {
        String[] candidateRoots = {
            "d:/BaiTapCNJAVA/MIXIMOI_HRM/MIXIMOI_HRM/src/main/webapp/uploads",
            System.getProperty("user.dir") + "/src/main/webapp/uploads",
            System.getProperty("user.dir") + "/MIXIMOI_HRM/src/main/webapp/uploads",
            System.getProperty("catalina.base") + "/uploads"
        };

        for (String root : candidateRoots) {
            File f = new File(root, subDir);
            File parent = f.getParentFile();
            if (parent != null && parent.exists()) {
                return f;
            }
        }

        // Mặc định fallback
        return new File("d:/BaiTapCNJAVA/MIXIMOI_HRM/MIXIMOI_HRM/src/main/webapp/uploads", subDir);
    }
}
