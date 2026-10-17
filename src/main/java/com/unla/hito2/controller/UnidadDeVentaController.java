package com.unla.hito2.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import com.unla.hito2.service.FestivalService;

import com.unla.hito2.dto.RegistroUnidadDto;
import com.unla.hito2.service.UnidadDeVentaService;

@Controller
@RequestMapping("/registro-unidad")
public class UnidadDeVentaController {

    private final UnidadDeVentaService unidadDeVentaService;

    private final FestivalService festivalService;

    public UnidadDeVentaController(UnidadDeVentaService unidadDeVentaService, FestivalService festivalService) {
        this.unidadDeVentaService = unidadDeVentaService;
        this.festivalService = festivalService;
    }

    // 1. Muestra el formulario de registro
    @GetMapping
    public String mostrarFormulario(Model model) {
        model.addAttribute("registroDto", new RegistroUnidadDto());
        model.addAttribute("festivales", festivalService.traerTodos());
        return "registro-unidad"; // Renderiza templates/registro-unidad.html
    }

    // 2. Recibe los datos y los guarda
    @PostMapping("/guardar")
    public String guardarUnidad(@ModelAttribute("registroDto") RegistroUnidadDto registroDto, Model model) throws Exception {
        try{
            unidadDeVentaService.registrarUnidadConResponsable(registroDto);
        } catch (Exception e) {
            model.addAttribute("error", "Error al registrar la unidad: " + e.getMessage());
        }
        return "redirect:/?exitoRegistro"; // Redirige al inicio con aviso de éxito
    }
}