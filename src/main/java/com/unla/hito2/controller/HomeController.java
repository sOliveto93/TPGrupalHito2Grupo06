package com.unla.hito2.controller;

import com.unla.hito2.dto.FestivalDto;
import com.unla.hito2.service.FestivalService;

import com.unla.hito2.service.UnidadDeVentaService;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.security.core.Authentication;

import java.util.List;

@Controller
@RequestMapping("/")
public class HomeController {

    private final FestivalService festivalService;
    private final UnidadDeVentaService unidadDeVentaService;

    public HomeController(FestivalService festivalService,
            UnidadDeVentaService unidadDeVentaService) {
        this.festivalService = festivalService;
        this.unidadDeVentaService = unidadDeVentaService;
    }

    @GetMapping
    public ModelAndView home(Authentication authentication) {
        ModelAndView modelo = new ModelAndView("index");
        List<FestivalDto> lista = festivalService.traerActivosYProximos();
        modelo.addObject("festivales", lista);

        return modelo;
    }

    @GetMapping("/home")
    public String redirigirHome(Authentication authentication) {

        boolean esResponsable = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_RESPONSABLE"));

        boolean esEmpleado = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_EMPLEADO"));

        boolean esAdministrador = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMINISTRADOR"));

        if (esResponsable) {
            return "redirect:/responsable/home";
        } else if (esEmpleado) {
            return "redirect:/empleado/home";
        } else if (esAdministrador) {
            return "redirect:/administrador/home";
        }

        return "redirect:/";
    }

    @GetMapping("/responsable/home")
    @PreAuthorize("hasRole('RESPONSABLE')")
    public ModelAndView homeResponsable(Authentication authentication) {
        ModelAndView vista = new ModelAndView("/responsable/index");

        try {
            vista.addObject("miUnidad", unidadDeVentaService.buscarPorResponsable(
                    authentication.getName()));
        } catch (Exception e) {
            vista.addObject("errorUnidad", e.getMessage());
        }

        return vista;
    }

    @GetMapping("/empleado/home")
    @PreAuthorize("hasRole('EMPLEADO')")
    public ModelAndView homeEmpleado(Authentication authentication) {
        ModelAndView vista = new ModelAndView("/empleado/index");

        try {
            vista.addObject("miUnidad",
                    unidadDeVentaService.buscarPorEmpleado(authentication.getName()));
        } catch (Exception e) {
            vista.addObject("errorUnidad",
                    "No tenés una unidad de venta asignada.");
        }

        return vista;
    }

    @GetMapping("/administrador/home")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ModelAndView homeAdministrador(Authentication authentication) {
        ModelAndView vista = new ModelAndView("/administrador/index");

        List<FestivalDto> lista = festivalService.traerTodos();
        vista.addObject("festivales", lista);

        return vista;
    }
}