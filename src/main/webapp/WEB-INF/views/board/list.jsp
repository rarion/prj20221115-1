<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="my" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css" integrity="sha512-xh6O/CkQoPOWDdYTDqeRdPCVd1SpvCA9XXcUnZS2FmJNp1coAFzvtCN9BmamE+4aHK8yyUHUSCcJHgXloTyT2A==" crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body>
	<sec:authorize access="isAuthenticated()" var="loggedIn" />
	
	<my:navBar active="list"></my:navBar>
	
		
	<div class="container-md">
		<div class="row">
			<div class="col">

				<c:if test="${not empty message }">
					<div class="alert alert-success">
						${message }
					</div>
				</c:if>
				
				<h2>게시물 목록
					<c:url value="/board/register" var="registerLink"></c:url>
					<c:if test="${loggedIn }">
						<a href="${registerLink }">
							<i class="fa-solid fa-pencil"></i>
						</a>	
					</c:if>
					<c:url value="/member/login" var="loginLink"></c:url>
					<c:if test="${not loggedIn }">
						<a href="${loginLink }">
							<i class="fa-solid fa-pencil"></i>
						</a>
					</c:if>
				</h2>
				<table class="table" style="font-size: 14px">
					<thead>
						<tr>
							<th>#</th>
							<th><i class="fa-solid fa-thumbs-up"></i></th>
							<th>제목</th>
							<th>작성자</th>
							<th>작성일시</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${boardList}" var="board">
							<tr>
								<td>${board.id }</td>
								<td>${board.countLike}</td>
								<td>
									<c:url value="/board/get" var="getLink">
										<c:param name="id" value="${board.id }"></c:param>
									</c:url>
									<a href="${getLink }">
										${board.title }
									</a>

									<c:if test="${board.countReply > 0 }">
										<span class="badge rounded-pill text-bg-light">
											<i class="fa-regular fa-comment-dots"></i>
											${board.countReply }
										</span>
									</c:if>
									<c:if test="${board.countFile > 0 }">
										<span class="badge rounded-pill text-bg-light">
											<i class="fa-regular fa-file-image"></i>
											${board.countFile }
										</span>
									</c:if>
								</td>
								<td>${board.writer }</td>
								<td>${board.ago }</td>
							</tr>
						</c:forEach> 
					</tbody>
				</table>
			</div>
		</div>
	
		<div class="row" >
			<div class="col" style="width: 17px">
				<nav class="mt-3" aria-label="Page navigation example">
				  <ul class="pagination justify-content-center">
					<c:if test="${pageInfo.currentPageNumber != 1 }">
						<li class="page-item">
							<c:url value="/board/list" var="listLink">
					    		<c:param name="page" value="1"></c:param>
					    		<c:param name="q" value="${param.q }"></c:param>
					    		<c:param name="t" value="${param.t }"></c:param>
					    	</c:url>
							<a class="page-link" href="${listLink}" aria-label="first">
								<!-- &laquo -->
								<span aria-hidden="true"><i class="fa-solid fa-angles-left"></i></span>
							</a>
						</li>
					</c:if>
					<c:if test="${pageInfo.leftPageNumber != 1 }">
						<li class="page-item">
							<c:url value="/board/list" var="listLink">
					    		<c:param name="page" value="${pageInfo.currentPageNumber-1 }"></c:param>
					    		<c:param name="q" value="${param.q }"></c:param>
					    		<c:param name="t" value="${param.t }"></c:param>
					    	</c:url>
							<a class="page-link" href="${listLink}" aria-label="left">
								<!-- &lt -->
								<span aria-hidden="true"><i class="fa-solid fa-angle-left"></i></span>
							</a>
						</li>
					
					</c:if>
				    <c:forEach begin="${pageInfo.leftPageNumber}" end="${pageInfo.rightPageNumber }" var="pageNumber">
					    <c:url value="/board/list" var="listLink">
					    	<c:param name="page" value="${pageNumber }"></c:param>
					    	<c:param name="q" value="${param.q }"></c:param>
					    	<c:param name="t" value="${param.t }"></c:param>
					    </c:url>
				    	<li class="page-item ${pageInfo.currentPageNumber eq pageNumber ? 'active' : '' }">
				    		<a class="page-link" href="${listLink }">${pageNumber }</a>
				    	</li>
				    </c:forEach>
				    <c:if test="${pageInfo.rightPageNumber != ((pageInfo.lastPageNumber-1)/10*10) }">
				    	   <li class="page-item">
							<c:url value="/board/list" var="listLink">
					    		<c:param name="page" value="${pageInfo.currentPageNumber+1 }"></c:param>
					    		<c:param name="q" value="${param.q }"></c:param>
					    		<c:param name="t" value="${param.t }"></c:param>
					    	</c:url>
							<a class="page-link" href="${listLink}" aria-label="last">
								<!-- &gt -->
								<span aria-hidden="true"><i class="fa-solid fa-angle-right"></i></span>
							</a>
						</li>
				    </c:if>
				    <c:if test="${pageInfo.currentPageNumber != pageInfo.lastPageNumber }">
						<li class="page-item">
							<c:url value="/board/list" var="listLink">
					    		<c:param name="page" value="${pageInfo.lastPageNumber }"></c:param>
					    		<c:param name="q" value="${param.q }"></c:param>
					    		<c:param name="t" value="${param.t }"></c:param>
					    	</c:url>
							<a class="page-link" href="${listLink}" aria-label="last">
								 <!-- &raquo -->
								 <span aria-hidden="true"><i class="fa-solid fa-angles-right"></i></span>
							</a>
						</li>
					</c:if>
				  </ul>
				</nav>
			</div>
		</div>
	</div>
		
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
</body>
</html>









