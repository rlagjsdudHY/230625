<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@	taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@	taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@	taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@	taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<sql:setDataSource
	url="jdbc:mysql://localhost:3306/el_jstl_shop?useSSL=false&serverTimezone=Asia/Seoul&useUnicode=true&characterEncoding=UTF-8&allowPublicKeyRetrieval=true"
	driver="com.mysql.cj.jdbc.Driver" user="root" password="1234" var="db"
	scope="application" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>Document</title>
<link rel="stylesheet" href="/style/style.css">
<style>
div#wrap {
	width: 600px;
	height: 300px;
	padding: 10px;
	border: 3px solid #aaa;
	border-radius: 6px;
	margin: 30px auto;
}

hr {
	margin: 20px 0px;
}

.dFlex {
	display: flex;
}

.dFlex span {
	text-align: center;
	padding: 8px 4px;
	border-bottom: 1px solid #000;
}

.dFlex>span:nth-child(1) {
	width: 60px;
}

.dFlex>span:nth-child(2) {
	width: 110px;
}

.dFlex>span:nth-child(3) {
	width: 60px;
}

.dFlex>span:nth-child(4) {
	flex: 1;
}

div.listHeader {
	font-size: 18px;
	font-weight: bold;
	background-color: rgba(0, 136, 255, 0.1);
}

div#ds>span {
	
}
#serchform { float:right; }
</style>
</head>
<body>
	<div id="wrap">
		<h1></h1>
		<hr>
		<sql:query var="lists" dataSource="${db}">
    select num, userID, userAge, DATE_FORMAT(joinTM, '%Y-%m-%d') as joindate from memberList order by num
</sql:query>


		<div class="dFlex listHeader">
			<input type="checkbox" id="chkAll">
			<span>번호</span> <span>ID</span> <span>Age</span> <span>가입 시간</span>
		</div>

		<c:forEach var="member" items="${lists.rows}">
  <c:if test="${fn:containsIgnoreCase(member.userID, param.searchId)}">
    <div id="ds" class="dFlex">
      <input type="checkbox" name="chk">
      <span>${member.num}</span> 
      <span class="uid">${member.userID}</span> 
      <span>${member.userAge}</span>
      <span>${member.joindate}</span>
      <button id="del${member.num}" class="delb" onclick="getdel('${member.userID}')">X</button>
    </div>
  </c:if>
</c:forEach>
		
		<div id="serchform">
			ID 조회 <input type="text" id="searchId">
			<button type="button" id="searchBtn">검색</button>
			<button type="button" id="deleteSelected">선택 항목 삭제</button>
			<c:out value="${param.delID}" />
		</div>
	</div>
	
		<c:if test="${not empty param.delID}">
  <sql:update var="delList" dataSource="${db}">
   delete from memberList where userID IN (${fn:replace(param.delID, ',', '\',\'')}'')
  </sql:update>
</c:if>
<%-- <c:redirect url="/jstl/memListPrn.jsp"/> --%>
	<!-- div#wrap -->
	<script src="https://code.jquery.com/jquery-3.6.4.js"
		integrity="sha256-a9jBBRygX1Bh5lt8GZjXDzyOB+bWve9EiO7tROUtj/E="
		crossorigin="anonymous"></script>
	<script>
    let searchBtn = document.getElementById("searchBtn");
    searchBtn.addEventListener("click", function() {
        let searchId = document.getElementById("searchId").value;
        location.href = "memListPrn.jsp?searchId=" + searchId;
    });
 
    function getdel(userID){
        if (confirm("정말 삭제하시겠습니까?")) {
            location.href = "memListPrn.jsp?delID=" + userID;
        }  
    };
    $(document).ready(function() {
    	  $("#chkAll").click(function() {
    	    $("input[name='chk']").prop("checked", this.checked);
    	  });
    	  
    	  $("input[name='chk']").click(function() {
    	    if (!this.checked) {
    	      $("#chkAll").prop("checked", false);
    	    }
    	  });

    	  $("#deleteSelected").click(function() {
    	    var selectedUsers = [];
    	    $("input[name='chk']:checked").each(function() {
    	      selectedUsers.push($(this).parent().find(".uid").text());
    	    });
    	    if (selectedUsers.length > 0 && confirm("정말 삭제하시겠습니까?")) {
    	      var deleteURL = "memListPrn.jsp?delID=" + selectedUsers.join(",");
    	      location.href = deleteURL;
    	    }  
    	  });
    	});
</script>
</body>
</html>