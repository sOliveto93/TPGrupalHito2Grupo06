package com.unla.hito2;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordEncoder {

    public static void main(String[] args) {
        BCryptPasswordEncoder pe = new BCryptPasswordEncoder();
        System.out.println(pe.encode("oscarruina@gmail.com"));
        System.out.println(pe.matches("oscarruina@gmail.com","$2a$10$vqLPPp.UsUIz5FgKJmgxjOU5VziUIARlkuBNLJO/Hj415vUFIHlly"));
    }
}