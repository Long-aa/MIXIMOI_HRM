# ==============================================================================
# Dockerfile cho MIXIMOI HRM & PAYROLL (Java 17 + Tomcat 10.1 + Jakarta EE 10)
# ==============================================================================

# STAGE 1: Biên dịch và đóng gói WAR bằng Maven & JDK 17
FROM maven:3.9.6-eclipse-temurin-17-alpine AS builder
WORKDIR /app

# Cache dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy mã nguồn và đóng gói
COPY src ./src
RUN mvn clean package -DskipTests

# STAGE 2: Triển khai trên Apache Tomcat 10.1 (Hỗ trợ Jakarta Servlet 6.0)
FROM tomcat:10.1.20-jdk17-temurin
LABEL maintainer="MIXIMOI Dev Team <admin@miximoi.vn>"

# Xóa các webapp mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Sao chép file WAR đã đóng gói thành ROOT application
COPY --from=builder /app/target/miximoi-hrm.war /usr/local/tomcat/webapps/ROOT.war

# Thiết lập Timezone Việt Nam
ENV TZ=Asia/Ho_Chi_Minh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Cổng truy cập mặc định
EXPOSE 8080

CMD ["catalina.sh", "run"]
