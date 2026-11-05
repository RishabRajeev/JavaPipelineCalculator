<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.devops.app.App" %>
<!DOCTYPE html>
<html>
<head>
    <title>DevOps CI/CD Calculator App</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 50px; background-color: #f4f4f9; display: flex; justify-content: center; }
        .container { width: 100%; max-width: 400px; padding: 25px; background: white; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        h2 { color: #0078D4; text-align: center; margin-top: 0; }
        label { font-weight: bold; color: #333; }
        input, select, button { width: 100%; padding: 10px; margin: 8px 0 15px 0; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px; }
        button { background-color: #0078D4; color: white; font-size: 16px; font-weight: bold; border: none; cursor: pointer; }
        button:hover { background-color: #106EBE; }
        .result { margin-top: 15px; padding: 12px; background: #eef9ff; border-left: 4px solid #0078D4; font-size: 16px; }
        .error { color: #d9534f; }
    </style>
</head>
<body>
<div class="container">
    <h2>Cloud Calculator</h2>
    <form method="get">
        <label for="num1">Number 1:</label>
        <input type="number" id="num1" name="num1" required value="<%= request.getParameter("num1") != null ? request.getParameter("num1") : "" %>">

        <label for="op">Operation:</label>
        <select id="op" name="op">
            <option value="add">Addition (+)</option>
            <option value="subtract">Subtraction (-)</option>
            <option value="multiply">Multiplication (*)</option>
            <option value="divide">Division (/)</option>
        </select>

        <label for="num2">Number 2:</label>
        <input type="number" id="num2" name="num2" required value="<%= request.getParameter("num2") != null ? request.getParameter("num2") : "" %>">

        <button type="submit">Calculate</button>
    </form>

    <%
        String num1Str = request.getParameter("num1");
        String num2Str = request.getParameter("num2");
        String op = request.getParameter("op");

        if (num1Str != null && num2Str != null && op != null) {
            try {
                int num1 = Integer.parseInt(num1Str);
                int num2 = Integer.parseInt(num2Str);
                App app = new App();
                double result = 0;
                boolean error = false;
                String errMessage = "";

                switch (op) {
                    case "add": result = app.add(num1, num2); break;
                    case "subtract": result = app.subtract(num1, num2); break;
                    case "multiply": result = app.multiply(num1, num2); break;
                    case "divide": 
                        if (num2 == 0) {
                            error = true;
                            errMessage = "Error: Division by zero is not allowed!";
                        } else {
                            result = app.divide(num1, num2);
                        }
                        break;
                }
    %>
                <div class="result">
                    <% if (error) { %>
                        <span class="error"><%= errMessage %></span>
                    <% } else { %>
                        <strong>Result:</strong> <%= num1 %> <%= op.equals("add") ? "+" : op.equals("subtract") ? "-" : op.equals("multiply") ? "*" : "/" %> <%= num2 %> = <strong><%= result %></strong>
                    <% } %>
                </div>
    <%
            } catch (Exception e) {
    %>
                <div class="result error">Invalid input format. Please enter valid integers.</div>
    <%
            }
        }
    %>
</div>
</body>
</html>