<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<% if (request.getAttribute("bookingsCount") != null && ((Integer)request.getAttribute("bookingsCount")) == 0) { %>
<div style="background-color: #fff3cd; padding: 10px; margin-bottom: 15px; border-radius: 4px; border-left: 4px solid #ffc107; font-size: 0.875rem;">
    <p>No booking data found. You can add sample data for testing purposes:</p>
    <form action="${pageContext.request.contextPath}/admin/financial-reports" method="post">
        <input type="hidden" name="action" value="addSampleData">
        <button type="submit" style="background-color: #ffc107; border: none; padding: 5px 10px; border-radius: 4px; cursor: pointer;">Add Sample Data</button>
    </form>
</div>
<% } %>

<% if (request.getAttribute("dataSampleAdded") != null && (Boolean)request.getAttribute("dataSampleAdded")) { %>
<div style="background-color: #d4edda; padding: 10px; margin-bottom: 15px; border-radius: 4px; border-left: 4px solid #28a745; font-size: 0.875rem;">
    Sample data added successfully! Refresh to see the reports.
</div>
<% } %>
