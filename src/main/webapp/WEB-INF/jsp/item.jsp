<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="ctg" uri="/customtags" %>

<fmt:setLocale value="${sessionScope.locale}" scope="session"/>
<fmt:setBundle basename="/localization/message" var="msg"/>

<fmt:message bundle="${msg}" key="label.projectTitle" var="projectTitle"/>
<fmt:message bundle="${msg}" key="menu.myItems" var="items"/>
<fmt:message bundle="${msg}" key="message.noItemsYet" var="noItemsYet"/>
<fmt:message bundle="${msg}" key="label.approve" var="approve"/>
<fmt:message bundle="${msg}" key="label.discard" var="discard"/>
<fmt:message bundle="${msg}" key="form.itemTitle" var="itemTitle"/>
<fmt:message bundle="${msg}" key="form.description" var="description"/>
<fmt:message bundle="${msg}" key="form.startPrice" var="startPrice"/>
<fmt:message bundle="${msg}" key="form.blitzPrice" var="blitzPrice"/>
<fmt:message bundle="${msg}" key="form.startDate" var="startDate"/>
<fmt:message bundle="${msg}" key="form.closeDate" var="closeDate"/>
<fmt:message bundle="${msg}" key="form.category" var="category"/>
<fmt:message bundle="${msg}" key="form.photos" var="photos"/>
<fmt:message bundle="${msg}" key="item.actualPrice" var="actualPrice"/>
<fmt:message bundle="${msg}" key="item.prices" var="prices"/>
<fmt:message bundle="${msg}" key="item.dates" var="dates"/>
<fmt:message bundle="${msg}" key="item.startPrice" var="itemStartPrice"/>
<fmt:message bundle="${msg}" key="item.blitzPrice" var="itemBlitzPrice"/>
<fmt:message bundle="${msg}" key="item.startDate" var="itemStartDate"/>
<fmt:message bundle="${msg}" key="item.closeDate" var="itemCloseDate"/>
<fmt:message bundle="${msg}" key="item.edit" var="edit"/>
<fmt:message bundle="${msg}" key="form.priceRule" var="priceRule"/>
<fmt:message bundle="${msg}" key="message.noPhotosForItem" var="noPhotosForItem"/>
<fmt:message bundle="${msg}" key="label.makeBid" var="makeBid"/>
<fmt:message bundle="${msg}" key="item.delete" var="delete"/>
<fmt:message bundle="${msg}" key="item.cancelAuction" var="cancelAuction"/>
<fmt:message bundle="${msg}" key="status.title" var="statusTitle"/>
<fmt:message bundle="${msg}" key="status.created" var="created"/>
<fmt:message bundle="${msg}" key="status.confirmed" var="confirmed"/>
<fmt:message bundle="${msg}" key="status.active" var="active"/>
<fmt:message bundle="${msg}" key="status.sold" var="sold"/>
<fmt:message bundle="${msg}" key="status.canceled" var="canceled"/>
<fmt:message bundle="${msg}" key="status.ended" var="ended"/>
<fmt:message bundle="${msg}" key="status.not_confirmed" var="not_confirmed"/>
<fmt:message bundle="${msg}" key="status.delivered" var="delivered"/>
<fmt:message bundle="${msg}" key="status.violation" var="violation"/>

<html>

<%@ include file="/WEB-INF/jspf/head.jsp" %>

<body>

<%@ include file="/WEB-INF/jspf/header.jsp" %>

