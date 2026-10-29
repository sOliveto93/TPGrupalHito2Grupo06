package com.unla.hito2.controller;

import com.unla.hito2.service.LiquidacionService;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/liquidacion")
public class LiquidacionController {

    private final LiquidacionService liquidacionService;

    public LiquidacionController(LiquidacionService liquidacionService) {
        this.liquidacionService = liquidacionService;
    }

    @PostMapping("/{id}/enviar-mail")
    @PreAuthorize("hasRole('EMPLEADO')")
    public String enviarLiquidacionPorMail(@PathVariable Long id,
                                           Authentication authentication,
                                           RedirectAttributes redirectAttributes) {
        if (authentication == null) {
            return "redirect:/login";
        }

        String username = authentication.getName();

        try {
            liquidacionService.enviarLiquidacionPorMail(id, username);
            redirectAttributes.addFlashAttribute("exito", "Liquidación enviada por mail correctamente");
        } catch (AccessDeniedException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Ocurrió un error al enviar la liquidación por mail");
        }

        return "redirect:/contabilidad/sueldo";
    }
}
