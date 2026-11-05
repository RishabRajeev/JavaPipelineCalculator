package com.devops.app;

public class App {
    public int add(int a, int b) {
        return a + b;
    }

    public int subtract(int a, int b) {
        return a - b;
    }

    public int multiply(int a, int b) {
        return a * b;
    }

    public double divide(int a, int b) {
        if (b == 0) {
            throw new IllegalArgumentException("Division by zero is not allowed.");
        }
        return (double) a / b;
    }

    public static void main(String[] args) {
        App app = new App();
        System.out.println("Calculator App Initialized. 10 + 5 = " + app.add(10, 5));
    }
}