package com.unla.hito2.controller;

import com.unla.hito2.dto.AltaPlatoDto;
import com.unla.hito2.dto.FestivalDto;
import com.unla.hito2.dto.PlatoEstrellaDto;
import com.unla.hito2.dto.pedido.PlatoPedidoDto;
import com.unla.hito2.entity.UnidadDeVenta;
import com.unla.hito2.service.FestivalService;
import com.unla.hito2.service.PlatoService;
import com.unla.hito2.service.UnidadDeVentaService;
import jakarta.validation.Valid;

import java.util.List;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/plato")
@PreAuthorize("hasAnyRole('RESPONSABLE','ADMINISTRADOR')")
public class PlatoController {

    private final PlatoService platoService;
    private final UnidadDeVentaService unidadDeVentaService;
    private FestivalService festivalService;
    public PlatoController(PlatoService platoService, UnidadDeVentaService unidadDeVentaService,FestivalService festivalService) {

        this.platoService = platoService;
        this.unidadDeVentaService = unidadDeVentaService;
        this.festivalService= festivalService;
    }

    @GetMapping("/alta")
    @PreAuthorize("hasRole('RESPONSABLE')")
    public String mostrarFormularioAlta(Model model) {

        model.addAttribute("altaPlatoDto", new AltaPlatoDto());
        return "plato/formulario";
    }

    @PostMapping("/alta")
    @PreAuthorize("hasRole('RESPONSABLE')")
    public String registrarPlato(
            @Valid @ModelAttribute("altaPlatoDto") AltaPlatoDto dto,
            BindingResult result,
            Authentication authentication,
            Model model,
            RedirectAttributes redirectAttributes) {

        if (result.hasErrors()) {
            return "plato/formulario";
        }

        try {
            String username = authentication.getName();

            UnidadDeVenta unidadDeVenta = unidadDeVentaService.buscarPorResponsable(username);

            platoService.registrarPlato(dto, unidadDeVenta);

            redirectAttributes.addFlashAttribute("exito", "Plato registrado con éxito.");
            return "redirect:/plato/alta";

        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
        }

        return "plato/formulario";
    }

    @GetMapping("/reporte-plato-estrella")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ModelAndView reportePlatoEstrella(@RequestParam Long id) {
        ModelAndView vista=new ModelAndView("plato/reportePlatoEstrella");

        List<PlatoEstrellaDto> platoEstrella= platoService.traerPlatosEstrellaFestival(id);
        FestivalDto festival = festivalService.traerFestivalPorId(id);
        vista.addObject("platoEstrella",platoEstrella);
        vista.addObject("festival",festival);
        return vista;
    }

}
