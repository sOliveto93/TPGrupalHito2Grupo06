package com.unla.hito2.controller;

import java.math.BigDecimal;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.unla.hito2.service.CajaService;

@Controller
@RequestMapping ("/caja")
@PreAuthorize("hasRole('EMPLEADO')")
public class CajaController {

    private final CajaService cajaService;

    public CajaController(CajaService cajaService) {
        this.cajaService = cajaService;
    }

    @PostMapping("/abrir")
    public String abrirCaja(
            Authentication authentication,
            RedirectAttributes redirectAttributes) {
        try {
            cajaService.abrirCaja(authentication.getName());
            redirectAttributes.addFlashAttribute("exito", "Caja abierta correctamente.");
        } catch (IllegalStateException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/empleado/home";
    }

    @PostMapping("/cerrar")
    public String cerrarCaja(
            @RequestParam BigDecimal totalDeclarado,
            Authentication authentication,
            RedirectAttributes redirectAttributes) {
        try {
            cajaService.cerrarCaja(authentication.getName(), totalDeclarado);
            redirectAttributes.addFlashAttribute("exito", "Caja cerrada correctamente.");
        } catch (IllegalStateException | IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/empleado/home";
    }

}
