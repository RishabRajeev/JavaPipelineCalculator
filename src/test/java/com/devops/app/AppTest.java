package com.devops.app;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class AppTest {

    @Test
    public void testAdd() {
        App app = new App();
        assertEquals(15, app.add(10, 5));
    }

    @Test
    public void testSubtract() {
        App app = new App();
        assertEquals(5, app.subtract(10, 5));
    }

    @Test
    public void testMultiply() {
        App app = new App();
        assertEquals(50, app.multiply(10, 5));
    }

    @Test
    public void testDivide() {
        App app = new App();
        assertEquals(2.0, app.divide(10, 5), 0.001);
    }

    @Test
    public void testDivideByZero() {
        App app = new App();
        assertThrows(IllegalArgumentException.class, () -> {
            app.divide(10, 0);
        });
    }
}