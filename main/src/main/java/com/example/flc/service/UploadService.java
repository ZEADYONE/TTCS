package com.example.flc.service;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.ServletContext;

@Service
public class UploadService {
    private final ServletContext servletContext;

    public UploadService(ServletContext servletContext) {
        this.servletContext = servletContext;
    }

    public String handleSaveUploadImg(MultipartFile file, String target) {
        // 1. Kiểm tra: Nếu "không có file" HOẶC "file rỗng" thì dừng lại ngay
        if (file == null || file.isEmpty()) {
            return "";
        }

        // 2. Nếu đã vượt qua IF ở trên, chắc chắn 'file' đang TỐT (không null)
        String rootPath = this.servletContext.getRealPath("/resources/images");
        String finalName = "";

        try {
            // Dòng 21 bây giờ sẽ an toàn tuyệt đối
            byte[] bytes = file.getBytes();

            File dir = new File(rootPath + File.separator + target);
            if (!dir.exists())
                dir.mkdirs();

            finalName = System.currentTimeMillis() + "-" + file.getOriginalFilename();
            File serverFile = new File(dir.getAbsolutePath() + File.separator + finalName);

            try (BufferedOutputStream stream = new BufferedOutputStream(new FileOutputStream(serverFile))) {
                stream.write(bytes);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return finalName;
    }

    public String handleSaveUploadSound(MultipartFile file, String target) {
        // 1. Kiểm tra: Nếu "không có file" HOẶC "file rỗng" thì dừng lại ngay
        if (file == null || file.isEmpty()) {
            return "";
        }

        // 2. Nếu đã vượt qua IF ở trên, chắc chắn 'file' đang TỐT (không null)
        String rootPath = this.servletContext.getRealPath("/resources/sound");
        String finalName = "";

        try {
            // Dòng 21 bây giờ sẽ an toàn tuyệt đối
            byte[] bytes = file.getBytes();

            File dir = new File(rootPath + File.separator + target);
            if (!dir.exists())
                dir.mkdirs();

            finalName = System.currentTimeMillis() + "-" + file.getOriginalFilename();
            File serverFile = new File(dir.getAbsolutePath() + File.separator + finalName);

            try (BufferedOutputStream stream = new BufferedOutputStream(new FileOutputStream(serverFile))) {
                stream.write(bytes);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return finalName;
    }

}
