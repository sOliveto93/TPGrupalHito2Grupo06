package com.unla.hito2.controller;

import jakarta.validation.Valid;

import java.util.List;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.unla.hito2.service.FestivalService;
import com.unla.hito2.dto.RegistroUnidadDto;
import com.unla.hito2.dto.UnidadDeVentaDto;
import com.unla.hito2.service.UnidadDeVentaService;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/unidad-venta")
@PreAuthorize("hasAnyRole('ADMINISTRADOR')")
public class UnidadDeVentaController {

    private final UnidadDeVentaService unidadDeVentaService;

    private final FestivalService festivalService;
    public UnidadDeVentaController(UnidadDeVentaService unidadDeVentaService, FestivalService festivalService) {
        this.unidadDeVentaService = unidadDeVentaService;
        this.festivalService = festivalService;
    }

    @GetMapping("registro-unidad")
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
            return "redirect:/unidad-venta/registro-unidad";

        } catch (Exception e) {
            // Captura las excepciones tiradas por el Service (DNI repetido, menor de edad, etc.)
            model.addAttribute("error", e.getMessage());
            model.addAttribute("festivales", festivalService.traerTodos());
            return "registro-unidad";
        }
    }

    @PreAuthorize("hasRole('ADMINISTRADOR')")
    @GetMapping ("/unidad-venta-por-festival")
    public  ModelAndView mostrarUnidadesporFestival(  @RequestParam("id") Long id){
        ModelAndView vista=new ModelAndView("/festival/index.html");
        List<UnidadDeVentaDto>lista=unidadDeVentaService.buscarPorFestival(id);
        vista.addObject("lista", lista);
        return vista;

    }
}