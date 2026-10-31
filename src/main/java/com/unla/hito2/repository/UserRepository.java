package com.unla.hito2.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.unla.hito2.entity.Usuario;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<Usuario, Long> {

    @Query("SELECT u FROM Usuario u LEFT JOIN FETCH u.usuarioRoles WHERE u.username = :username OR u.email = :username")
    Usuario findByUsernameAndFetchUsuarioRolesEagerly(@Param("username") String username);

    Optional<Usuario> findByUsernameOrEmail(String username, String email);
    Optional<Usuario> findByEmail(String email);

    boolean existsByEmail(String email);
}
