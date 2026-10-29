package com.unla.hito2.service;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.time.LocalDate;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.unla.hito2.dto.FestivalDto;
import com.unla.hito2.entity.Festival;
import com.unla.hito2.repository.FestivalRepository;

@ExtendWith(MockitoExtension.class)
public class FestivalServiceTest {

    @Mock
    private FestivalRepository festivalRepository;
    @InjectMocks
    private FestivalService festivalService;

    @Test
    void traerTodos_devuelveLosFestivalesDelRepositorio() {
        Festival festival = new Festival();
        festival.setId(1L);
        festival.setFechaInicio(LocalDate.now().minusDays(1));
        festival.setFechaFin(LocalDate.now().plusDays(2));
        festival.setNombre("Festival de prueba");

        when(festivalRepository.findAll()).thenReturn(List.of(festival));

        List<FestivalDto> resultado = festivalService.traerTodos();

        assertEquals(1, resultado.size());
        assertEquals(1L, resultado.get(0).getId());
        assertEquals("Festival de prueba", resultado.get(0).getNombre());

        verify(festivalRepository).findAll();
    }

}
