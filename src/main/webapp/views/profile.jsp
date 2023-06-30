<%@ page import="hana.teamfour.addminhana.DTO.CustomerSummaryDTO" %><%-- Created by IntelliJ IDEA. User: chaedongim Date: 2023/06/19 Time: 9:26 AM To change this template use File |
Settings | File Templates. --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
  request.setCharacterEncoding("UTF-8");
  String contextPath = request.getContextPath();
  CustomerSummaryDTO customerSummaryDTO = (CustomerSummaryDTO) request.getAttribute("customerSummaryDTO");
  Boolean hasUpdatedDescription = (Boolean) request.getAttribute("hasUpdatedDescription");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
        rel="stylesheet"
        integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM"
        crossorigin="anonymous"/>
  <link rel="stylesheet" href="<%=contextPath%>/resources/css/base.css">
  <link rel="stylesheet" href="<%=contextPath%>/resources/css/nav.css"/>
  <link rel="stylesheet" href="<%=contextPath%>/resources/css/profile.css"/>
  <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
  <title>Admin Hana - profile</title>
</head>
<body>
  <div class="wrap">
    <nav id="layoutSidenav_nav">
      <%@ include file="common/navbar.jsp" %>
    </nav>

    <jsp:include page="common/toastSuccess.jsp" flush="false">
      <jsp:param name="title" value="업데이트 성공"/>
      <jsp:param name="subtitle" value="Success"/>
      <jsp:param name="description" value="업데이트에 성공했습니다. "/>
    </jsp:include>

    <jsp:include page="common/toastFail.jsp" flush="false">
      <jsp:param name="title" value="업데이트 실패"/>
      <jsp:param name="subtitle" value="Fail"/>
      <jsp:param name="description" value="업데이트에 실패했습니다. "/>
    </jsp:include>

    <main class="d-grid grid-cols-12 gap-4 w-100">
      <div class="col-span-8 column">
        <div class="card profileSummary">
          <div class="card-body">
            <h5 class="card-title">프로필</h5>
            <h6 class="card-subtitle mb-2">
              <span class="summaryCustomerName">${customerSummaryDTO.c_name} 손님</span>
              <span>만 ${customerSummaryDTO.c_age}세 / ${customerSummaryDTO.c_gender} / ${customerSummaryDTO.c_job}</span>
            </h6>
            <p class="card-text">${customerSummaryDTO.c_rrn}</p>
          </div>
        </div>

        <div class="card customerDescriptionContainer">
          <div class="card-body">
            <h5 class="card-title">특이사항</h5>
            <p class="card-text customerDescriptions">
            <form class="descriptionForm" name="descriptionForm" method="post" action="profile"
                  accept-charset="utf-8">
              <textarea name="descriptionText" class="descriptionTextarea" cols="76" rows="10"
                        maxlength="300">${customerSummaryDTO.c_description}</textarea>
              <input type="hidden" name="action" value="description">
              <div class="d-grid mt-4">
                <button class="btn btn-primary" style="background-color: #0d6efd" type="submit">수정</button>
              </div>
            </form>
            </p>
          </div>
        </div>
      </div>

      <div class="col-span-4 column">
        <div class="card recommendationProducts">
          <div class="card-body">
            <h5 class="card-title mb-4">신규 추천 상품</h5>
            <div class="d-flex">
              <h6 class="card-subtitle mb-2 w-16 recommendationSubtitle ">예금 </h6>
              <a>전체보기 ></a>
            </div>
            <ul class="card-text  mb-4">
              <li class="productItem">하나의 정기에금
                <button class="btn btn-sm btn-outline-primary"><a>가입</a></button>
              </li>
              <li class="productItem">365 정기에금
                <button class="btn btn-sm btn-outline-primary"><a>가입</a></button>
              </li>
            </ul>

            <div class="d-flex">
              <h6 class="card-subtitle mb-2 w-16 recommendationSubtitle ">입출금 </h6>
              <a>전체보기 ></a>
            </div>
            <ul class="card-text  mb-4">
              <li class="productItem">하나의 정기에금
                <button class="btn btn-sm btn-outline-primary"><a>가입</a></button>
              </li>
              <li class="productItem">365 정기에금
                <button class="btn btn-sm btn-outline-primary"><a>가입</a></button>

              </li>
            </ul>
          </div>
        </div>
        <div class="logOutButton">
          <a style="color:white;text-underline: none;text-decoration: none; outline: none;"
             href="<%=contextPath%>/logout/customer">
            <button class="btn btn-primary w-100">거래 종료</button>
          </a>
        </div>
      </div>

    </main>
  </div>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"
          integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz"
          crossorigin="anonymous"
  ></script>
  <script>
      const hasUpdated = <%=hasUpdatedDescription%>;
      const $descriptionForm = document.querySelector('.descriptionForm')
      const $toastSuccess = document.getElementById('toastSuccess')
      const $toastFailure = document.getElementById('toastFail')

      document.addEventListener("DOMContentLoaded", () => {
          if (hasUpdated == null) {
              return;
          } else if (hasUpdated) {
              triggerToast($toastSuccess);
          } else {
              triggerToast($toastFailure);
          }
      })

      const triggerToast = ($target) => {
          const toast = new bootstrap.Toast($target);
          toast.show();
      }

      window.onkeydown = function (event) {
          const kcode = event.key;
          if (kcode == "refresh") {
              history.replaceState({}.null, location.pathname);
          }
      }
  </script>
</body>
</html>
