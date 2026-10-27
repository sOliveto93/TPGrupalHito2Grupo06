package com.unla.hito2;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordEncoder {

    public static void main(String[] args) {
        BCryptPasswordEncoder pe = new BCryptPasswordEncoder();
        String usuario="micaela@gmail.com";
        System.out.println(pe.encode(usuario));
        String hashCreado="$2a$10$FBid1DnXmpq2U3inPf4Pl.FScdumDHIkVJJ9.ZB63MUTtSeaDZEdy";
        System.out.println(pe.matches("p@gmail.com","$2a$10$UfEgwOsvranrq.bp33vDfOzFstlRCIuvCDrR4oII0wDzN7sZ4rScm"));
    }
}