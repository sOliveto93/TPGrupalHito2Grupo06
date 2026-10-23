package com.unla.hito2.dto;

import java.time.LocalDate;

import com.unla.hito2.Enum.Temporada;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@AllArgsConstructor @NoArgsConstructor 
@Getter @Setter 
public class FestivalDto {

   
    private Long id;
    private String nombre;

   
    private Temporada temporada;

    private LocalDate fechaInicio;
    private LocalDate fechaFin;
    private String estado;
    
   
}
