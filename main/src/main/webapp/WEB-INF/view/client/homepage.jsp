<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>English Learning Platform - Landing Page</title>
                <link rel="stylesheet" href="/css/client/head-foot.css">
                <link rel="stylesheet" href="/css/admin/style_user.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            </head>

            <body>

                <header class="top-nav">
                    <div class="brand">
                        <h1>English Learning Platform</h1>
                        <p>Master English with Interactive Exercises</p>
                    </div>
                    <div class="nav-links">
                        <a href="/">HOME</a>
                        <a href=" /client/library">FLASHCARD</a>
                    </div>

                    <c:if test="${empty pageContext.request.userPrincipal}">
                        <div class="login">
                            <a href="/login">Login</a>
                            <span style="color: aliceblue;">-</span>
                            <a href="/client/sign_up">Sign up</a>
                        </div>
                    </c:if>



                    <c:if test="${not empty pageContext.request.userPrincipal}">
                        <div class="container-info" id="userDropdownTrigger">
                            <i class="fa-regular fa-user"></i>
                            <span class="user-name">
                                <c:out value="${sessionScope.fullName}" />
                            </span>
                            <i class="fa-solid fa-chevron-down mini-arrow"></i>

                            <div class="info-dropdown" id="infoDropdown">

                                <a href="/profile" class="dropdown-item">
                                    <i class="fa-solid fa-circle-info"></i>
                                    <span>Information</span>
                                </a>
                                <c:if test="${sessionScope.role == 'ADMIN'}">
                                    <a href="/admin/user" class="dropdown-item">
                                        <i class="fa-regular fa-user"></i>
                                        <span>Admin</span>
                                    </a>
                                </c:if>

                                <form method="post" action="/logout">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                                    <button type="submit" class="dropdown-item"
                                        style="width: 100%; border: 0px none; background-color: white;">
                                        <i class="fa-solid fa-right-from-bracket"></i>
                                        <span>Logout</span>
                                    </button>
                                </form>

                            </div>
                        </div>
                    </c:if>

                </header>

                <section class="hero">
                    <div class="container">
                        <h2>Learn English - Open Your World</h2>
                        <div class="hero-image">
                            <img src="https://th.bing.com/th/id/OIP.p4fX-hIDZkY2M78ivPTFogHaEK?w=273&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3"
                                alt="Learning English Illustration">
                        </div>
                    </div>
                </section>

                <section class="stats">
                    <div class="container stat-wrapper">
                        <div class="stat-item">
                            <h3>100K+</h3>
                            <p>Học viên</p>
                        </div>
                        <div class="stat-item">
                            <h3>500+</h3>
                            <p>Bài tập</p>
                        </div>
                    </div>
                </section>

                <section class="steps">
                    <div class="container">
                        <div class="section-title">
                            <h2>Bắt đầu chỉ với 3 bước đơn giản</h2>
                            <p>Dễ dàng và nhanh chóng</p>
                        </div>
                        <div class="steps-grid">
                            <div class="step-card">
                                <span class="step-number">01</span>
                                <div class="step-icon"><i class="fa-solid fa-users"></i></div>
                                <h4>Đăng ký tài khoản</h4>
                                <p>Tạo tài khoản miễn phí chỉ trong vài giây.</p>
                            </div>
                            <div class="step-card">
                                <span class="step-number">02</span>
                                <div class="step-icon"><i class="fa-solid fa-book-open"></i></div>
                                <h4>Chọn khóa học</h4>
                                <p>Khám phá các khóa học phù hợp với mục tiêu của bạn.</p>
                            </div>
                            <div class="step-card">
                                <span class="step-number">03</span>
                                <div class="step-icon"><i class="fa-solid fa-rocket"></i></div>
                                <h4>Bắt đầu học</h4>
                                <p>Học mọi lúc mọi nơi trên máy tính và điện thoại.</p>
                            </div>
                        </div>
                    </div>
                </section>

                <section class="cta">
                    <div class="container">
                        <h2>Sẵn sàng bắt đầu hành trình học tập?</h2>
                        <p>Tham gia cùng 100,000+ học viên đang học tập thông minh hơn mỗi ngày</p>
                        <a href="../login/login.html"><button class="btn-start">Bắt đầu ngay nào <i
                                    class="fa-solid fa-arrow-right"></i></button></a>
                    </div>
                </section>

                <footer>
                    <div class="container">
                        <h2 class="footer-logo">English Learning Platform</h2>
                        <div class="footer-grid">
                            <div class="footer-col">
                                <h5>Địa chỉ</h5>
                                <p>Học viện công nghệ bưu chính viễn thông</p>
                            </div>
                            <div class="footer-col">
                                <h5>Thông tin liên hệ</h5>
                                <p>Zalo: 009900990099</p>
                                <p>Email: Vietnam@gmail.com</p>
                            </div>
                            <div class="footer-col">
                                <h5>Thông tin về English Learning Platform</h5>
                                <p>Đơn vị học tiếng anh numberone</p>
                            </div>
                        </div>
                    </div>
                </footer>

                <script src="/js/client/head-foot.js"></script>
            </body>

            </html>