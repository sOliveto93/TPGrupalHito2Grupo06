package com.unla.hito2;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordEncoder {

    public static void main(String[] args) {
        BCryptPasswordEncoder pe = new BCryptPasswordEncoder();
        System.out.println(pe.encode("admin"));
        System.out.println(pe.matches("admin","$2a$10$OfyDnRmBCriZqW7ntAf.Fu9LDAZH.oW3dGck8gQktTYiaU41lRHza"));
    }
}