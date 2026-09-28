package com.miximoi.hrm.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

/**
 * Tiện ích upload và lưu trữ file (Avatar, CCCD, File Hợp đồng, Hồ sơ đính kèm).
 */
public class FileUploadUtil {

    /**
     * Lưu Part file tải lên vào thư mục webapp/uploads/<subDir> và trả về đường dẫn tương đối.
     * @param part Part từ request.getPart(...)
     * @param subDir Tên thư mục con: "avatars", "cccd", "contracts"
     * @param request HttpServletRequest
     * @return Đường dẫn URL tương đối (VD: "/uploads/avatars/avatar_12345.jpg") hoặc null nếu không có file
     */
    public static String saveFile(Part part, String subDir, HttpServletRequest request) throws IOException {
        if (part == null || part.getSize() <= 0) {
            return null;
        }

        String submittedName = part.getSubmittedFileName();
        if (submittedName == null || submittedName.trim().isEmpty()) {
            return null;
        }

        submittedName = Paths.get(submittedName).getFileName().toString();
        String ext = "";
        int dotIdx = submittedName.lastIndexOf('.');
        if (dotIdx >= 0) {
            ext = submittedName.substring(dotIdx).toLowerCase();
        }

        String safeFileName = subDir + "_" + System.currentTimeMillis() + "_" + UUID.randomUUID().toString().substring(0, 8) + ext;

        // 1. Lưu vào deploy directory thực tế của webapp trên Tomcat
        String deployUploadPath = request.getServletContext().getRealPath("/uploads/" + subDir);
        if (deployUploadPath != null) {
            File deployDir = new File(deployUploadPath);
            if (!deployDir.exists()) {
                deployDir.mkdirs();
            }
            Path deployTarget = new File(deployDir, safeFileName).toPath();
            try (InputStream in = part.getInputStream()) {
                Files.copy(in, deployTarget, StandardCopyOption.REPLACE_EXISTING);
            }
        }

        // 2. Lưu đồng thời vào source directory dự án để không bị mất khi redeploy / build lại
        try {
            String workspaceUploadPath = "d:/BaiTapCNJAVA/MIXIMOI_HRM/MIXIMOI_HRM/src/main/webapp/uploads/" + subDir;
            File srcDir = new File(workspaceUploadPath);
            if (!srcDir.exists()) {
                srcDir.mkdirs();
            }
            Path srcTarget = new File(srcDir, safeFileName).toPath();
            if (deployUploadPath != null) {
                Path deployTarget = new File(deployUploadPath, safeFileName).toPath();
                if (Files.exists(deployTarget)) {
                    Files.copy(deployTarget, srcTarget, StandardCopyOption.REPLACE_EXISTING);
                }
            } else {
                try (InputStream in = part.getInputStream()) {
                    Files.copy(in, srcTarget, StandardCopyOption.REPLACE_EXISTING);
                }
            }
        } catch (Exception ignored) {}

        return "/uploads/" + subDir + "/" + safeFileName;
    }
}
