package com.unla.hito2.controller;

import com.unla.hito2.entity.LiquidacionHaberes;
import com.unla.hito2.service.ContabilidadService;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/contabilidad")
public class ContabilidadController {

    private final ContabilidadService contabilidadService;

    public ContabilidadController(ContabilidadService contabilidadService) {
        this.contabilidadService = contabilidadService;
    }

    @GetMapping({"/sueldo", "/liquidacion-sueldo"})
    public String verLiquidacionSueldo(Authentication authentication, Model model) {
        if (authentication == null) {
            return "redirect:/login";
        }

        String username = authentication.getName();

        boolean esAdmin = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().contains("ADMIN") || a.getAuthority().contains("RESPONSABLE"));

        List<LiquidacionHaberes> liquidaciones;
        if (esAdmin) {
            liquidaciones = contabilidadService.obtenerTodasLasLiquidaciones();
        } else {
            liquidaciones = contabilidadService.obtenerLiquidacionesPorEmpleado(username);
        }

        model.addAttribute("liquidaciones", liquidaciones);
        model.addAttribute("username", username);

        return "contabilidad/liquidacion-sueldo";
    }
}