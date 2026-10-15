package com.unla.hito2;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordEncoder {

    public static void main(String[] args) {
        BCryptPasswordEncoder pe = new BCryptPasswordEncoder();
        System.out.println(pe.encode("admin"));
        System.out.println(pe.matches("admin","$2a$10$RzFQ8VQWqT.fdjiQEF9QsOOHTxXoVCPYb/NH7i2XKr.oX1k6dlW7G"));
    }
}