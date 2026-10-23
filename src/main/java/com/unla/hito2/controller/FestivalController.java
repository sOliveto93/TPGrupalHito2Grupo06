package com.unla.hito2.controller;

import java.time.LocalDate;
import java.util.List;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.unla.hito2.dto.FestivalDto;
import com.unla.hito2.service.FestivalService;

@Controller
@RequestMapping("/festival")
public class FestivalController {

    FestivalService festivalService;

    public FestivalController(FestivalService festivalService) {
        this.festivalService = festivalService;
    }

    @GetMapping("/filtro")
    @PreAuthorize("hasRole('ADMINISTRADOR')")
    public ModelAndView filtrarFestivales(
            @RequestParam(required = false) String nombre,
            @RequestParam(required = false) String temporada,
            @RequestParam(required = false) String estado,
            @RequestParam(required = false) LocalDate fechaInicio,
            @RequestParam(required = false) LocalDate fechaFin) {

        ModelAndView vista = new ModelAndView("/administrador/index");

        List<FestivalDto> lista = festivalService.filtrarFestivales(
                nombre, temporada, estado, fechaInicio, fechaFin);

        vista.addObject("festivales", lista);
        vista.addObject("filtroNombre", nombre);
        vista.addObject("filtroTemporada", temporada);
        vista.addObject("filtroEstado", estado);
        vista.addObject("filtroFechaInicio", fechaInicio);
        vista.addObject("filtroFechaFin", fechaFin);

        return vista;
    }
}
