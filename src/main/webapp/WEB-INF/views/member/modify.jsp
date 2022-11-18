<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
	<my:navBar></my:navBar>
	
	<div class="container-md">
		<div class="row">
			<div class="col">
			
				<c:if test="${not empty message }">
					<div id="message" class="alert alert-success">
						${message }
					</div>
				</c:if>
				
				<h1>회원 정보 수정</h1>
			
		<form id="modifyForm" action="" method="post">
				
					<div class="mb-3">
						<label for="" class="form-label">
							아이디 
						</label>
						<input class="form-control-plaintext" type="text" value="${member.id }" readonly>
					</div>
					
					<div class="mb-3">
						<label for="" class="form-label">
							닉네임
						</label>
						<div class="input-group">
							<input class="form-control" type="text" name="nickName" value="${member.nickName }" id="nickNameInput" data-old-value="${member.nickName }">
							<button disabled id="nickNameExistButton" type="button" class="btn btn-outline-secondary">중복확인</button>
						</div>
						<div id="nickNameMessage" class="form-text"></div>
					</div>
					
					<div class="mb-3">
						<label for="" class="form-label">
							새 비밀번호
						</label>
						<input id="passwordInput1" class="form-control" type="password" name="password">
						<div id="passwordText" class="form-text"></div>
					</div>
					
					<div class="mb-3">
						<label for="" class="form-label">
							새 비밀번호 확인
						</label>
						<input id="passwordInput2" class="form-control" type="password">
					</div>
					
					<div class="mb-3">
						<label for="" class="form-label">
							이메일 
						</label>
						<div class="input-group">
							<input id="emailInput" class="form-control" type="email" value="${member.email }" name="email" data-old-value="${member.email }">
							<button disabled id="emailExistButton" type="button" class="btn btn-outline-secondary">중복확인</button>
						</div>
						<div id="emailText" class="form-text"></div>
					</div>
					<div class="mb-3">
						<label for="" class="form-label">
							가입일시 
						</label>
						<input class="form-control-plaintext" type="text" value="${member.inserted }" readonly>
					</div>
				
					<input type="hidden" name="oldPassword">
				</form>
				<input disabled id="submitButton" class="btn btn-warning" type="submit" value="수정" data-bs-toggle="modal" data-bs-target="#modifyModal">
				
				<input id="cancelButton" class="btn btn-light" type="submit" value="취소">
				
				<c:url value="/member/cancel" var="cancelLink"></c:url>
				<form id="cancelForm" action="${cancelLink }" method="post">
					<input type="hidden" name="id" value="${member.id }">
				</form>
		
			</div>
		</div>
	</div>


	
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
	

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
<script>
	let availableNickName = true;
	let availableEmail = true;
	let availablePassword = true;
	
	enableSubmitButton();
	
	function enableSubmitButton(){
		const button = document.querySelector("#submitButton");
		if(availableNickName && availableEmail && availablePassword){
			button.removeAttribute("disabled");
		}else {
			button.setAttribute("disabled", "");
		}
	}
	
	const ctx = "${pageContext.request.contextPath}";
	
	document.querySelector("#nickNameInput").addEventListener("keyup", function(){
		availableNickName = false;
		const oldValue = nickNameInput.dataset.oldValue;
		const newValue = nickNameInput.value;
		
		if(oldValue == newValue){
			availableNickName = true;
			document.querySelector("#nickNameMessage").innerText = "";
			document.querySelector("#nickNameExistButton").setAttribute("disabled", "");
			enableSubmitButton();		
		} else {
			document.querySelector("#nickNameMessage").innerText = "닉네임 중복확인을 해주세요.";
			nickNameExistButton.removeAttribute("disabled");
		}
		enableSubmitButton();
	});
	
	document.querySelector("#nickNameExistButton").addEventListener("click", function(){
		availableNickName = false;
		
		const nickName = document.querySelector("#nickNameInput").value;
		
		fetch(ctx + "/member/existNickName/" + nickName)
			.then(res => res.json())
			.then(data => {
				document.querySelector("#nickNameMessage").innerText = data.message;
				
				if(data.status == "not exist"){
					availableNickName = true;
					enableSubmitButton();
				}
			});
		
	});

	
	document.querySelector("#emailInput").addEventListener("keyup", function(){
		availableEmail = false;
		const oldValue = emailInput.dataset.oldValue;
		const newValue = emailInput.value;
		
		if(oldValue == newValue){
			document.querySelector("#emailText").innerText = "";
			document.querySelector("#emailExistButton").setAttribute("disabled", "disabled");
			availableEmail = true;
			enableSubmitButton();
			
		}else {
			document.querySelector("#emailText").innerText = "이메일 중복확인을 해주세요.";
			emailExistButton.removeAttribute("disabled");
		}
		enableSubmitButton();
	});
	
	
	document.querySelector("#emailExistButton").addEventListener("click", function(){ 
		availableEmail = false;
		const email = document.querySelector("#emailInput").value;
		
		fetch(ctx + "/member/existEmail", {
			method : "post",
			headers : {
				"Content-Type" : "application/json"
			},
			body : JSON.stringify({email})
		})
			.then(res => res.json())
			.then(data => {
				document.querySelector("#emailText").innerText = data.message;
				
				if (data.status == "not exist") {
					availableEmail = true;
					enableSubmitButton();
				}
			});
	});
	
	

	
	const passwordInput1 = document.querySelector("#passwordInput1");
	const passwordInput2 = document.querySelector("#passwordInput2");
	const passwordText = document.querySelector("#passwordText");
	
	function matchPassword() {
		
		const value1 = passwordInput1.value;
		const value2 = passwordInput2.value;
		
		if (value1 == value2) {
			passwordText.innerText = "패스워드가 일치합니다.";
			availablePassword = true;
		} else {
			passwordText.innerText = "패스워드가 일치하지 않습니다.";
			availablePassword = false;
		}
		
		enableSubmitButton();
		
	}
	
	
	document.querySelector("#passwordInput1").addEventListener("keyup", matchPassword);
	
	document.querySelector("#passwordInput2").addEventListener("keyup", matchPassword);
		
	document.querySelector("#modifyConfirmButton").addEventListener("click", function() {

		document.querySelector("#modifyForm").submit();
	
	});
	
	document.querySelector("#cancelButton").addEventListener("click", function() {
		document.querySelector("#cancelForm").submit();
	});
</script>
</body>
</html>