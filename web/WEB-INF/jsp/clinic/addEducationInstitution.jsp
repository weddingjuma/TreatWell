<%-- 
    Document   : addEducationInstitution
    Created on : Nov 21, 2017, 3:50:00 PM
    Author     : Cori 5
--%>

<%@include file="../header.jsp"%>
<script>
    $(function () {
        displayData();
    });
    function displayData() {
        var $tbl = $('<table class="table table-striped table-bordered table-hover">');
        $tbl.append($('<thead>').append($('<tr>').append(
                $('<th class="center" width="5%">').html('Sr. #'),
                $('<th class="center" width="30%">').html('Medical College Name'),
                $('<th class="center" width="20%">').html('City'),
                $('<th class="center" width="20%">').html('Country'),
                $('<th class="center" width="15%" colspan="2">').html('&nbsp;')
                )));
        $.get('clinic.htm?action=getEducationInstitutions', {medicalCollegeName: $('#medicalCollegeName').val()},
                function (list) {
                    if (list !== null && list.length > 0) {
                        $tbl.append($('<tbody>'));
                        for (var i = 0; i < list.length; i++) {
                            var editHtm = '<i class="fa fa-pencil-square-o" aria-hidden="true" title="Click to Edit" style="cursor: pointer;" onclick="editRow(\'' + list[i].TW_MEDICAL_COLLEGE_ID + '\');"></i>';
                            var delHtm = '<i class="fa fa-trash-o" aria-hidden="true" title="Click to Delete" style="cursor: pointer;" onclick="deleteRow(\'' + list[i].TW_MEDICAL_COLLEGE_ID + '\');"></i>';
                            if ($('#can_edit').val() !== 'Y') {
                                editHtm = '&nbsp;';
                            }
                            if ($('#can_delete').val() !== 'Y') {
                                delHtm = '&nbsp;';
                            }
                            $tbl.append(
                                    $('<tr>').append(
                                    $('<td  align="center">').html(eval(i + 1)),
                                    $('<td>').html(list[i].TITLE),
                                    $('<td>').html(list[i].CITY_NME),
                                    $('<td>').html(list[i].COUNTRY_NME),
                                    $('<td align="center">').html(editHtm),
                                    $('<td  align="center">').html(delHtm)
                                    ));
                        }
                        $('#displayDiv').html('');
                        $('#displayDiv').append($tbl);
                        return false;
                    } else {
                        $('#displayDiv').html('');
                        $tbl.append(
                                $('<tr>').append(
                                $('<td  colspan="7">').html('<b>No data found.</b>')
                                ));
                        $('#displayDiv').append($tbl);
                        return false;
                    }
                }, 'json');
    }

    function saveData() {
        if ($.trim($('#medicalCollegeName').val()) === '') {
            $('#medicalCollegeName').notify('Medical College Name is Required Field', 'error', {autoHideDelay: 15000});
            $('#medicalCollegeName').focus();
            return false;
        }
        if ($.trim($('#cityId').val()) === '') {
            $('#cityId').notify('City is Required Field', 'error', {autoHideDelay: 15000});
            $('#cityId').focus();
            return false;
        }
        if ($.trim($('#countryId').val()) === '') {
            $('#countryId').notify('Country is Required Field', 'error', {autoHideDelay: 15000});
            $('#countryId').focus();
            return false;
        }

        var obj = {
            medicalCollegeId: $('#medicalCollegeId').val(),
            medicalCollegeName: $('#medicalCollegeName').val(),
            cityId: $('#cityId').val(),
            countryId: $('#countryId').val()
        };
        $.post('clinic.htm?action=saveEducationInstitution', obj, function (obj) {
            if (obj.result === 'save_success') {
                $.bootstrapGrowl("Medical College Data saved successfully.", {
                    ele: 'body',
                    type: 'success',
                    offset: {from: 'top', amount: 80},
                    align: 'right',
                    allow_dismiss: true,
                    stackup_spacing: 10
                });
                $('input:text').val('');
                $('#medicalCollegeId').val('');
                $('#addMedicalCollege').modal('hide');
                displayData();
                return false;
            } else {
                $.bootstrapGrowl("Error in saving Medical College. Please try again later.", {
                    ele: 'body',
                    type: 'error',
                    offset: {from: 'top', amount: 80},
                    align: 'right',
                    allow_dismiss: true,
                    stackup_spacing: 10
                });

                return false;
            }
        }, 'json');
        return false;
    }

    function deleteRow(id) {
        bootbox.confirm({
            message: "Do you want to delete record?",
            buttons: {
                confirm: {
                    label: 'Yes',
                    className: 'btn-success'
                },
                cancel: {
                    label: 'No',
                    className: 'btn-danger'
                }
            },
            callback: function (result) {
                if (result) {
                    $.post('clinic.htm?action=deleteEducationInstitution', {id: id}, function (res) {
                        if (res.result === 'save_success') {
                            $.bootstrapGrowl("Record deleted successfully.", {
                                ele: 'body',
                                type: 'success',
                                offset: {from: 'top', amount: 80},
                                align: 'right',
                                allow_dismiss: true,
                                stackup_spacing: 10
                            });
                            displayData();
                        } else {
                            $.bootstrapGrowl("Record can not be deleted.", {
                                ele: 'body',
                                type: 'danger',
                                offset: {from: 'top', amount: 80},
                                align: 'right',
                                allow_dismiss: true,
                                stackup_spacing: 10
                            });
                        }
                    }, 'json');

                }
            }
        });
    }


    function addMedicalCollegeDialog() {

        $('#medicalCollegeId').val('');
        $('#medicalCollegeName').val('');
        $('#cityId').find('option:first').attr('selected', 'selected');
        $('#countryId').find('option:first').attr('selected', 'selected');
        $('#addMedicalCollege').modal('show');
    }
    function editRow(id) {
        $('#medicalCollegeId').val(id);
        $.get('clinic.htm?action=getEducationInstitutionById', {medicalCollegeId: id},
                function (obj) {
                    $('#medicalCollegeName').val(obj.TITLE);
                    $('#cityId').val(obj.CITY_ID);
                    $('#countryId').val(obj.COUNTRY_ID);
                    $('#addMedicalCollege').modal('show');
                }, 'json');
    }

