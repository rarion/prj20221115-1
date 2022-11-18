package com.study.service.member;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.study.domain.board.BoardDto;
import com.study.domain.member.MemberDTO;
import com.study.mapper.board.BoardMapper;
import com.study.mapper.board.ReplyMapper;
import com.study.mapper.member.MemberMapper;
import com.study.service.board.BoardService;

@Service
public class MemberService {

	@Autowired
	private MemberMapper memberMapper;
	
	@Autowired
	private ReplyMapper replyMapper;
	
	@Autowired
	private BoardMapper boardMapper;
	
	@Autowired
	private BoardService boardService;
	
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	
	public int insert(MemberDTO member) {
		
		String pw = member.getPassword();
		
		member.setPassword(passwordEncoder.encode(pw));
		
		
		return memberMapper.insert(member);
	}

	public List<MemberDTO> list() {
		
		return memberMapper.selectAll();
	}

	public MemberDTO get(String id) {
		
		return memberMapper.select(id);
	}
	
	public MemberDTO getEmail(String email) {
		
		return memberMapper.selectEmail(email);
	}

	public MemberDTO getNickName(String nickName) {
		
		return memberMapper.selectNickName(nickName);
	}

	public int update(MemberDTO member) {
		
		int cnt = 0;
		
		try {
			String pw = member.getPassword();
			member.setPassword(passwordEncoder.encode(pw));
			
			return memberMapper.update(member);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return cnt; 
	}

	public int remove(String id) {
		
		boardMapper.deleteLikeByMemberId(id);
		
		replyMapper.deleteByMemberId(id);
		
		List<BoardDto> list = boardMapper.listByMemberId(id);
		
		for (BoardDto board : list) {
			boardService.remove(board.getId());
		}

		
		return memberMapper.delete(id);
	}



	
}
