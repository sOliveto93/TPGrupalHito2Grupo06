package com.unla.hito2.dto;

import java.math.BigDecimal;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class RentabilidadDto {
    private BigDecimal ingresos;
    private BigDecimal costosPlatos;
    private BigDecimal margen;
    private BigDecimal sueldos;
    private BigDecimal canon;
    private BigDecimal rentabilidadNeta;
}
