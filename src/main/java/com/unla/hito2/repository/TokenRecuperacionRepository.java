package com.unla.hito2.repository;

import java.util.Optional;

import com.unla.hito2.entity.TokenRecuperacion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

@Repository
public interface TokenRecuperacionRepository
        extends JpaRepository<TokenRecuperacion, Long>{

    Optional<TokenRecuperacion> findByHuellaToken(String huellaToken);

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("""
        SELECT t FROM TokenRecuperacion t
        WHERE t.huellaToken = :huella
        """)
    Optional<TokenRecuperacion> buscarParaRestablecer(
            @Param("huella") String huella);

}
