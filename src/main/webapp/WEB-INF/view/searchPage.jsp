<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Event" %>
<%@ page import="model.Category" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    List<Event> searchResults = (List<Event>) request.getAttribute("searchResults");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
    String keyword = (String) request.getAttribute("keyword");
    String location = (String) request.getAttribute("location");
    String selectedCategoryId = (String) request.getAttribute("selectedCategoryId");
    String selectedPriceRange = (String) request.getAttribute("selectedPriceRange");
    String selectedSortBy = (String) request.getAttribute("selectedSortBy");
    
    SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE, MMMM d");
    DecimalFormat priceFormat = new DecimalFormat("#,##0.00");
    
    // Set defaults for search fields
    if (keyword == null) keyword = "";
    if (location == null) location = "";
    if (selectedPriceRange == null) selectedPriceRange = "";
    if (selectedSortBy == null) selectedSortBy = "";
%>
<html>
<head>
    <title>Search Event - AayoJana</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <style>
        .container {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        
        .main-content {
            flex: 1;
            padding: 20px;
        }
        
        .search-bar {
            background-color: #f8f9fa;
            padding: 40px 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            text-align: center;
        }
        
        .search-bar h1 {
            font-size: 32px;
            color: var(--primary);
            margin-bottom: 20px;
        }
        
        .search-inputs {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            justify-content: center;
            max-width: 900px;
            margin: 0 auto;
        }
        
        .search-inputs input {
            flex: 1;
            min-width: 200px;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }
        
        .search-inputs select {
            flex: 1;
            min-width: 150px;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            appearance: none;
            background: url("data:image/svg+xml;charset=utf-8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24'%3E%3Cpath fill='%23888' d='M7 10l5 5 5-5H7z'/%3E%3C/svg%3E") no-repeat;
            background-position: right 10px center;
            background-color: white;
        }
        
        .search-inputs button {
            background-color: var(--primary);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 5px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .search-inputs button:hover {
            background-color: var(--primary-dark);
        }
        
        .content-wrapper {
            display: flex;
            gap: 30px;
            flex-wrap: wrap;
        }
        
        .filter-section {
            flex: 0 0 250px;
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        
        .filter-section h3 {
            font-size: 18px;
            margin-bottom: 15px;
            color: var(--primary);
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        
        .filter-group {
            margin-bottom: 20px;
        }
        
        .filter-group h4 {
            font-size: 16px;
            margin-bottom: 10px;
            color: var(--dark);
        }
        
        .filter-group label {
            display: block;
            margin-bottom: 8px;
            color: var(--gray);
            cursor: pointer;
        }
        
        .filter-group label input {
            margin-right: 8px;
        }
        
        .filter-group a {
            display: block;
            margin-top: 8px;
            color: var(--primary);
            text-decoration: none;
            font-size: 14px;
        }
        
        .filter-actions {
            display: flex;
            gap: 10px;
        }
        
        .filter-actions button {
            flex: 1;
            padding: 8px 0;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 500;
        }
        
        .filter-actions .clear {
            background-color: #f8f9fa;
            color: var(--gray);
        }
        
        .filter-actions .apply {
            background-color: var(--primary);
            color: white;
        }
        
        .events-section {
            flex: 1;
        }
        
        .results-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .results-count {
            font-size: 18px;
            color: var(--dark);
        }
        
        .sort-options {
            display: flex;
            align-items: center;
        }
        
        .sort-options label {
            margin-right: 10px;
            color: var(--gray);
        }
        
        .sort-options select {
            padding: 8px 30px 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            background: white url("data:image/svg+xml;charset=utf-8,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24'%3E%3Cpath fill='%23888' d='M7 10l5 5 5-5H7z'/%3E%3C/svg%3E") no-repeat;
            background-position: right 10px center;
            appearance: none;
        }
        
        .events-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
        }
        
        .event-item {
            background-color: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s;
            position: relative;
        }
        
        .event-item:hover {
            transform: translateY(-5px);
        }
        
        .event-item a {
            text-decoration: none;
            color: inherit;
            display: block;
            padding: 15px;
        }
        
        .image-placeholder, .image-wrapper {
            height: 180px;
            background-color: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #aaa;
            margin-bottom: 15px;
            position: relative;
            overflow: hidden;
            border-radius: 8px;
        }
        
        .event-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .like {
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: rgba(255, 255, 255, 0.8);
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            z-index: 1;
        }
        
        .tag, .discount, .sold-out {
            position: absolute;
            top: 10px;
            left: 10px;
            padding: 5px 10px;
            border-radius: 3px;
            font-size: 12px;
            font-weight: 600;
            z-index: 1;
        }
        
        .tag {
            background-color: #e3f2fd;
            color: #1976d2;
        }
        
        .discount {
            background-color: #fff8e1;
            color: #ff8f00;
        }
        
        .sold-out {
            background-color: #ffebee;
            color: #d32f2f;
        }
        
        .event-item h3 {
            font-size: 16px;
            margin-bottom: 10px;
            color: var(--dark);
            line-height: 1.4;
            min-height: 45px;
        }
        
        .event-item p {
            font-size: 14px;
            color: var(--gray);
            margin-bottom: 5px;
            display: flex;
            align-items: center;
        }
        
        .event-item p .icon {
            margin-right: 5px;
        }
        
        .view-more {
            text-align: center;
            margin-top: 30px;
        }
        
        .view-more button {
            background-color: transparent;
            border: 2px solid var(--primary);
            color: var(--primary);
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .view-more button:hover {
            background-color: var(--primary);
            color: white;
        }
        
        .view-more a {
            display: inline-block;
            margin-top: 30px;
            color: var(--primary);
            font-weight: 600;
            text-decoration: none;
        }
        
        .recommended-section {
            margin-top: 60px;
        }
        
        .recommended-section h2 {
            font-size: 24px;
            margin-bottom: 20px;
            color: var(--dark);
        }
        
        .carousel {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 20px;
        }
        
        .carousel button {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: none;
            background-color: white;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            cursor: pointer;
        }
        
        .loading-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(255, 255, 255, 0.8);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 2;
        }
        
        .image-wrapper.loaded .loading-overlay {
            display: none;
        }
        
        .event-price {
            font-weight: 600;
            font-size: 15px;
            color: var(--primary);
            margin-top: 10px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .event-tag {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 3px;
            font-size: 11px;
            background-color: rgba(89, 40, 229, 0.1);
            color: var(--primary);
        }
        
        .event-price.free {
            color: #4CAF50;
        }
        
        .no-results {
            background-color: #f8f9fa;
            padding: 40px;
            text-align: center;
            border-radius: 10px;
            grid-column: 1 / -1;
        }
        
        .no-results i {
            font-size: 48px;
            color: #ccc;
            margin-bottom: 20px;
        }
        
        .no-results p {
            color: var(--gray);
            font-size: 18px;
            margin-bottom: 20px;
        }
        
        .no-results .btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 500;
        }
        
        .active-filters {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 20px;
        }
        
        .filter-tag {
            background-color: #f0f0f0;
            color: var(--dark);
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            display: flex;
            align-items: center;
        }
        
        .filter-tag i {
            margin-left: 5px;
            cursor: pointer;
        }
        
        @media (max-width: 768px) {
            .content-wrapper {
                flex-direction: column;
            }
            
            .filter-section {
                flex: 1 1 auto;
                order: 2;
            }
            
            .events-section {
                order: 1;
            }
            
            .results-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <jsp:include page="common/userHeader.jsp" />
    <div class="main-content">        <div class="search-bar">
            <h1>Search Events</h1>
            <form action="${pageContext.request.contextPath}/SearchEvents" method="get" class="search-form">
                <div class="search-inputs">
                    <input type="text" name="keyword" placeholder="Search by event name or description" value="<%= keyword %>">
                    <input type="text" name="location" placeholder="Location" value="<%= location %>">
                    <select name="category">
                        <option value="">All Categories</option>
                        <% if (categories != null) {
                            for (Category category : categories) {
                                if (category.isActive()) {
                                    boolean isSelected = selectedCategoryId != null && 
                                                         selectedCategoryId.equals(String.valueOf(category.getCategoryId()));
                        %>
                        <option value="<%= category.getCategoryId() %>" <%= isSelected ? "selected" : "" %>><%= category.getName() %></option>
                        <% 
                                }
                            }
                        } %>
                    </select>
                    <button type="submit"><i class="fas fa-search"></i> Search</button>
                </div>
            </form>
        </div>
        
        <%-- Display active filters --%>
        <% boolean hasActiveFilters = (keyword != null && !keyword.isEmpty()) || 
                                     (location != null && !location.isEmpty()) || 
                                     (selectedCategoryId != null && !selectedCategoryId.isEmpty()) ||
                                     (selectedPriceRange != null && !selectedPriceRange.isEmpty()); %>
        <% if (hasActiveFilters) { %>
        <div class="active-filters">
            <div class="filter-tag">
                Active Filters:
            </div>
            <% if (keyword != null && !keyword.isEmpty()) { %>
                <div class="filter-tag">
                    Keyword: <%= keyword %>
                    <i class="fas fa-times" onclick="removeFilter('keyword')"></i>
                </div>
            <% } %>
            <% if (location != null && !location.isEmpty()) { %>
                <div class="filter-tag">
                    Location: <%= location %>
                    <i class="fas fa-times" onclick="removeFilter('location')"></i>
                </div>
            <% } %>
            <% if (selectedCategoryId != null && !selectedCategoryId.isEmpty()) { 
                String categoryName = "Category";
                for (Category category : categories) {
                    if (String.valueOf(category.getCategoryId()).equals(selectedCategoryId)) {
                        categoryName = category.getName();
                        break;
                    }
                }
            %>
                <div class="filter-tag">
                    Category: <%= categoryName %>                    <i class="fas fa-times" onclick="removeFilter('category')"></i>
                </div>
            <% } %>
            <% if (selectedPriceRange != null && !selectedPriceRange.isEmpty()) { 
                String priceRangeText = "Price Range";
                if ("free".equals(selectedPriceRange)) priceRangeText = "Free";
                else if ("under500".equals(selectedPriceRange)) priceRangeText = "Under NPR 500";
                else if ("500to1000".equals(selectedPriceRange)) priceRangeText = "NPR 500 - 1,000";
                else if ("1000to5000".equals(selectedPriceRange)) priceRangeText = "NPR 1,000 - 5,000";
                else if ("above5000".equals(selectedPriceRange)) priceRangeText = "Above NPR 5,000";
            %>
                <div class="filter-tag">
                    Price: <%= priceRangeText %>
                    <i class="fas fa-times" onclick="removeFilter('priceRange')"></i>
                </div>
            <% } %>
            <div class="filter-tag">
                <a href="${pageContext.request.contextPath}/SearchEvents" style="text-decoration: none; color: inherit;">
                    Clear All <i class="fas fa-times"></i>
                </a>
            </div>
        </div>
        <% } %>
        
        <div class="content-wrapper">            <div class="filter-section">
                <h3>Filter</h3>
                <form id="filterForm" action="${pageContext.request.contextPath}/SearchEvents" method="get">
                    <input type="hidden" name="keyword" value="<%= keyword %>">
                    <input type="hidden" name="location" value="<%= location %>">
                    
                    <div class="filter-group">
                        <h4>Category</h4>
                        <label><input type="radio" name="category" value="" <%= selectedCategoryId == null || selectedCategoryId.isEmpty() ? "checked" : "" %>> All</label>
                        <% if (categories != null) {
                            for (Category category : categories) {
                                if (category.isActive()) {
                                    boolean isSelected = selectedCategoryId != null && 
                                                         selectedCategoryId.equals(String.valueOf(category.getCategoryId()));
                        %>
                        <label><input type="radio" name="category" value="<%= category.getCategoryId() %>" <%= isSelected ? "checked" : "" %>> <%= category.getName() %></label>
                        <% 
                                }
                            }
                        } %>
                    </div>
                    
                    <div class="filter-group">
                        <h4>Price Range</h4>
                        <label><input type="radio" name="priceRange" value="" <%= selectedPriceRange == null || selectedPriceRange.isEmpty() ? "checked" : "" %>> All Prices</label>
                        <label><input type="radio" name="priceRange" value="free" <%= "free".equals(selectedPriceRange) ? "checked" : "" %>> Free</label>
                        <label><input type="radio" name="priceRange" value="under500" <%= "under500".equals(selectedPriceRange) ? "checked" : "" %>> Under NPR 500</label>
                        <label><input type="radio" name="priceRange" value="500to1000" <%= "500to1000".equals(selectedPriceRange) ? "checked" : "" %>> NPR 500 - 1,000</label>
                        <label><input type="radio" name="priceRange" value="1000to5000" <%= "1000to5000".equals(selectedPriceRange) ? "checked" : "" %>> NPR 1,000 - 5,000</label>
                        <label><input type="radio" name="priceRange" value="above5000" <%= "above5000".equals(selectedPriceRange) ? "checked" : "" %>> Above NPR 5,000</label>
                    </div>
                    
                    <div class="filter-actions">
                        <button type="button" class="clear" onclick="clearFilters()">Clear all</button>
                        <button type="submit" class="apply">Apply</button>
                    </div>
                </form>
            </div>
            <div class="events-section">
                <div class="results-header">
                    <div class="results-count">
                        <%= searchResults != null ? searchResults.size() : 0 %> results
                        <% if (keyword != null && !keyword.isEmpty()) { %>
                        for "<%= keyword %>"
                        <% } %>
                        <% if (location != null && !location.isEmpty()) { %>
                        in <%= location %>
                        <% } %>
                    </div>
                    
                    <div class="sort-options">
                        <label>Sort by:</label>
                        <select id="sortSelect" onchange="updateSort(this.value)">
                            <option value="" <%= selectedSortBy == null || selectedSortBy.isEmpty() ? "selected" : "" %>>Relevance</option>
                            <option value="dateAsc" <%= "dateAsc".equals(selectedSortBy) ? "selected" : "" %>>Date: Earliest First</option>
                            <option value="dateDesc" <%= "dateDesc".equals(selectedSortBy) ? "selected" : "" %>>Date: Latest First</option>
                            <option value="priceAsc" <%= "priceAsc".equals(selectedSortBy) ? "selected" : "" %>>Price: Low to High</option>
                            <option value="priceDesc" <%= "priceDesc".equals(selectedSortBy) ? "selected" : "" %>>Price: High to Low</option>
                            <option value="nameAsc" <%= "nameAsc".equals(selectedSortBy) ? "selected" : "" %>>Name: A to Z</option>
                            <option value="nameDesc" <%= "nameDesc".equals(selectedSortBy) ? "selected" : "" %>>Name: Z to A</option>
                        </select>
                    </div>
                </div>
                <div class="events-grid">
                    <% if (searchResults == null || searchResults.isEmpty()) { %>
                        <div class="no-results">
                            <i class="fas fa-search"></i>
                            <p>No events found matching your search criteria.</p>
                            <p>Try adjusting your search or explore all events.</p>
                            <a href="${pageContext.request.contextPath}/EventsServlet" class="btn"><i class="fas fa-th-large"></i> Browse All Events</a>
                        </div>
                    <% } else { 
                        for (Event event : searchResults) { 
                            boolean isFree = event.getPrice() <= 0;
                    %>
                        <div class="event-item">
                            <a href="${pageContext.request.contextPath}/events/details?id=<%= event.getEventId() %>">
                                <% if (event.getImageData() != null && event.getImageData().length > 0) { %>
                                    <div class="image-wrapper">
                                        <div class="loading-overlay">
                                            <i class="fas fa-circle-notch fa-spin"></i>
                                        </div>
                                        <img src="${pageContext.request.contextPath}/eventImage?eventId=<%= event.getEventId() %>" 
                                             alt="<%= event.getTitle() %>" class="event-image"
                                             onload="this.parentNode.classList.add('loaded')">
                                        <% if (isFree) { %>
                                            <div class="tag">Free</div>
                                        <% } %>
                                    </div>
                                <% } else { %>
                                    <div class="image-placeholder">
                                        <i class="fas fa-images"></i>
                                        <span>No Image Available</span>
                                        <% if (isFree) { %>
                                            <div class="tag">Free</div>
                                        <% } %>
                                    </div>
                                <% } %>
                                <div class="like"><i class="far fa-heart"></i></div>
                                <h3><%= event.getTitle() %></h3>
                                <p><span class="icon"><i class="fas fa-calendar"></i></span> <%= dateFormat.format(event.getDate()) %> | <%= event.getTime() %></p>
                                <p><span class="icon"><i class="fas fa-map-marker-alt"></i></span> <%= event.getLocation() %></p>
                                <p class="event-price <%= isFree ? "free" : "" %>">
                                    <% if(!isFree) { %>
                                        From NPR. <%= priceFormat.format(event.getPrice()) %>
                                        <span class="event-tag">Paid</span>
                                    <% } else { %>
                                        Free entry
                                        <span class="event-tag">Free</span>
                                    <% } %>
                                </p>
                            </a>
                        </div>
                    <% 
                        }
                    } %>
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="common/footer.jsp" />
</div>
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Make event cards clickable
    const eventItems = document.querySelectorAll('.event-item');
    eventItems.forEach(item => {
        item.addEventListener('click', function(e) {
            // Don't trigger if clicking on like button
            if (e.target.closest('.like')) {
                e.stopPropagation();
                return;
            }
            
            // Get the link inside the card
            const link = this.querySelector('a');
            if (link && link.getAttribute('href')) {
                window.location.href = link.getAttribute('href');
            }
        });
        
        // Add keyboard accessibility
        item.setAttribute('tabindex', '0');
        item.addEventListener('keydown', function(e) {
            // Enter or space key
            if (e.key === 'Enter' || e.key === ' ') {
                e.preventDefault();
                const link = this.querySelector('a');
                if (link && link.getAttribute('href')) {
                    window.location.href = link.getAttribute('href');
                }
            }
        });
    });
    
    // Handle like buttons
    const likeButtons = document.querySelectorAll('.like');
    likeButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            this.classList.toggle('active');
            const icon = this.querySelector('i');
            if (icon.classList.contains('far')) {
                icon.classList.remove('far');
                icon.classList.add('fas');
            } else {
                icon.classList.remove('fas');
                icon.classList.add('far');
            }
        });
    });
    
    // Make filter radios submit form when changed
    const filterRadios = document.querySelectorAll('#filterForm input[type="radio"]');
    filterRadios.forEach(radio => {
        radio.addEventListener('change', function() {
            // Optional: auto-submit form when a radio is clicked
            // document.getElementById('filterForm').submit();
        });
    });
});

function clearFilters() {
    const form = document.getElementById('filterForm');
    const radios = form.querySelectorAll('input[type="radio"]');
    radios.forEach(radio => {
        if (radio.value === '') {
            radio.checked = true;
        } else {
            radio.checked = false;
        }
    });
    form.submit();
}

function updateSort(sortValue) {
    // Get current URL
    const url = new URL(window.location.href);
    
    // Add or update the sortBy parameter
    if (sortValue) {
        url.searchParams.set('sortBy', sortValue);
    } else {
        url.searchParams.delete('sortBy');
    }
    
    // Navigate to new URL
    window.location.href = url.toString();
}

function removeFilter(filterName) {
    // Get current URL
    const url = new URL(window.location.href);
    
    // Remove the specified filter parameter
    url.searchParams.delete(filterName);
    
    // Navigate to new URL
    window.location.href = url.toString();
}
</script>
</body>
</html>