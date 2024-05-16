<%@page import="beeNb.dao.*"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/customer/inc/customerSessionIsNull.jsp" %>
<%
	System.out.println("========== addOneDayPriceForm.jsp ==========");
	// roomNo 요청값
	int roomNo = Integer.parseInt(request.getParameter("roomNo"));
	// 디버깅
	System.out.println("roomNo : " + roomNo);
	
	// 호스팅한 숙소의 하루 가격 및 정보(가격, 예약 상태)리스트
	ArrayList<HashMap<String, Object>> oneDayPriceList = OneDayPriceDAO.selectOneDayPriceList(roomNo);
	// 디버깅
	System.out.println("oneDayPriceList : " + oneDayPriceList);
%>
<%
	// 달력 구현
	// 페이지의 달력 년도와 월 요청값
	String targetYear = request.getParameter("targetYear");
	String targetMonth = request.getParameter("targetMonth");
	// 디버깅
	System.out.println("targetYear : " + targetYear);
	System.out.println("targetMonth : " + targetMonth);
	
	// 캘린더 객체 생성
	Calendar target = Calendar.getInstance();
	
	// 년도, 월의 요청값이 있을 경우 Calendar객체의 Year, Month를 요청값으로 변경
	if(targetYear != null && targetMonth != null) {
		target.set(Calendar.YEAR, Integer.parseInt(targetYear));
		target.set(Calendar.MONTH, Integer.parseInt(targetMonth));
	}
	
	// 페이지에 출력할 달력 년 월 변수
	int calendarYear = target.get(Calendar.YEAR);
	int calendarMonth = target.get(Calendar.MONTH);
	// 디버깅
	System.out.println("calendarYear : " + calendarYear);
	System.out.println("calendarMonth : " + calendarMonth);
	
	// 달력 1일 시작 전 공백 개수 구하기 -> 1일의 요일이 필요 -> target의 날짜를 1일로 변경
	target.set(Calendar.DATE, 1);
	int firstDayNum = target.get(Calendar.DAY_OF_WEEK);	//1일의 요일 (일 : 1 / 월 : 2 / ... / 토 : 7)
	// 디버깅
	System.out.println("firstDayNum : " + firstDayNum);
	
	int firstDayBeforeBlank = firstDayNum - 1;	// 1일 시작 전 공백 개수 Ex) 1일이 일요일 -> 0개 / 1일이 월요일 -> 1개 / .... / 1일이 토요일 -> 6개
	int lastDay = target.getActualMaximum(Calendar.DATE);	// target달의 마지막 날짜 반환
	// 디버깅
	System.out.println("firstDayBeforeBlank : " + firstDayBeforeBlank);
	System.out.println("lastDay : " + lastDay);
	
	// 달력 칸의 개수
	int calendarTotalDiv = 42;	
%>
<%
	System.out.println("========== empRegistForm.jsp ==========");
	// err메시지 요청 값
	String errMsg = request.getParameter("errMsg");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
	<jsp:include page="/inc/bootstrapCDN.jsp"></jsp:include>
	<link href="/BeeNb/css/style.css" rel="stylesheet" type="text/css">
