<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.net.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="my" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Insert title here</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi"
	crossorigin="anonymous" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css"
	integrity="sha512-xh6O/CkQoPOWDdYTDqeRdPCVd1SpvCA9XXcUnZS2FmJNp1coAFzvtCN9BmamE+4aHK8yyUHUSCcJHgXloTyT2A=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<style>
.custom-check.form-check-input:checked {
    background-color: #dc3545;
    border-color: #dc3545;
}
</style>
</head>
<body>
	<my:navBar></my:navBar>

	
	<div class="container-md">
		<div class="row">
			<div class="col">
			
				<h1>${board.id}번게시물 수정 </h1>
				
				<form id="modifyForm" action="" method="post" enctype="multipart/form-data">
					<input type="hidden" name="id" value="${board.id }">
					
					<div class="mb-3">
						<label class="form-label"> 제목 </label> 
						<input class="form-control" type="text" name="title" value="${board.title }">
					</div>
					
					<div class="mb-3">
						<label class="form-label"> 본문 </label>
						<textarea rows="5" class="form-control" name="content" readonly>${board.content }</textarea>
					</div>
					
					<!-- 이미지 출력 -->
						
					<div class="mb-3">
						<c:forEach items="${board.fileName }" var="name" varStatus="status">
	
							<div class="row">
								<div class="col-2 d-flex justify-content-center align-items-center" >
									<%-- 삭제 여부 체크박스 --%>
									
									<div class="form-check form-switch text-danger">
									  <input name="removeFiles" value="${name }" class="custom-check form-check-input" type="checkbox" role="switch" id="flexSwitchCheckChecked${status.count }" >
									  <label class="form-check-label" for="flexSwitchCheckChecked${status.count }"><i class="fa-regular fa-trash-can"></i></label>
									</div>
									
								</div>
								<div class="col-10">
									<div>
										<img class="img-fluid img-thumbnail" src="${imgUrl }/${board.id }/${URLEncoder.encode(name, 'utf-8')}" alt="">
									</div>
								</div>
							</div>
						</c:forEach>		
					</div>
					
					<div class="mb-3">
						<label for="" class="form-label">파일 추가</label>
						<input multiple type="file" accept="image/*" class="form-control" name="files">
						<div class="form-text" id="addFileInputText"></div>
					</div>
					
					<div class="mb-3">
						<label class="form-label"> 작성자 </label> 
						<input class="form-control" type="text" value="${board.writer}">
					</div>
					<div>
						<label class="form-label"> 작성일시 </label> 
						<input class="form-control" type="datetime-local" value="${board.inserted}" readonly>
					</div>
				</form>
				<input class="btn btn-warning" type="submit" value="수정" data-bs-toggle="modal" data-bs-target="#modifyModal">
				
				<c:url value="/board/remove" var="removeLink"></c:url>
				<form id="removeForm" action="${removeLink }" method="post">
					<input type="hidden" name="id" value="${board.id }">
				</form>
				<input class="btn btn-danger" type="submit" value="삭제" data-bs-toggle="modal" data-bs-target="#removeModal">
					
			</div>
		</div>
	</div>






	<!-- Modal -->
	<div class="modal fade" id="modifyModal" tabindex="-1"
		aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h1 class="modal-title fs-5" id="exampleModalLabel">수정</h1>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">수정하시겠습니까?</div>
				<div class="modal-footer">
					<button id="modifyConfirmButton" type="button"
						class="btn btn-secondary" data-bs-dismiss="modal">확인</button>
					<button type="button" class="btn btn-primary"
						data-bs-dismiss="modal">취소</button>
				</div>
			</div>
		</div>
	</div>


	<div class="modal fade" id="removeModal" tabindex="-1"
		aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h1 class="modal-title fs-5" id="exampleModalLabel">삭제</h1>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">삭제하시겠습니까?</div>
				<div class="modal-footer">
					<button id="removeConfirmButton" type="button"
						class="btn btn-secondary" data-bs-dismiss="modal">확인</button>
					<button type="button" class="btn btn-primary"
						data-bs-dismiss="modal">취소</button>
				</div>
			</div>
		</div>
	</div>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3"
		crossorigin="anonymous"></script>
	<script>
		document.querySelector(`#modifyForm input[name="files"]`).addEventListener("change", function() {
			const textDiv = document.querySelector("#addFileInputText");
			textDiv.innerText = "";
			
			let ok = false;
			
			const files = document.querySelector(`#modifyForm input[name="files"]`).files;
			console.log(files);
			
			const removeFileChecks = document.querySelectorAll(`#modifyForm input[name="removeFiles"]`);
			
			ok = Array.from(removeFileChecks).every((check) => Array.from(files).every((file) => file.name != check.value))
			
			if (!ok) {
				textDiv.innerText = "중복된 파일명이 있습니다.";
			}
		});
	
		document.querySelector("#modifyConfirmButton").addEventListener("click", function() {
			document.querySelector("#modifyForm").submit();
		});

		document.querySelector("#removeConfirmButton").addEventListener("click", function() {
			document.querySelector("#removeForm").submit();
		});
	</script>
</body>
</html>