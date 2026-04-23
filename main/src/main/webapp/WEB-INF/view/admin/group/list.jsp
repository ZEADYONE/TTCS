<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Group Management - Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="/css/admin/deck.css">
    <link rel="stylesheet" href="/css/admin/header-slide.css">
    
    <style>
        /* CSS cho nút tạo và các Modal vì deck.css có thể không có đủ các class này */
        .btn-create {
            background-color: #4361ee;
            color: white;
            padding: 8px 16px;
            border-radius: 6px;
            border: none;
            font-weight: bold;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }
        .btn-create:hover {
            background-color: #3a53d0;
        }

        .toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        /* Modals / Popups */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            align-items: center;
            justify-content: center;
            z-index: 1000;
            backdrop-filter: blur(3px);
        }

        .modal-content {
            background: #ffffff;
            padding: 30px;
            border-radius: 12px;
            width: 100%;
            max-width: 450px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            animation: slideDown 0.3s ease-out;
        }

        @keyframes slideDown {
            from { transform: translateY(-20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        .modal-content h3 {
            margin-bottom: 20px;
            color: #333;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            font-size: 1rem;
        }

        .form-control:focus {
            outline: none;
            border-color: #4361ee;
        }

        .modal-footer {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
            margin-top: 10px;
        }

        .btn-outline {
            background: transparent;
            border: 1px solid #e0e0e0;
            color: #333;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
        }
        
        .btn-outline:hover { background: #f8f9fa; }
        
        .btn-submit { background-color: #4361ee; color: white; padding: 8px 16px; border-radius: 6px; border: none; cursor: pointer; }
        .btn-warning { background: #ffc107; color: black; padding: 8px 16px; border-radius: 6px; border: none; cursor: pointer; }
        .btn-danger { background: #dc3545; color: white; padding: 8px 16px; border-radius: 6px; border: none; cursor: pointer; }
        
        .actions {
            display: flex;
            gap: 10px;
            justify-content: center;
        }
        
        .actions button, .actions a {
            background: none;
            border: none;
            cursor: pointer;
            font-size: 1.1rem;
            color: #6c757d;
        }
        .actions a:hover { color: #28a745; }
        .actions .btn-edit:hover { color: #ffc107; }
        .actions .btn-del:hover { color: #dc3545; }
    </style>
</head>

<body>
    <header class="top-nav">
        <div class="brand">
            <h1>English Learning Platform</h1>
            <p>Master English with Interactive Exercises</p>
        </div>
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
                    <a href="/" class="dropdown-item">
                        <i class="fa-regular fa-user"></i>
                        <span>Client</span>
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
    </header>

    <div class="container">
        <aside class="sidebar">
            <div class="sidebar-header">
                <i class="fa-solid fa-layer-group logo-icon"></i>
            </div>
            <nav class="menu">
                <a href="/admin/dashboard" class="menu-item">
                    <i class="fa-solid fa-gauge-high"></i> Dashboard
                </a>
                <a href="/admin/user" class="menu-item">
                    <i class="fa-solid fa-user-large"></i> User
                </a>
                <a href="/admin/deck" class="menu-item">
                    <i class="fa-solid fa-book-open"></i> Deck FlashCard
                </a>
                <a href="/admin/course" class="menu-item">
                    <i class="fa-solid fa-graduation-cap"></i> Course
                </a>
                <a href="/admin/groups" class="menu-item active">
                    <i class="fa-solid fa-users"></i> Group
                </a>
                <a href="/admin/role" class="menu-item">
                    <i class="fa-solid fa-cube"></i> Role
                </a>
            </nav>
        </aside>

        <main class="main-content">
            <section class="content-body">
                <div class="table-wrapper">
                    
                    <div class="toolbar">
                        <div class="search-filter-group">
                            <form action="/admin/groups" method="get" class="search-box">
                                <i class="fa-solid fa-magnifying-glass"></i>
                                <input type="text" name="keyword" value="${keyword}" placeholder="Search Group...">
                            </form>
                        </div>
                        
                        <button class="btn-create" onclick="openModal('create-group-popup')">
                            <i class="fas fa-plus"></i> Tạo nhóm mới
                        </button>
                    </div>

                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID-Group</th>
                                <th>Name</th>
                                <th>Description</th>
                                <th>Leader</th>
                                <th>Members</th>
                                <th>Created At</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="group" items="${groups}">
                                <tr>
                                    <td>${group.id}</td>
                                    <td><strong>${group.groupName}</strong></td>
                                    <td><span style="color: #6c757d; font-size: 0.9rem;">${empty group.description ? 'N/A' : group.description}</span></td>
                                    <td><i class="fas fa-crown" style="color: #ffc107; margin-right: 5px;"></i> ${group.leaderName}</td>
                                    <td><strong>${group.memberCount}</strong></td>
                                    <td>${group.createdAt}</td>
                                    <td class="actions">
                                        <a href="/admin/groups/${group.id}" title="Xem chi tiết">
                                            <i class="fa-regular fa-eye btn-view"></i>
                                        </a>
                                        
                                        <button class="btn-edit" title="Chỉnh sửa nhóm"
                                            onclick="openEditModal(${group.id}, '${group.groupName}', '${group.description}')">
                                            <i class="fa-solid fa-wrench"></i>
                                        </button>
                                        
                                        <button class="btn-del" title="Xóa nhóm"
                                            onclick="openDeleteModal(${group.id}, '${group.groupName}')">
                                            <i class="fa-solid fa-trash-alt"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty groups}">
                                <tr>
                                    <td colspan="7" style="text-align: center; padding: 20px; color: #6c757d;">
                                        Không tìm thấy nhóm học tập nào.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>

                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Page navigation" style="margin-top: 20px;">
                            <ul class="custom-pagination">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage - 1}${not empty keyword ? '&keyword='.concat(keyword) : ''}" aria-label="Previous">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="?page=${i}${not empty keyword ? '&keyword='.concat(keyword) : ''}">${i}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage + 1}${not empty keyword ? '&keyword='.concat(keyword) : ''}" aria-label="Next">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </section>
        </main>
    </div>

    <!-- Modal: Tạo Nhóm -->
    <div id="create-group-popup" class="modal-overlay">
        <div class="modal-content">
            <form action="/admin/groups/create" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <h3 style="color: #4361ee;"><i class="fas fa-plus-circle"></i> Tạo Nhóm Mới</h3>
                
                <div class="form-group">
                    <label>Tên nhóm học tập <span style="color: #dc3545;">*</span></label>
                    <input type="text" name="groupName" class="form-control" required placeholder="Nhập tên nhóm...">
                </div>
                
                <div class="form-group">
                    <label>Mô tả (Không bắt buộc)</label>
                    <textarea name="description" class="form-control" placeholder="Mô tả mục đích nhóm..." style="min-height: 80px;"></textarea>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn-outline" onclick="closeModal('create-group-popup')">Hủy</button>
                    <button type="submit" class="btn-submit"><i class="fas fa-save"></i> Tạo Nhóm</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal: Sửa Nhóm -->
    <div id="edit-group-popup" class="modal-overlay">
        <div class="modal-content">
            <form action="/admin/groups/update" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <input type="hidden" name="groupId" id="edit-group-id" />
                
                <h3 style="color: #f39c12;"><i class="fas fa-edit"></i> Chỉnh Sửa Thông Tin Nhóm</h3>
                
                <div class="form-group">
                    <label>Tên nhóm <span style="color: #dc3545;">*</span></label>
                    <input type="text" name="groupName" id="edit-group-name" class="form-control" required>
                </div>

                <div class="form-group">
                    <label>Mô tả</label>
                    <textarea name="description" id="edit-group-desc" class="form-control" style="min-height: 80px;"></textarea>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn-outline" onclick="closeModal('edit-group-popup')">Hủy</button>
                    <button type="submit" class="btn-warning"><i class="fas fa-check"></i> Cập Nhật</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal: Xóa Nhóm -->
    <div id="delete-group-popup" class="modal-overlay">
        <div class="modal-content" style="border-top: 5px solid #dc3545;">
            <form action="/admin/groups/delete" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                <input type="hidden" name="groupId" id="delete-group-id" />
                
                <h3 style="color: #dc3545;"><i class="fas fa-exclamation-triangle"></i> Xác nhận Xóa Nhóm</h3>
                
                <div class="form-group">
                    <p>Bạn có chắc chắn muốn xóa vĩnh viễn nhóm <strong><span id="delete-group-name-display"></span></strong> không?</p>
                    <p style="color: #dc3545; font-size: 0.9rem; margin-top: 10px; background: #ffebee; padding: 10px; border-radius: 6px;">
                        <i class="fas fa-info-circle"></i> Cảnh báo: Mọi dữ liệu thành viên và flashcard chia sẻ trong nhóm này sẽ bị xóa VĨNH VIỄN. Hành động này không thể hoàn tác.
                    </p>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn-outline" onclick="closeModal('delete-group-popup')">Hủy bỏ</button>
                    <button type="submit" class="btn-danger"><i class="fas fa-trash-alt"></i> Đồng ý xóa</button>
                </div>
            </form>
        </div>
    </div>

    <script src="/js/admin/style.js"></script>
    <script>
        function openModal(modalId) {
            document.getElementById(modalId).style.display = 'flex';
        }

        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }

        window.onclick = function(event) {
            if (event.target.classList.contains('modal-overlay')) {
                event.target.style.display = "none";
            }
        }

        function openEditModal(id, name, desc) {
            document.getElementById('edit-group-id').value = id;
            document.getElementById('edit-group-name').value = name;
            document.getElementById('edit-group-desc').value = desc !== 'null' && desc !== '' ? desc : '';
            openModal('edit-group-popup');
        }

        function openDeleteModal(id, name) {
            document.getElementById('delete-group-id').value = id;
            document.getElementById('delete-group-name-display').innerText = name;
            openModal('delete-group-popup');
        }
    </script>
</body>
</html>