</head>
<body>
	<div class="container">
		<!-- 고객 네비게이션 바 -->
		<jsp:include page="/customer/inc/customerNavbar.jsp"></jsp:include>
		
		<h1>가격등록</h1>
		<!-- 뒤로 가기 -->
		<div>
			<a class="text-decoration-none" href="/BeeNb/customer/hostRoomOne.jsp?roomNo=<%=roomNo%>">뒤로가기</a>
		</div>
		<!-- err 메시지 출력 -->
		<%
			if(errMsg != null) {
		%>
				<div class="alert alert-danger" role="alert">
					<%= errMsg%>
				</div>
		<%
			}
		%>
		<div>
			<hr>
			<div class="row">
				<div class="col">
					<a href="/BeeNb/customer/addOneDayPriceForm.jsp?roomNo=<%=roomNo %>&targetYear=<%=calendarYear%>&targetMonth=<%=calendarMonth - 1%>">
						이전 달
					</a>
				</div>
				
				<div class="col">
					<h2><%=calendarYear%>년 <%=calendarMonth + 1%>월</h2>
				</div>
				
				<div class="col">
					<a href="/BeeNb/customer/addOneDayPriceForm.jsp?roomNo=<%=roomNo %>&targetYear=<%=calendarYear%>&targetMonth=<%=calendarMonth + 1%>">
						다음 달
					</a>
				</div>
			</div>
		</div>
		
		<!-- 달력 -->
		<div>
		<form action="/BeeNb/customer/addOneDayPriceAction.jsp" method="post">
			<!-- 요일 -->
			<table class="table">
				<thead>
					<tr>
						<th>일</th>
						<th>월</th>
						<th>화</th>
						<th>수</th>
						<th>목</th>
						<th>금</th>
						<th>토</th>
					</tr>
				</thead>
				<tbody>
					<tr>
					<%
						for(int i = 1; i <= calendarTotalDiv; i ++) {
							// 공백 숫자를 뺀 실제 달력에 표시되야하는 날짜
							int realDay = i - firstDayBeforeBlank;
					%>
						<td>
					<%
							// realDay가 실제 달력의 날짜와 동일해야만 달력에 출력
							if((realDay >= 1) && (realDay <= lastDay)) {
								// oneDayPriceList에 있는 날짜인지 아닌지 검증하는 변수(존재(가격 설정 O)하면 true, 없는 날짜(가격 설정 X)면 false)
								boolean isDayInList = false;
								
								// oneDayPriceList 반복문 실행
								for(HashMap<String, Object> m : oneDayPriceList) {
									// 날짜 비교를 위해 각각의 변수(년, 월, 일)로 분리
									int oneDayPriceYear = Integer.parseInt((((String)(m.get("roomDate"))).substring(0, 4)));
									int oneDayPriceMonth = Integer.parseInt((((String)(m.get("roomDate"))).substring(5, 7)));
									int oneDayPriceDay = Integer.parseInt((((String)(m.get("roomDate"))).substring(8, 10)));
									
									// oneDayPriceList안의 roomDate와 페이지에 표시될 날짜가 같다면 isDayInList를 true로 변경 후 for문 break
									if(calendarYear == oneDayPriceYear && (calendarMonth + 1) == oneDayPriceMonth && (realDay) == oneDayPriceDay) {
										isDayInList = true;
										break;
									}
								}
								
								// oneDayPriceList에 존재하는 날짜(가격이 설정 O)이면
								if(isDayInList) {
									// 페이지에 날짜 표시
					%>
									<%= (realDay) %>
					<%
									for(HashMap<String, Object> m : oneDayPriceList) {
										int oneDayPriceYear = Integer.parseInt((((String)(m.get("roomDate"))).substring(0, 4)));
										int oneDayPriceMonth = Integer.parseInt((((String)(m.get("roomDate"))).substring(5, 7)));
										int oneDayPriceDay = Integer.parseInt((((String)(m.get("roomDate"))).substring(8, 10)));
										
										if(calendarYear == oneDayPriceYear && (calendarMonth + 1) == oneDayPriceMonth && (realDay) == oneDayPriceDay) {
					%>
											<br>예약 상태 : <b><%= m.get("roomState") %></b>
											<br>등록 가격 : <b><%= m.get("roomPrice") %>원</b>
					<%
										}
									}
								} else {
									// 가격 설정 X인 날이라면
									
									// roomDate 날짜 조합(DB의 데이터형식에 맟줘) ex)yyyy-mm-dd 형식
									String roomDate = calendarYear + "-" + (calendarMonth + 1) + "-" + (realDay);
									// label당 체크박스를 하나씩 설정하기 위해
									String addDate = "date-" + (realDay);
					%>
									<%= (realDay) %>
									<br>
									<label for="<%= addDate %>">날짜 선택</label>
									<input type="checkbox" name="roomDate" id="<%= addDate %>" value="<%=roomDate %>">
									
					<%
								}
							}
					%>
						</td>
					<%
							// 한줄에 칸이 7개가 되면 행을 닫기
							if(i % 7 == 0) {
					%>
								</tr>
					<%
							}
						}
					%>
				</tbody>
			</table>
			<input type="number" name="roomPrice" required="required" placeholder="가격 입력">
			<input type="hidden" name="roomNo" value="<%=roomNo%>">
			<button type="submit">가격 등록</button>
		</form>
		</div>
		
		<!-- 푸터 -->
		<jsp:include page="/inc/footer.jsp"></jsp:include>
	</div>
</body>
</html>