package com.unla.hito2.controller;

import com.unla.hito2.entity.Festival;
import com.unla.hito2.service.FestivalService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Controller
@RequestMapping("/")
public class HomeController {

    private final FestivalService festivalService;

    public HomeController(FestivalService festivalService) {
        this.festivalService = festivalService;
    }

    @GetMapping
    public ModelAndView home() {
        ModelAndView modelo = new ModelAndView("index");
        List<Festival> lista = festivalService.traerTodos();
        modelo.addObject("festivales", lista);
        return modelo;
    }
}