package com.unla.hito2.controller;

import com.unla.hito2.dto.CambiarContraseniaDto;
import com.unla.hito2.dto.PerfilDto;
import com.unla.hito2.service.ContraseniaService;
import com.unla.hito2.service.UserService;
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
    private final UserService userService;

    public ContraseniaController(ContraseniaService contraseniaService,
                                 UserService userService) {
        this.contraseniaService = contraseniaService;
        this.userService = userService;
    }

    /**
     * Indica si el usuario autenticado posee el rol de administrador.
     */
    private boolean esAdministrador(Authentication authentication) {
        return authentication.getAuthorities().stream()
                .anyMatch(a -> "ROLE_ADMINISTRADOR".equals(a.getAuthority()));
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

    @GetMapping("/editar")
    public String mostrarFormularioEditar(Authentication authentication,
                                          Model model,
                                          RedirectAttributes redirectAttributes) {

        if (esAdministrador(authentication)) {
            redirectAttributes.addFlashAttribute(
                    "error", "El administrador no posee datos personales");
            return "redirect:/cuenta/perfil";
        }

        Long idUsuario = contraseniaService.obtenerUsuario(authentication.getName()).getId();

        model.addAttribute("perfilDto", userService.obtenerPerfil(idUsuario));

        return "cuenta/editar-perfil";
    }

    @PostMapping("/editar")
    public String actualizarPerfil(
            @Valid @ModelAttribute("perfilDto") PerfilDto dto,
            BindingResult result,
            Authentication authentication,
            Model model,
            RedirectAttributes redirectAttributes) {

        if (esAdministrador(authentication)) {
            redirectAttributes.addFlashAttribute(
                    "error", "El administrador no posee datos personales");
            return "redirect:/cuenta/perfil";
        }

        if (result.hasErrors()) {
            return "cuenta/editar-perfil";
        }

        try {
            Long idUsuario = contraseniaService.obtenerUsuario(authentication.getName()).getId();

            userService.actualizarPerfil(idUsuario, dto);

            redirectAttributes.addFlashAttribute(
                    "exito", "Tus datos personales fueron actualizados correctamente.");

            return "redirect:/cuenta/perfil";

        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "cuenta/editar-perfil";
        }
    }

}
