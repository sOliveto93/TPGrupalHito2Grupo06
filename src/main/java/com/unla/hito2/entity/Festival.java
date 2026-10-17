package com.unla.hito2.entity;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.unla.hito2.Enum.Temporada;

import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter @Setter @NoArgsConstructor @AllArgsConstructor 
@Entity 
@Table (name = "festival")
public class Festival {

    @Id 
    @GeneratedValue (strategy = GenerationType.IDENTITY)
    private Long id;
    private String nombre;

    @Enumerated (EnumType.STRING)
    private Temporada temporada;

    private LocalDate fechaInicio;
    private LocalDate fechaFin;

    @OneToMany(mappedBy = "festival")
    private Set<UnidadDeVenta> unidadesDeVentas=new HashSet<>();

    @OneToMany(mappedBy = "festival")
    private List<CierreDeCaja> cierresDeCaja=new ArrayList<>();

    @OneToOne(fetch = FetchType.LAZY,optional = false)
    @JoinColumn(name = "costos_id", unique = true)
    private Costos costos;

}
