package com.study.mapper.member;

import java.util.List;

import com.study.domain.member.MemberDTO;

public interface MemberMapper {

	int insert(MemberDTO member);

	List<MemberDTO> selectAll();

	MemberDTO select(String id);

	MemberDTO selectEmail(String email);

	MemberDTO selectNickName(String nickName);

	int update(MemberDTO member);

	int delete(String id);



}
