package com.unla.hito2;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordEncoder {

    public static void main(String[] args) {
        BCryptPasswordEncoder pe = new BCryptPasswordEncoder();
        String usuario="empleado21@gmail.com";
        System.out.println(pe.encode(usuario));
        String hashCreado="$2a$10$nVAcErz2yNIAMcNyRg7eUehduicaVzwy4eex6d2NICwFnX.bkyXAa";
        System.out.println(pe.matches(usuario,hashCreado));
    }
}