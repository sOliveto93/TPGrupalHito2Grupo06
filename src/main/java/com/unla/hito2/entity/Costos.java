package com.unla.hito2.entity;

import java.math.BigDecimal;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor 
@Entity 
@Table (name = "costos")
public class Costos {

    @Id 
    @GeneratedValue (strategy = GenerationType.IDENTITY)
    private Long id;
    private BigDecimal costoPorMetroCuadrado;
    private BigDecimal costoPorMinutoMontaje;
    private BigDecimal plusElectricidad;
    private BigDecimal sueldoBase;
    private BigDecimal plusAnualAntiguedad;
    private BigDecimal plusCocinero;
    private BigDecimal plusAyudanteCocina;
    private BigDecimal plusLavaplatos;

    //preguntar si hace falta la relacion hacia festival..no la veo necesario asique no la agrego por ahora

}
