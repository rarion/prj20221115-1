package com.study.domain.board;

import java.time.LocalDateTime;
import java.time.Period;
import java.time.temporal.ChronoUnit;
import java.util.List;

import lombok.Data;

@Data
public class BoardDto {
	private int id;
	private String title;
	private String content;
	private String writer;
	private LocalDateTime inserted;
	private int countReply;
	private int countFile;
	private int countLike;
	
	private boolean liked;
	
	private List<String> fileName;
	
	public String getAgo() {
		LocalDateTime now = LocalDateTime.now();
		LocalDateTime oneDayBefore = now.minusDays(1);
		LocalDateTime oneMonthBefore = now.minusMonths(1);
		LocalDateTime oneYearBefore = now.minusYears(1);
		
		String result = "";
		
		if (oneDayBefore.isBefore(inserted)) {
			result = inserted.toLocalTime().toString();
		} else if (oneMonthBefore.isBefore(inserted)) {
			result = Period.between(inserted.toLocalDate(), now.toLocalDate())
						.getDays() + "일 전";
		} else if (oneYearBefore.isBefore(inserted)) {
			result = Period.between(inserted.toLocalDate(), now.toLocalDate())
					.get(ChronoUnit.MONTHS) + "달 전";
		} else {
			result = Period.between(inserted.toLocalDate(), now.toLocalDate())
					.getYears() + "년 전";
		}
		
		return result;
	}

}