<main>

    <%@ include file="/WEB-INF/jspf/sidebar.jsp" %>

    <%@ include file="/WEB-INF/jspf/confirm.jsp" %>

    <div class="w3-main main-left-margin">

        <div class="content">

            <div class="w3-row-padding w3-margin-top">

                <div class="w3-container w3-right">
                    <div class="w3-bar">
                        <c:if test="${sessionScope.user!=null}">
                            <c:choose>
                                <c:when test="${(sessionScope.item.status == 'CREATED') && (sessionScope.user.role == 'ADMIN')}">
                                    <form class="w3-bar-item"
                                          action="${pageContext.request.contextPath}/controller">
                                        <input type="hidden" name="command" value="approve-item"/>
                                        <button class="w3-button pro-green w3-ripple">
                                                ${approve}
                                        </button>
                                    </form>

                                    <form class="w3-bar-item"
                                          action="${pageContext.request.contextPath}/controller">
                                        <input type="hidden" name="command" value="discard-item"/>
                                        <input type="hidden" name="itemId" value="${sessionScope.item.id}"/>
                                        <button class="w3-button pro-green w3-ripple">
                                                ${discard}
                                        </button>
                                    </form>
                                </c:when>
                                <c:when test="${(sessionScope.user.id == sessionScope.item.sellerId)}">
                                    <c:if test="${(sessionScope.item.status == 'CREATED') || (sessionScope.item.status == 'CONFIRMED')}">

                                        <form class="w3-bar-item" id="deleteItemForm"
                                              action="${pageContext.request.contextPath}/controller">
                                            <input type="hidden" name="command" value="delete-item"/>
                                            <button class="w3-button pro-green w3-ripple">
                                                    ${delete}
                                            </button>
                                        </form>

                                        <div class="w3-bar-item ">
                                            <a href="${pageContext.request.contextPath}/WEB-INF/jsp/user/edit_item.jsp"
                                               class="w3-button pro-green w3-ripple">
                                                    ${edit}
                                            </a>
                                        </div>
                                    </c:if>

                                    <c:if test="${(sessionScope.item.status == 'CREATED')
                                    || (sessionScope.item.status == 'CONFIRMED')
                                    || (sessionScope.item.status == 'ACTIVE')}">
                                        <form class="w3-bar-item"
                                              action="${pageContext.request.contextPath}/controller">
                                            <input type="hidden" name="command" value="cancel-auction"/>
                                            <button class="w3-button pro-green w3-ripple">
                                                    ${cancelAuction}
                                            </button>
                                        </form>
                                    </c:if>

                                    <c:if test="${sessionScope.item.status == 'SOLD'}">
                                        <c:choose>
                                            <c:when test="${(sessionScope.item.deliveryStatus == 'NO_DELIVERY')
                                                || (sessionScope.item.deliveryStatus == 'BUYER_C')
                                                || (sessionScope.item.deliveryStatus == 'BUYER_RV')}">
                                                <form class="w3-bar-item" id="confirmDeliveryForm"
                                                      action="${pageContext.request.contextPath}/controller">
                                                    <input type="hidden" name="command" value="confirm-delivery"/>
                                                    <input type="hidden" name="is-seller" value="true"/>
                                                    <button class="w3-button pro-green w3-ripple">
                                                        confirm delivery
                                                    </button>
                                                </form>
                                                <form class="w3-bar-item" id="reportViolationForm"
                                                      action="${pageContext.request.contextPath}/controller">
                                                    <input type="hidden" name="command" value="report-violation"/>
                                                    <input type="hidden" name="is-seller" value="true"/>
                                                    <button class="w3-button pro-sand w3-ripple">
                                                        report violation
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <c:if test="${(sessionScope.item.deliveryStatus == 'SELLER_C')
                                                    || (sessionScope.item.deliveryStatus == 'SELLER_BUYER_C')}">
                                                    <div class="w3-bar-item">
                                                        <button class="w3-button pro-green w3-ripple w3-disabled">
                                                            delivery confirmed
                                                        </button>
                                                    </div>
                                                </c:if>
                                                <c:if test="${(sessionScope.item.deliveryStatus == 'SELLER_RV')
                                                    || (sessionScope.item.deliveryStatus == 'SELLER_BUYER_RV')}">
                                                    <div class="w3-bar-item">
                                                        <button class="w3-button pro-sand w3-ripple w3-disabled">
                                                            violation reported
                                                        </button>
                                                    </div>
                                                </c:if>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                </c:when>
                                <c:when test="${sessionScope.item.status == 'SOLD'}">
                                    <form class="w3-bar-item"
                                          action="${pageContext.request.contextPath}/controller">
                                        <input type="hidden" name="command" value="show_profile"/>
                                        <button class="w3-button pro-green w3-ripple">
                                            show Seller Contacts
                                        </button>
                                    </form>

                                    <c:choose>
                                        <c:when test="${(sessionScope.item.deliveryStatus == 'NO_DELIVERY')
                                                || (sessionScope.item.deliveryStatus == 'SELLER_C')
                                                || (sessionScope.item.deliveryStatus == 'SELLER_RV')}">
                                            <form class="w3-bar-item" id="confirmDeliveryForm"
                                                  action="${pageContext.request.contextPath}/controller">
                                                <input type="hidden" name="command" value="confirm-delivery"/>
                                                <input type="hidden" name="is-seller" value="false"/>
                                                <button class="w3-button pro-green w3-ripple">
                                                    confirm delivery
                                                </button>
                                            </form>
                                            <form class="w3-bar-item" id="reportViolationForm"
                                                  action="${pageContext.request.contextPath}/controller">
                                                <input type="hidden" name="command" value="report-violation"/>
                                                <input type="hidden" name="is-seller" value="false"/>
                                                <button class="w3-button pro-sand w3-ripple">
                                                    report violation
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <c:if test="${(sessionScope.item.deliveryStatus == 'BUYER_C')
                                                    || (sessionScope.item.deliveryStatus == 'SELLER_BUYER_C')}">
                                                <div class="w3-bar-item">
                                                    <button class="w3-button pro-green w3-ripple w3-disabled">
                                                        delivery confirmed
                                                    </button>
                                                </div>
                                            </c:if>
                                            <c:if test="${(sessionScope.item.deliveryStatus == 'BUYER_RV')
                                                    || (sessionScope.item.deliveryStatus == 'SELLER_BUYER_RV')}">
                                                <div class="w3-bar-item">
                                                    <button class="w3-button pro-sand w3-ripple w3-disabled">
                                                        violation reported
                                                    </button>
                                                </div>
                                            </c:if>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                            </c:choose>
                        </c:if>
                    </div>
                </div>

            </div>

            <div class="w3-container w3-margin middle-title uppercase">
                <b>${sessionScope.item.name}</b>
            </div>

            <div class="w3-container w3-margin">
                ${statusTitle}: ${pageScope[sessionScope.item.status.toString().toLowerCase()]}
            </div>

            <div class="w3-container w3-margin middle-title">
                ${actualPrice}:
                <div class="text-on-color"><ctg:money value="${sessionScope.item.actualPrice}"/></div>
            </div>

            <c:if test="${(sessionScope.item.status == 'ACTIVE') && (sessionScope.user != null) && (sessionScope.user.id != sessionScope.item.sellerId)}">
                <div class="w3-container w3-margin">
                    <form action="${pageContext.request.contextPath}/controller" method="post">
                        <input type="hidden" name="command" value="make-bid"/>
                        <input type="hidden" name="itemId" value="${sessionScope.item.id}"/>
                        <input name="bidValue" class="w3-input back-back-color w3-col m3 s4" type="number" step="1"
                               min="${sessionScope.item.actualPrice}"
                               max="99999999999999999999" value="${sessionScope.item.actualPrice + 1}" required
                               title="${priceRule}"/>
                        <button class="w3-margin-left w3-button pro-red">
                                ${makeBid}
                        </button>
                    </form>
                </div>
            </c:if>

            <div class="w3-row-padding">

                <div class="w3-col m7">

                    <div class="w3-card w3-padding w3-margin-top w3-margin-bottom photos-container" id="photos"
                         data-error-message="${noPhotosForItem}"
                         data-item-id="${sessionScope.item.id}">
                    </div>

                </div>

                <div class="w3-col m5">

                    <div class="w3-card w3-margin-top">
                        <div class="w3-container w3-padding pro-lightgrey">${prices}</div>
                        <div class="w3-container w3-padding">
                            ${itemStartPrice}:
                            <div class="text-on-color"><ctg:money value="${sessionScope.item.startPrice}"/></div>
                        </div>
                        <div class="w3-container w3-padding">
                            ${itemBlitzPrice}:
                            <div class="text-on-color"><ctg:money value="${sessionScope.item.blitzPrice}"/></div>
                        </div>
                    </div>

                    <div class="w3-card w3-margin-top">
                        <div class="w3-container w3-padding pro-lightgrey">${dates}</div>
                        <div class="w3-container w3-padding">
                            ${itemStartDate}: ${sessionScope.item.startDate}
                        </div>
                        <div class="w3-container w3-padding">
                            ${itemCloseDate}: ${sessionScope.item.closeDate}
                        </div>
                    </div>

                </div>

            </div>

            <div class="w3-card w3-margin">
                <div class="w3-container pro-grey capitalize w3-padding w3-leftbar">
                    ${description}
                </div>
                <div class="w3-container w3-padding">
                    ${sessionScope.item.description}
                </div>
            </div>

        </div>

    </div>


</main>

<%@ include file="/WEB-INF/jspf/message.jsp" %>

<%@ include file="/WEB-INF/jspf/footer.jsp" %>

<c:if test="${sessionScope.user == null}">
    <%@ include file="/WEB-INF/jspf/sign_in.jsp" %>
    <%@ include file="/WEB-INF/jspf/sign_up.jsp" %>
    <script src="${pageContext.request.contextPath}/js/controller/sign.controller.js"></script>
</c:if>

<script src="${pageContext.request.contextPath}/js/controller/item.controller.js"></script>

<c:set scope="session" var="currentPage" value="/WEB-INF/jsp/item.jsp"/>

</body>

</html>