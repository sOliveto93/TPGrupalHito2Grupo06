package com.unla.hito2.dto;

import java.math.BigDecimal;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class UnidadDeVentaRankingDto {

    private Long id;
    private String nombreComercial;
    private String codigo;
    private BigDecimal ingresos;
}
