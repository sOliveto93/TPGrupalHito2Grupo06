package com.unla.hito2.controller;

import com.unla.hito2.dto.FestivalDto;
import com.unla.hito2.entity.Festival;
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
        List<FestivalDto> lista = festivalService.traerTodos();
        modelo.addObject("festivales", lista);

        if (authentication  != null &&
            authentication.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority()
                            .equals("ROLE_RESPONSABLE"))){

            try{
                modelo.addObject("miUnidad", unidadDeVentaService.buscarPorResponsable(
                        authentication.getName()));
            }catch (Exception e){
                modelo.addObject("errorUnidad", e.getMessage());
            }

        }

        return modelo;
    }
}