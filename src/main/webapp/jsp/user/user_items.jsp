<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="ctg" uri="/customtags" %>

<fmt:setLocale value="${sessionScope.locale}" scope="session"/>
<fmt:setBundle basename="/localization/message" var="msg"/>

<fmt:message bundle="${msg}" key="label.projectTitle" var="projectTitle"/>

<fmt:message bundle="${msg}" key="menu.myItems" var="items"/>

<fmt:message bundle="${msg}" key="message.noItemsYet" var="noItemsYet"/>

<fmt:message bundle="${msg}" key="form.addButton" var="addButton"/>

<c:if test="${requestScope.items == null}">
    <jsp:forward page="${pageContext.request.contextPath}/controller">
        <jsp:param name="command" value="load-user-items"/>
    </jsp:forward>
</c:if>

<html>

<%@ include file="/WEB-INF/jspf/head.jsp" %>

<body>

<%@ include file="/WEB-INF/jspf/header.jsp" %>

<main>
    <%@ include file="/WEB-INF/jspf/sidebar.jsp" %>
    <div class="w3-main main-left-margin">

        <div class="content">

            <div class="w3-container w3-right pro-padding-bottom pro-add-button">
                <button id="addItemOpenButton" class="w3-button pro-green">${addButton}</button>
            </div>
            <%@ include file="/WEB-INF/jspf/item_modal.jsp" %>

            <ctg:items command="load-user-items" title="${items}">
                <%@include file="/WEB-INF/jspf/items.jsp" %>
            </ctg:items>
        </div>

    </div>
</main>

<%@ include file="/WEB-INF/jspf/footer.jsp" %>

<c:set scope="session" var="currentPage" value="/jsp/user/user_items.jsp"/>

</body>

</html>