package com.study.service.board;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import com.study.domain.board.BoardDto;
import com.study.domain.board.PageInfo;
import com.study.mapper.board.BoardMapper;
import com.study.mapper.board.ReplyMapper;

import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.DeleteObjectRequest;
import software.amazon.awssdk.services.s3.model.ObjectCannedACL;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;

@Service
@Transactional
public class BoardService {

	@Autowired
	private BoardMapper boardMapper;
	
	@Autowired
	private ReplyMapper replyMapper;
	
	@Autowired
	private S3Client s3Client;
	
	@Value("${aws.s3.bucket}")
	private String bucketName;
	
	public int register(BoardDto board, MultipartFile[] files) {
		int cnt = boardMapper.insert(board);
		
		for (MultipartFile file : files) {
			
			if (file != null && file.getSize() > 0) {
				boardMapper.insertFile(board.getId(), file.getOriginalFilename());			
				
				uploadFile(board.getId(), file);
			}
		}
		
		return cnt;
	}

	private void uploadFile(int id, MultipartFile file) {
		try {
			// S3에 파일 저장
			// 키 생성
			String key = "prj1/board/" + id + "/" + file.getOriginalFilename();
			
			// putObjectRequest
			PutObjectRequest putObjectRequest = PutObjectRequest.builder()
					.bucket(bucketName)
					.key(key)
					.acl(ObjectCannedACL.PUBLIC_READ)
					.build();
			
			// requestBody
			RequestBody requestBody = RequestBody.fromInputStream(file.getInputStream(), file.getSize());
			
			// object(파일) 올리기
			s3Client.putObject(putObjectRequest, requestBody);
			
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		}
	}

	public List<BoardDto> listBoard(int page, String type, String keyword, PageInfo pageInfo) {
		int records = 10;
		int offset = (page - 1) * records;
	
		
		int countAll = boardMapper.countAll("%"+keyword+"%", type); // SELECT Count(*) FROM Board
		int lastPage = (countAll - 1) / records + 1;
		
		
		int leftPageNumber = (page - 1) / 10 * 10 + 1;
		int rightPageNumber = leftPageNumber + 9;
		int currentPageNumber = page;
		rightPageNumber = Math.min(rightPageNumber, lastPage);
		boolean hasNextPageNumber = page <= ((lastPage-1)/10*10);
		
		pageInfo.setHasNextPageNumber(hasNextPageNumber);
		pageInfo.setCurrentPageNumber(currentPageNumber);
		pageInfo.setLeftPageNumber(leftPageNumber);
		pageInfo.setRightPageNumber(rightPageNumber);
		pageInfo.setLastPageNumber(lastPage);
		
		return boardMapper.list(offset, records, type, "%" + keyword + "%");
	}

	public BoardDto get(int id, String username) {
		return boardMapper.select(id, username);
	}

	
	public int update(BoardDto board, MultipartFile[] addFiles, List<String> removeFiles) {
		
		
		
		if (removeFiles != null)
		for (String fileName : removeFiles) {
			
			
			boardMapper.deleteFileByBoardIdAndFileName(board.getId(), fileName);
									
			deleteFile(board.getId(), fileName);

		};
		
		for (MultipartFile file : addFiles) {
			
			boardMapper.deleteFileByBoardIdAndFileName(board.getId(), file.getOriginalFilename());
			
			
			if (file != null && file.getSize() > 0) {
				
				boardMapper.insertFile(board.getId(), file.getOriginalFilename());			
				
				uploadFile(board.getId(), file);
				
				
			}
		}
		
		
		return boardMapper.update(board);
		
	}
	public int remove(int id) {
		BoardDto board = boardMapper.select(id);
		List<String> fileNames = board.getFileName();
		
		if (fileNames != null) {
			for (String fileName : fileNames) {
				deleteFile(id, fileName);
			}
		}
	
		boardMapper.deleteLikeByBoardId(id);
		
		boardMapper.deleteFileByBoardId(id);
		
		replyMapper.deleteByBoardId(id);
		
		return boardMapper.delete(id);
	}
	

	private void deleteFile(int id, String fileName) {
		String key = "prj1/board/" + id + "/" + fileName;
		DeleteObjectRequest deleteObjectRequest = DeleteObjectRequest.builder()
				.bucket(bucketName)
				.key(key)
				.build();
		s3Client.deleteObject(deleteObjectRequest);
	}

	public Map<String, Object> updateLike(String boardId, String memberId) {
		
		Map<String, Object> map = new HashMap<>();
		
		int cnt = boardMapper.getLikeByBoardIdAndMemberId(boardId, memberId);
		
		if(cnt == 1) {
			boardMapper.deleteLike(boardId, memberId);
			map.put("current", "not liked");			
		}else {
			boardMapper.insertLike(boardId, memberId);
			map.put("current", "liked");
		}
		
		int countAll = boardMapper.countLikeByBoardId(boardId);
		map.put("count", countAll);
		
		return map;
	}
	
	public BoardDto get(int id) {
		return get(id, null);
	}


	
}
