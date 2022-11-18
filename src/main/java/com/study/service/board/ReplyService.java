package com.study.service.board;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.study.domain.board.ReplyDTO;
import com.study.mapper.board.ReplyMapper;

@Service
public class ReplyService {
	
	@Autowired
	private ReplyMapper mapper;

	public int addReply(ReplyDTO reply) {
		return mapper.insert(reply);
	}

	public List<ReplyDTO> listReplyByBoardId(int boardId, String username) {
		return mapper.selectReplyByBoardId(boardId, username);
	}

	public int removeById(int id) {
		return mapper.deleteById(id);
	}

	public ReplyDTO getById(int id) {
		return mapper.selectById(id);
	}

	public int modify(ReplyDTO reply) {
		return mapper.update(reply);
	}
}
