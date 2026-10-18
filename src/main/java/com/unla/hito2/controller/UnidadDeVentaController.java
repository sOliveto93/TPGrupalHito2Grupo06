package com.unla.hito2.controller;

import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import com.unla.hito2.service.FestivalService;

import com.unla.hito2.dto.RegistroUnidadDto;
import com.unla.hito2.service.UnidadDeVentaService;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/registro-unidad")
public class UnidadDeVentaController {

    private final UnidadDeVentaService unidadDeVentaService;

    private final FestivalService festivalService;

    public UnidadDeVentaController(UnidadDeVentaService unidadDeVentaService, FestivalService festivalService) {
        this.unidadDeVentaService = unidadDeVentaService;
        this.festivalService = festivalService;
    }

    @GetMapping
    public String mostrarFormulario(Model model) {
        model.addAttribute("registroDto", new RegistroUnidadDto());
        model.addAttribute("festivales", festivalService.traerTodos());
        return "registro-unidad"; // Renderiza templates/registro-unidad.html
    }

    @PostMapping("/guardar")
    public String guardarUnidad(@Valid @ModelAttribute("registroDto") RegistroUnidadDto dto,
                                BindingResult result,
                                RedirectAttributes redirect,
                                Model model) {

        if (result.hasErrors()) {
            model.addAttribute("festivales", festivalService.traerTodos());
            return "registro-unidad";
        }

        try {
            unidadDeVentaService.registrarUnidadConResponsable(dto);
            redirect.addFlashAttribute("exito", "¡Unidad de Venta y Responsable registrados con éxito!");
            return "redirect:/registro-unidad";
        } catch (Exception e) {
            // Captura las excepciones tiradas por el Service (DNI repetido, menor de edad, etc.)
            model.addAttribute("error", e.getMessage());
            model.addAttribute("festivales", festivalService.traerTodos());
            return "registro-unidad";
        }
    }
}