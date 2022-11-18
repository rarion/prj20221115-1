package com.study.mapper.board;

import java.util.List;

import com.study.domain.board.ReplyDTO;

public interface ReplyMapper {

	int insert(ReplyDTO reply);

	List<ReplyDTO> selectReplyByBoardId(int boardId, String username);

	int deleteById(int id);
	
	ReplyDTO selectById(int id);

	int update(ReplyDTO reply);

	int deleteByBoardId(int id);

	int deleteByMemberId(String id);

}
