<%
/**
 * Copyright 2013 Sean Kavanagh - sean.p.kavanagh6@gmail.com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html>
<html>
<head>

    <jsp:include page="../_res/inc/header.jsp"/>

    <script type="text/javascript">
        $(document).ready(function() {

            //call delete action
            $(".del_btn").button().click(function() {
                var id = $(this).attr('id').replace("del_btn_", "");
                window.location = 'deleteUser.action?user.id='+ id +'&sortedSet.orderByDirection=<s:property value="sortedSet.orderByDirection" />&sortedSet.orderByField=<s:property value="sortedSet.orderByField"/>';
            });
            //submit add or edit form
            $(".submit_btn").button().click(function() {
                $(this).parents('.modal').find('form').submit();
            });

            $(".sort,.sortAsc,.sortDesc").click(function() {
                var id = $(this).attr('id')

                if ($('#viewUsers_sortedSet_orderByDirection').attr('value') == 'asc') {
                    $('#viewUsers_sortedSet_orderByDirection').attr('value', 'desc');

                } else {
                    $('#viewUsers_sortedSet_orderByDirection').attr('value', 'asc');
                }

                $('#viewUsers_sortedSet_orderByField').attr('value', id);
                $("#viewUsers").submit();

            });
            <s:if test="sortedSet.orderByField!= null">
            $('#<s:property value="sortedSet.orderByField"/>').attr('class', '<s:property value="sortedSet.orderByDirection"/>');
            </s:if>

        });
    </script>

    <s:if test="fieldErrors.size > 0 || actionErrors.size > 0">
        <script type="text/javascript">
            $(document).ready(function() {
                <s:if test="user.id>0">
                $("#edit_dialog_<s:property value="user.id"/>").modal();
                </s:if>
                <s:else>
                $("#add_dialog").modal();
                </s:else>


            });
        </script>
    </s:if>

    <title>EC2Box - Manage Users</title>

</head>
<body>

    <jsp:include page="../_res/inc/navigation.jsp"/>

    <div class="container">
        <s:form action="viewUsers">
            <s:hidden name="_csrf" value="%{#session['_csrf']}"/>
            <s:hidden name="sortedSet.orderByDirection" />
            <s:hidden name="sortedSet.orderByField"/>
        </s:form>

        <h3>Manage Users</h3>

        <p>Add / Delete users or select a user below to assign profile</p>

        <s:if test="sortedSet.itemList!= null && !sortedSet.itemList.isEmpty()">
            <div class="scrollWrapper">
                <table class="table-striped scrollableTable" style="min-width: 80%">
                    <thead>

                    <tr>

                        <th id="<s:property value="@com.ec2box.manage.db.UserDB@USERNAME"/>" class="sort">Username
                        </th>
                        <th id="<s:property value="@com.ec2box.manage.db.UserDB@USER_TYPE"/>" class="sort">User Type
                        </th>
                        <th id="<s:property value="@com.ec2box.manage.db.UserDB@LAST_NM"/>" class="sort">Last
                            Name
                        </th>
                        <th id="<s:property value="@com.ec2box.manage.db.UserDB@FIRST_NM"/>" class="sort">First
                            Name
                        </th>
                        <th id="<s:property value="@com.ec2box.manage.db.UserDB@EMAIL"/>" class="sort">Email
                            Address
                        </th>
                        <th>&nbsp;</th>
                    </tr>
                    </thead>
                    <tbody>
                    <s:iterator var="user" value="sortedSet.itemList" status="stat">
                    <tr>
                        <td>
                            <s:if test="userType==\"M\"">
                                <s:property value="username"/>
                            </s:if>
                            <s:else>
                                <a href="viewUserProfiles.action?user.id=<s:property value="id"/>&_csrf=<s:property value="#session['_csrf']"/>"
                                   title="Manage Profiles for User">
                                    <s:property value="username"/>
                                </a>
                            </s:else>
                        </td>
                        <td>
                            <s:if test="userType==\"A\"">
                                Administrative Only
                            </s:if>
                            <s:else>
                                Full Access
                            </s:else>
                        </td>
                        <td><s:property value="lastNm"/></td>
                        <td><s:property value="firstNm"/></td>
                        <td><s:property value="email"/></td>
                        <td>
                            <div style="width:235px">

                                <button class="btn btn-primary spacer spacer-left" data-toggle="modal" data-target="#edit_dialog_<s:property value="id"/>">Edit</button>

                                <s:if test="%{userId != id}">
                                    <button id="del_btn_<s:property value="id"/>" class="btn btn-primary del_btn spacer spacer-middle">Delete</button>
                                </s:if>

                                <s:if test="userType==\"A\"">
                                    <a href="viewUserProfiles.action?user.id=<s:property value="id"/>&_csrf=<s:property value="#session['_csrf']"/>">
                                        <button id="profile_btn_<s:property value="id"/>" class="btn btn-primary edit_btn spacer spacer-right">Assign Profiles</button>
                                    </a>
                                </s:if>
                                <div style="clear:both"></div>
                            </div>
                        </td>
                    </tr>
                    </s:iterator>
                    </tbody>
                </table>
            </div>
        </s:if>





        <button class="btn btn-primary add_btn spacer spacer-bottom" data-toggle="modal" data-target="#add_dialog">Add User</button>
        <div id="add_dialog" class="modal fade">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                        <h4 class="modal-title">Add User</h4>
                    </div>
                    <div class="modal-body">
                        <s:actionerror/>
                        <s:form action="saveUser" class="save_user_form_add" autocomplete="off">
                            <s:hidden name="_csrf" value="%{#session['_csrf']}"/>
                            <s:textfield name="user.username" label="Username" size="15"/>
                            <s:select name="user.userType" list="#{'A':'Administrative Only','M':'Full Access'}" label="UserType"/>
                            <s:textfield name="user.firstNm" label="First Name" size="15"/>
                            <s:textfield name="user.lastNm" label="Last Name" size="15"/>
                            <s:textfield name="user.email" label="Email Address" size="25"/>
                            <s:password name="user.password" value="" label="Password" size="15"/>
                            <s:password name="user.passwordConfirm" value="" label="Confirm Password" size="15"/>
		                    <s:hidden name="resetSharedSecret"/>
                            <s:hidden name="sortedSet.orderByDirection"/>
                            <s:hidden name="sortedSet.orderByField"/>
                        </s:form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary cancel_btn" data-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary submit_btn">Submit</button>
                    </div>
                </div>
            </div>
        </div>


            <s:iterator var="user" value="sortedSet.itemList" status="stat">
                <div id="edit_dialog_<s:property value="id"/>" class="modal fade">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
                                <h4 class="modal-title">Edit User</h4>
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <s:actionerror/>
                                    <s:form action="saveUser" id="save_user_form_edit_%{id}" autocomplete="off">
                                        <s:hidden name="_csrf" value="%{#session['_csrf']}"/>
                                        <s:textfield name="user.username" value="%{username}" label="Username" size="15"/>
                                        <s:select name="user.userType" value="%{userType}" list="#{'A':'Administrative Only','M':'Full Access'}" label="UserType"/>
                                        <s:textfield name="user.firstNm" value="%{firstNm}" label="First Name" size="15"/>
                                        <s:textfield name="user.lastNm" value="%{lastNm}" label="Last Name" size="15"/>
                                        <s:textfield name="user.email" value="%{email}" label="Email Address" size="25"/>
                                        <s:password name="user.password" value="" label="Password" size="15"/>
                                        <s:password name="user.passwordConfirm" value="" label="Confirm Password" size="15"/>
					                    <s:checkbox name="resetSharedSecret" label="Reset OTP Code"/>
                                        <s:hidden name="user.id" value="%{id}"/>
                                        <s:hidden name="sortedSet.orderByDirection"/>
                                        <s:hidden name="sortedSet.orderByField"/>
                                    </s:form>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-primary cancel_btn" data-dismiss="modal">Cancel</button>
                                <button type="button" class="btn btn-primary submit_btn">Submit</button>
                            </div>
                        </div>
                    </div>
                </div>

            </s:iterator>


    </div>
</body>
</html>
