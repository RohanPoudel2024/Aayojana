<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%!
    // Utility method to check if current path matches a given path
    public boolean isCurrentPath(HttpServletRequest request, String path) {
        String currentPath = (String) request.getAttribute("javax.servlet.forward.servlet_path");
        return path.equals(currentPath) || (currentPath != null && currentPath.startsWith(path + "/"));
    }
%>