</script>
<div class="page-head">
    <!-- BEGIN PAGE TITLE -->
    <div class="page-title">
        <h1>Medical College</h1>
    </div>
</div>
<div class="modal fade" id="addMedicalCollege">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h3 class="modal-title">Add Medical College</h3>

            </div>
            <div class="modal-body">
                <input type="hidden" id="medicalCollegeId" value="">
                <form action="#" role="form" method="post" >
                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group">
                                <label>Medical College Name *</label>
                                <div>
                                    <input type="text" class="form-control" id="medicalCollegeName" placeholder="Name of Educational Institution" >
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group">
                                <label>City</label>
                                <select id="cityId" class="form-control">
                                    <c:forEach items="${requestScope.refData.cities}" var="obj">
                                        <option value="${obj.CITY_ID}"
                                                <c:if test="${obj.CITY_NME=='Lahore'}">
                                                    selected="selected"
                                                </c:if>
                                                >${obj.CITY_NME}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group">
                                <label>Country</label>
                                <select id="countryId" class="form-control">
                                    <c:forEach items="${requestScope.refData.countries}" var="obj">
                                        <option value="${obj.COUNTRY_ID}">${obj.COUNTRY_NME}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div> 
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="saveData();">Save</button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>

    </div>
</div>
<div class="row">
    <div class="col-md-12">
        <div class="portlet box green">
            <div class="portlet-title tabbable-line">
                <div class="caption">
                    Medical College
                </div>
            </div>
            <div class="portlet-body">
                <input type="hidden" id="can_edit" value="${requestScope.refData.CAN_EDIT}">
                <input type="hidden" id="can_delete" value="${requestScope.refData.CAN_DELETE}">
                <form action="#" onsubmit="return false;" role="form" method="post">
                    <div class="row">
                        <div class="col-md-12 text-right" style="padding-top: 23px;">
                            <c:if test="${requestScope.refData.CAN_ADD=='Y'}">
                                <button type="button" class="btn blue" onclick="addMedicalCollegeDialog();"><i class="fa fa-plus-circle"></i> New Medical College</button>
                            </c:if>
                        </div>
                    </div>
                    <br/>
                    <div class="row">
                        <div class="col-md-12">
                            <div id="displayDiv"></div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<%@include file="../footer.jsp"%>
