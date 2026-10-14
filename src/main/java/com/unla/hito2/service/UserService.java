package com.unla.hito2.service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.unla.hito2.entity.UsuarioRol;
import com.unla.hito2.repository.UserRepository;


@Service("userService")
public class UserService implements UserDetailsService {

	private UserRepository userRepository;
	
	public UserService(UserRepository userRepository) {
		this.userRepository = userRepository;
	}

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		com.unla.hito2.entity.Usuario user = userRepository.findByUsernameAndFetchUsuarioRolesEagerly(username);
		return buildUser(user, buildGrantedAuthorities(user.getUsuarioRoles()));
	}

	private User buildUser(com.unla.hito2.entity.Usuario user, List<GrantedAuthority> grantedAuthorities) {
		return new User(user.getUsername(), user.getPassword(), user.isEnabled(),
						true, true, true, //accountNonExpired, credentialsNonExpired, accountNonLocked,
						grantedAuthorities);
	}

	private List<GrantedAuthority> buildGrantedAuthorities(Set<UsuarioRol> userRoles) {
		Set<GrantedAuthority> grantedAuthorities = new HashSet<>();
		for(UsuarioRol userRole: userRoles) {
			grantedAuthorities.add(new SimpleGrantedAuthority(userRole.getRol().toString()));
		}
		return new ArrayList<>(grantedAuthorities);
	}
}
