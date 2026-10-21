package com.unla.hito2.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class AuthController {

    @GetMapping("/login")
    public ModelAndView mostrarLogin() {
        return new ModelAndView("/auth/login.html");
    }

    @GetMapping("/403")
    public String accesoDenegado() {
        return "error/403";
    }
}
