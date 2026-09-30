package com.miximoi.hrm.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet phục vụ và hiển thị các tệp tin tải lên (Avatars, CCCD, Resumes, Contracts)
 * URL pattern: /uploads/*
 */
@WebServlet(urlPatterns = {"/uploads/*"})
public class UploadServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.trim().isEmpty() || pathInfo.contains("..")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Đường dẫn tệp không hợp lệ");
            return;
        }

        File file = null;

        // 1. Thử tìm trong deploy real path
        String realPath = getServletContext().getRealPath("/uploads" + pathInfo);
        if (realPath != null) {
            File f = new File(realPath);
            if (f.exists() && f.isFile()) {
                file = f;
            }
        }

        // 2. Thử tìm trong thư mục source workspace
        if (file == null) {
            String[] possibleRoots = {
                "d:/BaiTapCNJAVA/MIXIMOI_HRM/MIXIMOI_HRM/src/main/webapp/uploads",
                System.getProperty("user.dir") + "/src/main/webapp/uploads",
                System.getProperty("user.dir") + "/MIXIMOI_HRM/src/main/webapp/uploads",
                System.getProperty("catalina.base") + "/uploads"
            };
            for (String root : possibleRoots) {
                File f = new File(root + pathInfo);
                if (f.exists() && f.isFile()) {
                    file = f;
                    break;
                }
            }
        }

        if (file == null || !file.exists() || !file.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy tệp tải lên");
            return;
        }

        // Xác định MIME type
        String contentType = getServletContext().getMimeType(file.getName());
        if (contentType == null) {
            try {
                contentType = Files.probeContentType(file.toPath());
            } catch (IOException ignored) {}
        }
        if (contentType == null) {
            String lower = file.getName().toLowerCase();
            if (lower.endsWith(".jpg") || lower.endsWith(".jpeg")) contentType = "image/jpeg";
            else if (lower.endsWith(".png")) contentType = "image/png";
            else if (lower.endsWith(".webp")) contentType = "image/webp";
            else if (lower.endsWith(".gif")) contentType = "image/gif";
            else if (lower.endsWith(".pdf")) contentType = "application/pdf";
            else if (lower.endsWith(".docx")) contentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
            else if (lower.endsWith(".doc")) contentType = "application/msword";
            else contentType = "application/octet-stream";
        }

        response.setContentType(contentType);
        response.setContentLengthLong(file.length());
        response.setHeader("Cache-Control", "public, max-age=86400");
        response.setHeader("Content-Disposition", "inline; filename=\"" + file.getName() + "\"");

        try (FileInputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}
