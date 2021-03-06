<%-- 
    Document   : addPanelPatient
    Created on : Nov 9, 2017, 7:09:49 PM
    Author     : Cori 5
--%>
<%@include file="../header.jsp"%>
<style>
    .input-medium {
    width: 260px !important;
}
    </style>
<script>
    $(function () {
        $('.date-picker').datepicker({
            format: 'dd-mm-yyyy',
            autoclose: true
        });
        if ($('#searchTopPatient').val() !== '') {
            displayData();
        }
        if ($('#addNewPatientBtnClicked').val() === 'Y') {
            addPatientDialog();
        }
               
//        $('#panelId').select2({
//            placeholder: "Select an option",
//            allowClear: true
//        });


        $('.icheck').iCheck({
            checkboxClass: 'icheckbox_minimal',
            radioClass: 'iradio_minimal',
            increaseArea: '20%' // optional
        });

    });

    function saveData() {
//        if ($.trim($('#patientId').val()) === '') {
//            if ($.trim($('#userName').val()) === '') {
//                $('#userName').notify('User Name is Required Field', 'error', {autoHideDelay: 15000});
//                $('#userName').focus();
//                return false;
//            }
//            if ($.trim($('#password').val()) === '') {
//                $('#password').notify('Password is Required Field', 'error', {autoHideDelay: 15000});
//                $('#password').focus();
//                return false;
//            }
//            if ($.trim($('#reTypePassword').val()) === '') {
//                $('#reTypePassword').notify('ReType Password Field is Required', 'error', {autoHideDelay: 15000});
//                $('#reTypePassword').focus();
//                return false;
//            }
//
//            if ($.trim($('#password').val()) !== $.trim($('#reTypePassword').val())) {
//                $('#reTypePassword').notify('Please corfirm the same password', 'error', {autoHideDelay: 15000});
//                $('#reTypePassword').focus();
//                return false;
//            }
//        }

        if ($.trim($('#patientName').val()) === '') {
            $('#patientName').notify('Patient Name is Required Field', 'error', {autoHideDelay: 15000});
            $('#patientName').focus();
            return false;
        }
        if ($.trim($('#contactNo').val()) === '') {
            $('#contactNo').notify('Contact is Required Field', 'error', {autoHideDelay: 15000});
            $('#contactNo').focus();
            return false;
        }

        // var password = calcMD5($('#password').val());
        var obj = {patientId: $('#patientId').val(), email: $('#email').val(),
            patientName: $('#patientName').val(), contactNo: $('#contactNo').val(), age: $('#age').val(),
            patientWeight: $('#patientWeight').val(), patientHeight: $('#patientHeight').val(),
            expiryDate: $('#expiryDate').val(),
            panelId: $('#panelId').val(),
            patientAddress: $('#patientAddress').val(), gender: $('input[name=gender]:checked').val()

        };
        $.post('setup.htm?action=savePatient', obj, function (obj) {
            if (obj.result === 'save_success') {
                $('#addPatient').modal('hide');
                $.bootstrapGrowl("Patient Data saved successfully.", {
                    ele: 'body',
                    type: 'success',
                    offset: {from: 'top', amount: 80},
                    align: 'right',
                    allow_dismiss: true,
                    stackup_spacing: 10
                });
                $('input:text').val('');
                $('#patientAddress').val('');
                $('#patientId').val('');
                $('#addPatient').modal('hide');
                displayData();
                return false;
            } else {
                $.bootstrapGrowl("Error in saving Patient. Please check if this mobile no. already exists.", {
                    ele: 'body',
                    type: 'danger',
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

    function addPatientDialog() {
        $('#patientId').val('');
        $('#patientName').val('');
        $('#email').val('');
        $('#contactNo').val('');
        $('#age').val('');
        $('#dob').val('');
        $('#expiryDate').val('');
        $('#patientWeight').val('');
        $('#patientHeight').val('');
        $('#patientAddress').val('');
        $('#panelId').find('option:first').attr('selected', 'selected');
        $('#addPatient').modal('show');
    }


    function inTakeForm(id) {
        $('#patientId').val(id);
        $('.icheck').iCheck({
            checkboxClass: 'icheckbox_minimal',
            radioClass: 'iradio_minimal',
            increaseArea: '20%' // optional
        });
        $.get('setup.htm?action=getPatientById', {patientId: id},
                function (obj) {
                    $('input:radio[name="smoker"][value="' + obj.SMOKER_IND + '"]').iCheck('check');
                    $('input:radio[name="allergy"][value="' + obj.ANY_ALLERGY + '"]').iCheck('check');
                    $('input:radio[name="medicineOpt"][value="' + obj.TAKE_MEDICINE + '"]').iCheck('check');
                    $('input:radio[name="steroidOpt"][value="' + obj.TAKE_STEROID + '"]').iCheck('check');
                    $('input:radio[name="attendClinic"][value="' + obj.ATTEND_CLINIC + '"]').iCheck('check');
                    $('input:radio[name="Rheumatic"][value="' + obj.ANY_FEVER + '"]').iCheck('check');
                    $('input:checkbox[name="patientDiseases"]').iCheck('uncheck');
                    $.get('setup.htm?action=getPatientDisease', {patientId: id},
                            function (list) {
                                if (list !== null && list.length > 0) {
                                    for (var i = 0; i < list.length; i++) {
                                        $('input:checkbox[name="patientDiseases"][value="' + list[i].TW_DISEASE_ID + '"]').iCheck('check');
                                    }
                                } else {

                                }
                            }, 'json');
                    $('#inTakeForm').modal('show');
                }, 'json');
    }

    function addIntakeForm() {
        $('#inTakeForm').modal('show');
        var obj = {patientId: $('#patientId').val(),
            attendClinic: $('input[name=attendClinic]:checked').val(),
            medicineOpt: $('input[name=medicineOpt]:checked').val(),
            steroidOpt: $('input[name=steroidOpt]:checked').val(),           
            allergy: $('input[name=allergy]:checked').val(),
            Rheumatic: $('input[name=Rheumatic]:checked').val(),
            smoker: $('input[name=smoker]:checked').val(),
            'diseasesarr[]': $("input[name='patientDiseases']:checked").getCheckboxVal()
        };
        $.post('setup.htm?action=saveInTakeForm', obj, function (obj) {
            if (obj.result === 'save_success') {
                $('#addPatient').modal('hide');
                $.bootstrapGrowl("Patient Data saved successfully.", {
                    ele: 'body',
                    type: 'success',
                    offset: {from: 'top', amount: 80},
                    align: 'right',
                    allow_dismiss: true,
                    stackup_spacing: 10
                });
                $('input:text').val('');
                $('#patientId').val('');
                $('#inTakeForm').modal('hide');
                displayData();
                return false;
            } else {
                $.bootstrapGrowl("Error in saving Patient. Please check if this mobile no. already exists.", {
                    ele: 'body',
                    type: 'danger',
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


    function saveDisease() {
        var obj = {
            patientId: $('#patientId').val(),
            'diseasesarr[]': $("input[name='patientDiseases']:checked").getCheckboxVal()
        };
          console.log(obj);
        $.post('setup.htm?action=saveDiseasesForm', obj, function (obj) {
            if (obj.result === 'save_success') {
                $('#addPatient').modal('hide');
                $.bootstrapGrowl("Patient Data saved successfully.", {
                    ele: 'body',
                    type: 'success',
                    offset: {from: 'top', amount: 80},
                    align: 'right',
                    allow_dismiss: true,
                    stackup_spacing: 10
                });


                $('#inTakeForm').modal('hide');
                displayData();
                return false;
            } else {
                $.bootstrapGrowl("Error in saving Patient. Please check if this mobile no. already exists.", {
                    ele: 'body',
                    type: 'danger',
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

    function editRow(id) {
        $('#patientId').val(id);
        $('#loginDetails').hide();
        $.get('setup.htm?action=getPatientById', {patientId: id},
                function (obj) {
                    $('#patientName').val(obj.PATIENT_NME);
                    $('#email').val(obj.EMAIL);
                    $('#contactNo').val(obj.MOBILE_NO);
                    $('#age').val(obj.AGE);
                    $('#expiryDate').val(obj.EXPIRY_DTE);
                    //$('#dob').val(obj.DOB);
                    $('input:radio[name="gender"][value="' + obj.GENDER + '"]').iCheck('check');
                    $('#panelId').val(obj.TW_COMPANY_ID);
                     $('#patientWeight').val(obj.WEIGHT);
                    $('#patientHeight').val(obj.HEIGHT);
                    $('#patientAddress').val(obj.ADDRESS);
                    $('#addPatient').modal('show');
                }, 'json');
    }

    jQuery.fn.getCheckboxVal = function () {
        var vals = [];
        var i = 0;
        this.each(function () {
            vals[i++] = jQuery(this).val();
        });
        return vals;
    };
</script>
<div class="page-head">
    <!-- BEGIN PAGE TITLE -->
    <div class="page-title">
        <h1>Patient Registration</h1>
    </div>
</div>
<input type='hidden' id="searchTopPatient" value="${requestScope.refData.searchTopPatient}">
<input type='hidden' id="addNewPatientBtnClicked" value="${requestScope.refData.addNewPatient}">
<div class="modal fade" id="addPatient">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h3 class="modal-title">Add Patient</h3>
            </div>
            <div class="modal-body">
                <input type="hidden" id="patientId" value="">
                <div class="portlet box green">
                    <div class="portlet-title tabbable-line">
                        <div class="caption">
                            Personal Info 
                        </div>
                    </div>
                    <div class="portlet-body">
                         <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                <label>Panel Company Name *</label>
                                <select id="panelId" class="form-control select2_category" data-placeholder="Choose a Panel Company">
                                    <option value='NONE'>None</option>
                                    <c:forEach items="${requestScope.refData.panelCompanyList}" var="obj">
                                        <option value="${obj.TW_COMPANY_ID}">${obj.COMPANY_NME}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                <label>Expiry Date</label>
                                <div class="input-group input-medium date date-picker">
                                    <input type="text" id="expiryDate" class="form-control" readonly="">
                                    <span class="input-group-btn">
                                        <button class="btn default" type="button"><i class="fa fa-calendar"></i></button>
                                    </span>
                                </div>
                            </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-8">
                                <div class="form-group">
                                    <label>Patient Name*</label>
                                    <div>
                                        <input type="text" class="form-control" id="patientName" placeholder="Patient Name" >
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Contact No.*</label>
                                    <div>
                                        <input type="text" class="form-control" id="contactNo" placeholder="Contact No." onkeyup="onlyInteger(this);" maxlength="11" onblur="Util.validatePatientNo(this);">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-10">
                                <div class="form-group">
                                    <label>Email</label>
                                    <div>
                                        <input type="text" class="form-control" id="email" placeholder="Email" >
                                    </div>
                                </div>

                            </div>
                            <div class="col-md-2">
                                <div class="form-group">
                                    <label>Age</label>
                                    <input type="text" class="form-control" id="age" placeholder="Age" onkeyup="onlyInteger(this);">
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Weight (KG)</label>
                                    <input type="text" class="form-control" id="patientWeight" onkeyup="onlyInteger(this);">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label>Height (Feet)</label>
                                    <input type="text" class="form-control" id="patientHeight" onkeyup="onlyInteger(this);">
                                </div>
                            </div>
                        </div> 
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Gender</label>
                                    <div class="input-group">
                                        <div class="icheck-inline">
                                            <label>
                                                <input type="radio" name="gender" value="M" id="genderM" class="icheck" checked> Male </label>
                                            <label>
                                                <input type="radio" name="gender" value="F" id="genderF" class="icheck"> Female</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>                   
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label>Address</label>
                                    <textarea class="form-control" id="patientAddress" rows="3" cols="63"></textarea>
                                </div>
                            </div>   
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="save" onclick="saveData();">Save</button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="inTakeForm">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h3 class="modal-title">In Take Form</h3>
            </div>
            <div class="modal-body">
                <input type="hidden" id="patientId" value="">               
                <div class="portlet box green">
                    <div class="portlet-title tabbable-line">
                        <div class="caption">
                            Medical History 
                        </div>
                    </div>
                    <div class="portlet-body">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Attending any clinic?</label>
                                    <div class="input-group">
                                        <div class="icheck-inline">
                                            <label>
                                                <input type="radio" name="attendClinic" value="Y" class="icheck" checked> Yes </label>
                                            <label>
                                                <input type="radio" name="attendClinic" value="N"  class="icheck"> No</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Taking any medicine?</label>
                                    <div class="input-group">
                                        <div class="icheck-inline">
                                            <label>
                                                <input type="radio" name="medicineOpt" value="Y" class="icheck" checked> Yes </label>
                                            <label>
                                                <input type="radio" name="medicineOpt" value="N"  class="icheck"> No</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Taking any steroid?</label>
                                    <div class="input-group">
                                        <div class="icheck-inline">
                                            <label>
                                                <input type="radio" name="steroidOpt" value="Y" class="icheck" checked> Yes </label>
                                            <label>
                                                <input type="radio" name="steroidOpt" value="N"  class="icheck"> No</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Allergy from any medicine/food?</label>
                                    <div class="input-group">
                                        <div class="icheck-inline">
                                            <label>
                                                <input type="radio" name="allergy" value="Y" class="icheck" checked> Yes </label>
                                            <label>
                                                <input type="radio" name="allergy" value="N"  class="icheck"> No</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Have any Rheumatic fever or cholera?</label>
                                    <div class="input-group">
                                        <div class="icheck-inline">
                                            <label>
                                                <input type="radio" name="Rheumatic" value="Y" class="icheck" checked> Yes </label>
                                            <label>
                                                <input type="radio" name="Rheumatic" value="N"  class="icheck"> No</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label> Are you smoker?</label>
                                    <div class="input-group">
                                        <div class="icheck-inline">
                                            <label>
                                                <input type="radio" name="smoker" value="Y" class="icheck" checked> Yes </label>
                                            <label>
                                                <input type="radio" name="smoker" value="N"  class="icheck"> No</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>   
                </div>
                <div class="portlet box green">
                    <div class="portlet-title tabbable-line">
                        <div class="caption">
                            Diseases 
                        </div>
                    </div>
                    <div class="portlet-body">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group" id="diseases">
                                    <table class="table table-condensed" width="100%">
                                        <tbody>
                                            <c:forEach items="${requestScope.refData.diseases}" var="obj" varStatus="i">
                                                <c:if test="${i.count==1}">
                                                    <tr>
                                                    </c:if>
                                                    <td>
                                                        <input type="checkbox" name="patientDiseases" class="icheck"  value="${obj.TW_DISEASE_ID}">${obj.TITLE}
                                                    </td>
                                                    <c:if test="${i.count%4==0}">
                                                    </tr>
                                                    <tr>
                                                    </c:if>
                                                </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div> 
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="addIntakeForm();
                        saveDisease();">Save </button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col-md-12">
        <div class="portlet-body">
            <input type="hidden" id="can_edit" value="${requestScope.refData.CAN_EDIT}">
            <input type="hidden" id="can_delete" value="${requestScope.refData.CAN_DELETE}">
            <form name="doctorform" action="#" role="form" onsubmit="return false;" method="post">
                <div class="portlet box green">
                    <div class="portlet-title">
                        <div class="caption">
                            Search Patient
                        </div>
                    </div>
                    <div class="portlet-body">
                        <div class="row">
                            <div class="col-md-5">
                                <div class="form-group">
                                    <label>Patient Name</label>
                                    <div>
                                        <input type="text" class="form-control" id="patientNameSearch" placeholder="Search by patient name" value="${requestScope.refData.searchTopPatient}">
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-5">
                                <div class="form-group">
                                    <label>Contact No.</label>
                                    <div>
                                        <input type="text" class="form-control" id="contactNoSearch" placeholder="Search by patient's contact no." >
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6" style="padding-top: 23px;">
                                <button type="button" class="btn green" onclick="displayData();"><i class="fa fa-search"></i> Search Patient</button>
                            </div>
                            <div class="col-md-6 text-right" style="padding-top: 23px;">
                                <c:if test="${requestScope.refData.CAN_ADD=='Y'}">
                                    <button type="button" class="btn blue" onclick="addPatientDialog();"><i class="fa fa-plus-circle"></i> New Patient</button>
                                </c:if>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12 ">
                                <div id="displayDiv" style="padding-top: 20px;">

                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </form>
        </div>
    </div>
</div>
<script>
    function displayData() {
        var $tbl = $('<table class="table table-striped table-bordered table-hover">');
        $tbl.append($('<thead>').append($('<tr>').append(
                $('<th  width="5%">').html('Sr. #'),
                $('<th width="15%">').html('Patient Name'),
                $('<th  width="20%">').html('Contact No'),
                $('<th align="center" width="10%">').html('Gender'),
                $('<th align="center" width="25%">').html('Company Name'),
                $('<th  width="15%" colspan="3">').html('&nbsp;')
                )));
        $.get('setup.htm?action=getPanelPatient', {patientNameSearch: $('#patientNameSearch').val(), contactNoSearch: $('#contactNoSearch').val()},
                function (list) {
                    if (list !== null && list.length > 0) {
                        $tbl.append($('<tbody>'));
                        for (var i = 0; i < list.length; i++) {
                            var editHtm = '<i class="fa fa-pencil-square-o" aria-hidden="true" title="Click to Edit" style="cursor: pointer;" onclick="editRow(\'' + list[i].TW_PATIENT_ID + '\',\'' + list[i].TW_PATIENT_ID + '\');"></i>';
                            var delHtm = '<i class="fa fa-trash-o" aria-hidden="true" title="Click to Delete" style="cursor: pointer;" onclick="deleteRow(\'' + list[i].TW_PATIENT_ID + '\');"></i>';
                            if ($('#can_edit').val() !== 'Y') {
                                editHtm = '&nbsp;';
                            }
                            if ($('#can_delete').val() !== 'Y') {
                                delHtm = '&nbsp;';
                            }
                            $tbl.append(
                                    $('<tr>').append(
                                    $('<td  align="center">').html(eval(i + 1)),
                                    $('<td>').html(list[i].PATIENT_NME),
                                    $('<td>').html(list[i].MOBILE_NO),
                                    $('<td >').html((list[i].GENDER === 'M' ? 'MALE' : 'FEMALE')),
                                    $('<td>').html(list[i].COMPANY_NME),
                                    $('<td align="center">').html(editHtm),
                                    $('<td  align="center">').html(delHtm),
                                    $('<td  align="center">').html('<i class="fa fa-list-ul" aria-hidden="true" title="Click to Submit InTake Form " style="cursor: pointer;" onclick="inTakeForm(\'' + list[i].TW_PATIENT_ID + '\');"></i>')
                                    ));
                        }
                        $('#displayDiv').html('');
                        $('#displayDiv').append($tbl);
                        return false;
                    } else {
                        $('#displayDiv').html('');
                        $tbl.append(
                                $('<tr>').append(
                                $('<td  colspan="7">').html('<b>No matching record found.</b>' + '&nbsp;&nbsp;&nbsp;<button type="button" class="btn blue" onclick="addPatientDialog();"><i class="fa fa-plus-circle"></i> New Patient</button>')
                                ));
                        $('#displayDiv').append($tbl);
                        return false;
                    }
                }, 'json');
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
                    $.post('setup.htm?action=deletePatient', {id: id}, function (res) {
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
</script>
<%@include file="../footer.jsp"%>

