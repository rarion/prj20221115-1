package com.study.domain.board;

import lombok.Data;

@Data
public class PageInfo {
	
	private int lastPageNumber;
	private int leftPageNumber;
	private int rightPageNumber;
	private int currentPageNumber;
	private boolean hasNextPageNumber;

}
