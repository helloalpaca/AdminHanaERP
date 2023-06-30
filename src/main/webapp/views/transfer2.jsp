<%--
  Created by IntelliJ IDEA.
  User: ansix
  Date: 2023/06/27
  Time: 1:25 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%
  request.setCharacterEncoding("UTF-8");
  String contextPath = request.getContextPath();
  String message = (String) request.getAttribute("alert_message");
  String ck = (String) request.getAttribute("ck");
  String title = (String) request.getAttribute("title");
  System.out.println(title);
  String action = null;
  if (title.equals("계좌이체"))
    action = "transfer";
  else if (title.equals("출금")) {
    action = "withdraw";
  } else if (title.equals("입금")) {
    action = "deposit";
  }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous"/>
  <link rel="stylesheet" href="<%=contextPath%>/resources/css/nav.css">
  <link rel="stylesheet" href="<%=contextPath%>/resources/css/base.css">
  <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
  <title>Admin Hana - <%=title%>.jsp ver2</title>
</head>
<body>
  <% if (message != null) { %>
  <script>
      var alertMessage = '<%= message.replace("'", "\\'").replace("\n", "\\n") %>';
      alert(alertMessage);
  </script>
  <% } %>
  <div class="wrap">
    <nav id="layoutSidenav_nav">
      <%@ include file="common/navbar.jsp" %>
    </nav>
    <main>
      <form action="<%=action%>" method="post" id="transferForm" name="transferForm" class="p-5 bg-white">
        <h2 class="h4 text-black mb-5"><%=title%>
        </h2>
        <%-- 원대한 계획
        <div class="row form-group">
          <div class="col-md-6 mb-3 mb-md-0">
            <label class="text-black" for="acc_id">내 계좌</label>
            <select id="acc_id" class="form-select" name="acc_id">
              <option value="null">무통장</option>
              <option selected="" value="1">1</option>
              <option value="2">2</option>
              <option value="3">3</option>
            </select>
          </div>
          <div class="col-md-2 mb-3 mb-md-0">
            <label class="text-black" for="acc_password">계좌 비밀번호</label>
            <input type="text" id="acc_password" maxlength="4" name="acc_password" class="form-control">
          </div>
          <div class="col-md-8">
            <label class="text-black" for="counterpart_id">입금할 계좌</label>
            <input type="text" id="counterpart_id" name="counterpart_id" class="form-control">
          </div>
        </div>--%>
        <% if (title.equals("계좌이체") || title.equals("출금")) { %>
        <div class="row form-group">
          <div class="col-md-5 mb-3 mb-md-0">
            <label class="text-black" for="acc_id">내 계좌</label>
            <% if (ck != null && ck.equals("1")) { %>
            <input type="text" id="acc_id" name="acc_id"
                   value="${acc_id}"
                   class="form-control" readonly><%}%>
            <% if (ck == null) { %>
            <input type="text" id="acc_id" name="acc_id"
                   value="${acc_id}"
                   class="form-control"><%}%>
            <!-- 나머지 코드 생략 -->
          </div>
          <div class="col-md-2 mb-3 mb-md-0 form-group">
            <label class="text-black" for="acc_password">계좌 비밀번호</label>
            <input type="text" id="acc_password" value="${acc_password}" maxlength="4" name="acc_password"
                   class="form-control">
          </div>
          <div class="col-md-1 mb-3 mb-md-0 form-group d-flex align-items-end">
            <input type="button" value="입력" onclick="checkPwd()" class="btn btn-primary text-white form-control">
          </div>
        </div>
        <%}%>

        <% if (title.equals("계좌이체") || title.equals("입금")) { %>
        <div class="col-md-8">
          <label class="text-black" for="counterpart_id">입금할 계좌</label>
          <input type="text" id="counterpart_id" name="counterpart_id" class="form-control">
        </div>
        <%}%>

        <% if (title.equals("계좌이체") || title.equals("출금")) { %>
        <div class="row form-group">
          <div class="col-md-8">
            <label class="text-black" for="acc_balance">계좌 잔고</label>
            <input type="text" id="acc_balance" name="acc_balance" class="form-control" readonly value="${acc_balance}">
          </div>
        </div>
        <% } %>

        <div class="row form-group">
          <div class="col-md-8">
            <label class="text-black" for="t_amount">거래금액</label>
            <input type="number" id="t_amount" name="t_amount" value="${t_amount}" class="form-control">
          </div>
        </div>

        <div class="row form-group">
          <div class="col-md-8">
            <label class="text-black" for="message">거래내용</label>
            <textarea name="message" id="message" cols="20" rows="7" class="form-control"
                      placeholder="거래내용이 있으면 입력해주세요.">${message}</textarea>
          </div>
        </div>
        <% if (((title.equals("계좌이체") || title.equals("출금")) && (ck != null)) || title.equals("입금")) { %>
        <div class="row form-group">
          <div class="col-md-8 mt-2">
            <input type="button" value="거래" onclick="submitForm()" class="btn btn-primary text-white form-control">
          </div>
        </div>
        <% } %>
      </form>
    </main>
  </div>

  <script>
      function submitForm() {
          let message = document.getElementById('message').value;
          var form = document.getElementById('transferForm');
          if (message.length == 0) {
              <% if (title.equals("출금")) { %>
              document.getElementById('message').value = '창구 출금';
              form.setAttribute("message", "창구 출금");
              <%}%>
              <% if (title.equals("계좌이체")) { %>
              document.getElementById('message').value = '계좌이체';
              form.setAttribute("message", "계좌이체");
              <%}%>
              <% if (title.equals("입금")) { %>
              document.getElementById('message').value = '창구 입금';
              form.setAttribute("message", "창구입금");
              <%}%>
          }
          form.submit();
      }
  </script>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"
          integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz"
          crossorigin="anonymous"></script>
  <script>
      function checkPwd() {
          var form = document.getElementById('transferForm');
          var isCheck = document.createElement('input');
          isCheck.setAttribute('type', 'text');
          isCheck.setAttribute('name', 'isCheck');
          if (document.getElementById('acc_password').value.trim() <= 3) {
              alert("비밀번호 4자리를 모두 입력해주세요.")
              return;
          }
          isCheck.setAttribute('value', 'check');
          form.appendChild(isCheck);
          form.submit();
          var isCheckInput = form.elements['isCheck']; // name이 'valid_rrn'인 요소 가져오기
          if (isCheckInput) {
              isCheckInput.parentNode.removeChild(isCheckInput); // 요소 삭제
              form.removeAttribute('isCheck');
          }
      }
  </script>
</body>
</html>