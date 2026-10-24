package com.unla.hito2.service;

import com.unla.hito2.dto.FestivalDto;
import com.unla.hito2.entity.Festival;
import com.unla.hito2.repository.FestivalRepository;

import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Service
public class FestivalService {

    private final FestivalRepository festivalRepository;

    public FestivalService(FestivalRepository festivalRepository) {
        this.festivalRepository = festivalRepository;
    }

    public List<FestivalDto> traerActivosYProximos() {
        LocalDate hoy = LocalDate.now();

        List<Festival> lista = festivalRepository.findByFechaFinGreaterThanEqualOrderByFechaInicioAsc(hoy);

        List<FestivalDto> dtos = new ArrayList<>();

        for (Festival festival : lista) {
            FestivalDto dto = festivalToDto(festival);

            dtos.add(dto);
        }

        return dtos;
    }

    public List<FestivalDto> buscarEntreFechas(LocalDate inicio, LocalDate fin) {

        if (inicio != null && fin != null && inicio.isAfter(fin)) {
            throw new IllegalArgumentException(
                    "La fecha de inicio no puede ser posterior a la fecha de fin");
        }

        List<Festival> lista = festivalRepository.buscarEntreFechas(inicio, fin);
        List<FestivalDto> dtos = new ArrayList<>();

        for (Festival festival : lista) {
            dtos.add(festivalToDto(festival));
        }

        return dtos;
    }

    public List<FestivalDto> traerTodos() {
        List<Festival> lista = festivalRepository.findAll();
        List<FestivalDto> dtos = new ArrayList<>();

        for (Festival festival : lista) {
            dtos.add(festivalToDto(festival));
        }

        return dtos;
    }

    public FestivalDto traerFestivalPorId(Long id) {
        Festival festival = festivalRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException(
                        "No se encontró un festival con id: " + id));

        return festivalToDto(festival);
    }

    private FestivalDto festivalToDto(Festival festival) {
        FestivalDto dto = new FestivalDto();
        LocalDate hoy = LocalDate.now();
        dto.setId(festival.getId());
        dto.setNombre(festival.getNombre());
        dto.setTemporada(festival.getTemporada());
        dto.setFechaInicio(festival.getFechaInicio());
        dto.setFechaFin(festival.getFechaFin());

        if (hoy.isBefore(festival.getFechaInicio())) {
            dto.setEstado("PRÓXIMO");
        } else if (!hoy.isAfter(festival.getFechaFin())) {
            dto.setEstado("ACTIVO");
        } else {
            dto.setEstado("FINALIZADO");
        }
        return dto;
    }

    public List<FestivalDto> filtrarFestivales(
            String nombre,
            String temporada,
            String estado,
            LocalDate fechaInicio,
            LocalDate fechaFin) {

        if (fechaInicio != null && fechaFin != null
                && fechaInicio.isAfter(fechaFin)) {
            throw new IllegalArgumentException(
                    "La fecha de inicio no puede ser posterior a la fecha de fin");
        }

        if (nombre != null) {
            nombre = nombre.trim();
            if (nombre.isEmpty()) {
                nombre = null;
            }
        }

        if (temporada != null) {
            temporada = temporada.trim();
            if (temporada.isEmpty()) {
                temporada = null;
            }
        }

        List<Festival> festivales = festivalRepository.filtrarFestivales(
                nombre, temporada, fechaInicio, fechaFin);

        List<FestivalDto> resultado = new ArrayList<>();

        for (Festival festival : festivales) {
            FestivalDto dto = festivalToDto(festival);
            // filtramos aca porque esto es un parametro calculado
            if (estado == null || estado.isBlank()
                    || estado.equals(dto.getEstado())) {
                resultado.add(dto);
            }
        }

        return resultado;
    }
}