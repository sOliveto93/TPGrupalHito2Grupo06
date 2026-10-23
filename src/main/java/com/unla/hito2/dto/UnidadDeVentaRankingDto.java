package com.unla.hito2.dto;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.unla.hito2.entity.CierreDeCaja;
import com.unla.hito2.entity.Pedido;
import com.unla.hito2.entity.Plato;
import com.unla.hito2.entity.Staff;

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
