package com.unla.hito2.controller;

import com.unla.hito2.dto.CompletarResponsableDto;
import com.unla.hito2.service.ResponsableService;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import jakarta.validation.Valid;
import org.springframework.security.core.Authentication;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/responsable")
@PreAuthorize("hasRole('RESPONSABLE')")
public class ResponsableController {

    private final ResponsableService responsableService;

    public ResponsableController(ResponsableService responsableService) {
        this.responsableService = responsableService;
    }

    @GetMapping("/completar-datos")
    public String mostrarFormulario(Model model,
                                    Authentication authentication) {

        CompletarResponsableDto dto =
                responsableService.obtenerDatos(authentication.getName());

        boolean perfilCompleto =
                dto.getNombre() != null && !dto.getNombre().isBlank()
                        && dto.getApellido() != null && !dto.getApellido().isBlank()
                        && dto.getDni() != null && !dto.getDni().isBlank()
                        && dto.getFechaNac() != null;

        if (perfilCompleto) {
            return "redirect:/responsable/home";
        }

        model.addAttribute("responsableDto", dto);
        return "responsable/completar-datos";
    }

    @PostMapping("/completar-datos")
    public String guardarDatos(
            @Valid @ModelAttribute("responsableDto") CompletarResponsableDto dto,
            BindingResult result,
            Authentication authentication,
            Model model,
            RedirectAttributes redirectAttributes) {

        if (result.hasErrors()) {
            return "responsable/completar-datos";
        }

        try {
            responsableService.completarDatos(authentication.getName(), dto);

            redirectAttributes.addFlashAttribute(
                    "exito", "Datos personales guardados correctamente.");

            return "redirect:/responsable/home";

        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "responsable/completar-datos";
        }
    }

}