package com.unla.hito2.dto;

import java.time.LocalDate;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UnidadHistorialDto {

    private String nombreUnidad;
    private boolean actual;
    private String nombreFestival;
    private LocalDate fechaInicioFestival;
    private LocalDate fechaFinFestival;
}
