package com.unla.hito2.entity;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity 
@Table (name = "pedido")
public class Pedido {
 @Id 
    @GeneratedValue (strategy = GenerationType.IDENTITY)
    private Long id;
    private LocalDateTime fechaHora;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "unidad_venta_id", nullable = false)
    private UnidadDeVenta unidadDeVenta;

    @OneToMany(mappedBy = "pedido")
    private  List<DetallePedido> detalles=new ArrayList<>();

}
