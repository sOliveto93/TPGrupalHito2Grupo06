package com.unla.hito2.controller;

import com.unla.hito2.dto.CambiarContraseniaDto;
import com.unla.hito2.service.ContraseniaService;
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
@RequestMapping("/cuenta")
@PreAuthorize("isAuthenticated")
public class ContraseniaController {

    private final ContraseniaService contraseniaService;

    public ContraseniaController(ContraseniaService contraseniaService) {
        this.contraseniaService = contraseniaService;
    }

    @GetMapping("/cambiar-contrasenia")
    public String mostrarFormulario(Model model) {
        model.addAttribute("contraseniaDto", new CambiarContraseniaDto());
        return "cuenta/cambiar-contrasenia";
    }

    @PostMapping("/cambiar-contrasenia")
    public String cambiarContrasenia(
            @Valid @ModelAttribute("contraseniaDto") CambiarContraseniaDto dto,
            BindingResult result,
            Authentication authentication,
            Model model,
            RedirectAttributes redirectAttributes) {

        if (result.hasErrors()) {
            return "cuenta/cambiar-contrasenia";
        }

        try {
            contraseniaService.cambiarContrasenia(
                    authentication.getName(), dto);

            redirectAttributes.addFlashAttribute(
                    "exito", "Contraseña actualizada correctamente");

            return "redirect:/cuenta/cambiar-contrasenia";
        }catch (IllegalArgumentException e){
            model.addAttribute("error", e.getMessage());
            return  "cuenta/cambiar-contrasenia";
        }

    }

    @GetMapping("/perfil")
    public String mostrarPerfil(Authentication authentication, Model model) {

        model.addAttribute("usuario",
                contraseniaService.obtenerUsuario(authentication.getName()));

        return "cuenta/perfil";
    }


}
