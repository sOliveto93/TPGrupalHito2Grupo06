package com.unla.hito2.controller;

import com.unla.hito2.dto.SolicitarRecuperacionDto;
import com.unla.hito2.service.RecuperacionContraseniaService;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.unla.hito2.dto.RestablecerContraseniaDto;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.mail.MailException;

@Controller
@RequestMapping("/recuperar-contrasenia")
public class RecuperarContraseniaController {

    private final RecuperacionContraseniaService recuperacionService;

    public RecuperarContraseniaController(
            RecuperacionContraseniaService recuperacionService) {

        this.recuperacionService = recuperacionService;
    }

    @GetMapping
    public String mostrarSolicitud(Model model) {
        model.addAttribute("solicitudDto", new SolicitarRecuperacionDto());
        return "cuenta/solicitar-recuperacion";
    }

    @PostMapping
    public String solicitarRecuperacion(
            @Valid @ModelAttribute("solicitudDto") SolicitarRecuperacionDto dto,
            BindingResult result,
            Model model,
            RedirectAttributes redirectAttributes) {

        if (result.hasErrors()) {
            return "cuenta/solicitar-recuperacion";
        }

        try {
            recuperacionService.solicitarRecuperacion(dto.getEmail());

        } catch (MailException e) {
            model.addAttribute(
                    "error",
                    "No pudimos procesar la solicitud. Intentá nuevamente más tarde.");

            return "cuenta/solicitar-recuperacion";
        }

        redirectAttributes.addFlashAttribute(
                "exito",
                "Si el correo está registrado y la cuenta está habilitada, "
                        + "recibirás un enlace para restablecer tu contraseña.");

        return "redirect:/recuperar-contrasenia";
    }

    @GetMapping("/restablecer")
    public String mostrarRestablecimiento(
            @RequestParam(required = false) String token,
            Model model) {

        RestablecerContraseniaDto dto = new RestablecerContraseniaDto();
        dto.setToken(token);

        model.addAttribute("restablecerDto", dto);

        try {
            recuperacionService.validarEnlace(token);
            model.addAttribute("enlaceValido", true);

        } catch (IllegalArgumentException e) {
            model.addAttribute("enlaceValido", false);
            model.addAttribute("error", e.getMessage());
        }

        return "cuenta/restablecer-contrasenia";
    }

    @PostMapping("/restablecer")
    public String restablecerContrasenia(
            @Valid @ModelAttribute("restablecerDto") RestablecerContraseniaDto dto,
            BindingResult result,
            Model model,
            RedirectAttributes redirectAttributes) {

        model.addAttribute("enlaceValido", true);

        try {
            recuperacionService.validarEnlace(dto.getToken());
        } catch (IllegalArgumentException e) {
            model.addAttribute("enlaceValido", false);
            model.addAttribute("error", e.getMessage());
            return "cuenta/restablecer-contrasenia";
        }

        if (result.hasErrors()) {
            return "cuenta/restablecer-contrasenia";
        }

        if (!dto.getNuevaContrasenia().equals(dto.getConfirmarContrasenia())) {
            result.rejectValue(
                    "confirmarContrasenia",
                    "contrasenias.distintas",
                    "La nueva contraseña y su confirmación no coinciden.");

            return "cuenta/restablecer-contrasenia";
        }

        try {
            recuperacionService.restablecerContrasenia(dto);

            redirectAttributes.addFlashAttribute(
                    "exito",
                    "Contraseña actualizada. Ya podés iniciar sesión.");

            return "redirect:/login";

        } catch (IllegalArgumentException e) {
            model.addAttribute("enlaceValido", false);
            model.addAttribute("error", e.getMessage());

            return "cuenta/restablecer-contrasenia";
        }
    }

}
