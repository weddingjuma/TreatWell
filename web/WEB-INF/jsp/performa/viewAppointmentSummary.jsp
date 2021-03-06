<%-- 
    Document   : viewAppointmentSummary
    Created on : Oct 14, 2017, 11:52:36 AM
    Author     : farazahmad
--%>
<%@include file="../header.jsp"%>
<script>
    $(function () {
        $('.date-picker').datepicker({
            format: 'dd-mm-yyyy',
            autoclose: true
        }).on('changeDate', function (e) {
            displayData();

        });
        $('.date-picker').datepicker('setDate', new Date());
        $('#selectDiseases').select2({
            placeholder: "Select an option",
            allowClear: true
        });
        $('#compId').change(function () {
            Appintment.regenerateInvoice();
        });
        if ($('#userType').val() === 'CLINIC') {
            $('#doctorId').select2({
                placeholder: "Select an option",
                allowClear: true
            });
            $('#doctorId').on('change', function (e) {
                displayData();
            });
        }
    });
    function inTakeForm(id, name) {
        document.getElementById("formAppointment").action = "performa.htm?action=addPatientIntake&patientId=" + id + "&name=" + name;
        document.getElementById("formAppointment").target = "_blank";
        document.getElementById("formAppointment").submit();
    }
    function displayData() {
        var $tbl = $('<table class="table table-striped table-bordered table-hover">');
        $tbl.append($('<thead>').append($('<tr>').append(
                $('<th  align="center" width="5%">').html('Sr. #'),
                $('<th  align="center" width="10%">').html('App#'),
                $('<th  align="left" width="25%">').html('Patient Name'),
                $('<th  align="left" width="10%">').html('Time'),
                $('<th  align="center" width="15%">').html('Balance'),
                $('<th  align="center" width="15%">').html('Current Fee'),
                $('<th  align="center" width="20%" colspan="6">').html('Option')
                )));
        $.get('performa.htm?action=getAppointmentsForDate', {appointmentDate: $('#appointmentDate').val(), doctorName: $('#doctorId').val()},
                function (list) {
                    if (list !== null && list.length > 0) {
                        $tbl.append($('<tbody>'));
                        var counter = 1;
                        for (var i = 0; i < list.length; i++) {
                            var prevTotal = eval(list[i].PREVIOUS_TOTAL !== '' ? list[i].PREVIOUS_TOTAL : 0);
                            var currentTotal = eval(list[i].TOTAL_AMNT !== '' ? list[i].TOTAL_AMNT : 0);
                            var collected = eval(list[i].COLLECTED_AMNT !== '' ? list[i].COLLECTED_AMNT : 0);
                            var balance = eval(eval(prevTotal) - collected);
                            var cancelHtm = '<i class="fa fa-ban" aria-hidden="true" title="Cancel Appointment" style="cursor: pointer;" onclick="Appintment.cancelAppointment(\'' + list[i].TW_APPOINTMENT_ID + '\');"></i>';
                            var confirmHtm = '<i class="fa fa-calendar-check-o" aria-hidden="true" title="Confirm Arrival" style="cursor: pointer;" onclick="Appintment.confirmAppointment(\'' + list[i].TW_APPOINTMENT_ID + '\');"></i>';
                            var printHtm = '&nbsp;';
                            var feeHtm = '&nbsp;';
                            var collectFeeHtm = '&nbsp;';

                            if (list[i].STATUS_IND === 'A') {
                                confirmHtm = '<span class="label label-sm label-success">Arrived</span>';
                                cancelHtm = '&nbsp;';
                                printHtm = '<i class="fa fa-print" aria-hidden="true" title="Print Invoice" style="cursor: pointer;" onclick="Appintment.printInvoice(\'' + list[i].TW_APPOINTMENT_ID + '\');"></i>';
                                feeHtm = '<i class="fa fa-cart-plus" aria-hidden="true" title="Add Fee" style="cursor: pointer;" onclick="Appintment.generateInvoice(\'' + list[i].TW_DOCTOR_ID + '\',\'' + list[i].TW_PATIENT_ID + '\',\'' + list[i].TW_APPOINTMENT_ID + '\');"></i>';
                                collectFeeHtm = '<i class="fa fa-archive" aria-hidden="true" title="Collect Fee" style="cursor: pointer;" onclick="Appintment.collectFee(\'' + list[i].TW_APPOINTMENT_ID + '\',\'' + list[i].TW_PATIENT_ID + '\',\'' + balance + '\');"></i>';
                            }
                            if (list[i].STATUS_IND === 'D') {
                                confirmHtm = '<span class="label label-sm label-success">Arrived</span>';
                                cancelHtm = '&nbsp;';
                                printHtm = '<i class="fa fa-print" aria-hidden="true" title="Print Invoice" style="cursor: pointer;" onclick="Appintment.printInvoice(\'' + list[i].TW_APPOINTMENT_ID + '\');"></i>';
                                feeHtm = '<i class="fa fa-cart-plus" aria-hidden="true" title="Add Fee" style="cursor: pointer;" onclick="Appintment.generateInvoice(\'' + list[i].TW_DOCTOR_ID + '\',\'' + list[i].TW_PATIENT_ID + '\',\'' + list[i].TW_APPOINTMENT_ID + '\');"></i>';
                                collectFeeHtm = '<i class="fa fa-archive" aria-hidden="true" title="Collect Fee" style="cursor: pointer;" onclick="Appintment.collectFee(\'' + list[i].TW_APPOINTMENT_ID + '\',\'' + list[i].TW_PATIENT_ID + '\',\'' + balance + '\');"></i>';
                            }
                            if (list[i].STATUS_IND === 'C') {
                                cancelHtm = '<span class="label label-sm label-danger">Cancelled</span>';
                                confirmHtm = '&nbsp;';
                                printHtm = '&nbsp;';
                                feeHtm = '&nbsp;';
                                collectFeeHtm = '&nbsp;';
                            }
                            var recordDate = moment($('#appointmentDate').val(), "DD-MM-YYYY");
                            if (!moment().isSame(recordDate, 'day')) {
                                cancelHtm = '&nbsp;';
                                confirmHtm = '&nbsp;';
                                printHtm = '&nbsp;';
                                feeHtm = '&nbsp;';
                                collectFeeHtm = '&nbsp;';
                            }
                            $tbl.append(
                                    $('<tr>').append(
                                    $('<td align="center">').html(counter++),
                                    $('<td align="center">').html(list[i].APPOINTMENT_NO),
                                    $('<td>').html('<a href="#" onclick="Appintment.viewPatientFeeHistory(\'' + list[i].TW_PATIENT_ID + '\',\'' + list[i].TW_DOCTOR_ID + '\',\'' + list[i].TW_CLINIC_ID + '\');">' + list[i].PATIENT_NME + '</a>'),
                                    $('<td align="left">').html(list[i].APPOINTMENT_TIME),
                                    $('<td align="center" ' + (balance > 0 ? 'class="bg-danger"' : '') + ' >').html((balance < 0 ? '(' + Math.abs(balance) + ')' : Math.abs(balance))),
                                    $('<td align="center">').html('<a href="#" onclick="Appintment.editInvoice(\'' + list[i].TW_APPOINTMENT_ID + '\')">' + currentTotal + '</a>'),
                                    $('<td align="center">').html(confirmHtm),
                                    $('<td align="center">').html(feeHtm),
                                    $('<td align="center">').html((balance > 0 ? collectFeeHtm : '&nbsp;')),
                                    $('<td align="center">').html(cancelHtm),
                                    $('<td align="center">').html(printHtm),
                                    $('<td  align="center">').html('<i class="fa fa-list-ul" aria-hidden="true" title="Click to Submit InTake Form " style="cursor: pointer;" onclick="inTakeForm(\'' + list[i].TW_PATIENT_ID + '\',\'' + list[i].PATIENT_NME + '\');"></i>')

                                    ));
                        }
                        $('#displayDiv').html('');
                        $('#displayDiv').append($tbl);
                        return false;
                    } else {
                        $('#displayDiv').html('');
                        $tbl.append(
                                $('<tr>').append(
                                $('<td class="center aligned negative" colspan="12">').html('<b>No appointment found for this date.</b>')
                                ));
                        $('#displayDiv').append($tbl);
                        return false;
                    }
                }, 'json');
    }
    var Appintment = {
        cancelAppointment: function (id) {
            bootbox.confirm({
                message: "Do you want to cancel appointment?",
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
                        $.post('performa.htm?action=updateAppointmentStatus', {appointmentId: id, status: 'C'}, function (res) {
                            if (res.msg === 'saved') {
                                $.bootstrapGrowl("Appointment cancelled successfully.", {
                                    ele: 'body',
                                    type: 'success',
                                    offset: {from: 'top', amount: 80},
                                    align: 'right',
                                    allow_dismiss: true,
                                    stackup_spacing: 10
                                });
                                displayData();
                            }
                        }, 'json');

                    }
                }
            });
        }, confirmAppointment: function (id) {
            bootbox.confirm({
                message: "You are going to confirm appointment. Are you sure?",
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
                        $.post('performa.htm?action=updateAppointmentStatus', {appointmentId: id, status: 'A'}, function (res) {
                            if (res.msg === 'saved') {
                                $.bootstrapGrowl("Appointment confirmed successfully.", {
                                    ele: 'body',
                                    type: 'success',
                                    offset: {from: 'top', amount: 80},
                                    align: 'right',
                                    allow_dismiss: true,
                                    stackup_spacing: 10
                                });
                                displayData();
                            }
                        }, 'json');
                    }
                }
            });
        }, collectFee: function (appointmentId, patientId, balance) {
            $('#collectedFee').val(balance);
            $('#collectedFeeAppointId').val(appointmentId);
            $('#collectedFeePatientId').val(patientId);
            $('#totalFeeCollected').val('0');
            $('#collectFeeDialog').modal('show');
        }, saveCollectedFee: function () {
            if ($('#totalFeeCollected').val() === '' || $('#totalFeeCollected').val() === '0') {
                $('#totalFeeCollected').notify('Please enter amount.', 'error');
                $('#totalFeeCollected').focus();
                return false;
            }
            if ($('#totalFeeCollected').val() > $('#collectedFee').val()) {
                $('#totalFeeCollected').notify('Please enter Correct Amount.', 'error');
                $('#totalFeeCollected').focus();
                return false;
            }
            $.post('performa.htm?action=saveCollectedFee', {appointmentId: $('#collectedFeeAppointId').val(),
                patientId: $('#collectedFeePatientId').val(), feeCollected: $('#totalFeeCollected').val()}, function (obj) {
                if (obj.msg === 'saved') {
                    $.bootstrapGrowl("Fee saved successfully.", {
                        ele: 'body',
                        type: 'success',
                        offset: {from: 'top', amount: 80},
                        align: 'right',
                        allow_dismiss: true,
                        stackup_spacing: 10
                    });
                    $('#totalFeeCollected').val('0');
                    $('#collectFeeDialog').modal('hide');
                    displayData();
                } else {
                    $.bootstrapGrowl("Error in saving Fee. Please try again later.", {
                        ele: 'body',
                        type: 'danger',
                        offset: {from: 'top', amount: 80},
                        align: 'right',
                        allow_dismiss: true,
                        stackup_spacing: 10
                    });
                }
            }, 'json');
        }, generateInvoice: function (doctorId, patientId, appointmentId) {
            $('#addFeeDialog').modal('show');
            $('#totalFee').val('0');
            $('#patientId').val(patientId);
            $('#appointmentDocId').val(doctorId);
            $('#appointmentId').val(appointmentId);
            displayPanelCompany(doctorId);
            Appintment.regenerateInvoice();
        }, regenerateInvoice: function () {
//            $('#appointmentId').val(appointmentId);
            $('#displayProceduredTbl').find('tbody').find('tr').remove();
            $.get('performa.htm?action=getDoctorProcedure', {appointmentId: $('#appointmentId').val(), doctorList: $('#appointmentDocId').val(), companyId: $('#compId').val()},
                    function (list) {
                        if (list !== null && list.length > 0) {
                            for (var i = 0; i < list.length; i++) {
                                var htm = '<tr>';
                                htm += '<td>';
                                htm += '<input type="checkbox" class="form-control icheck" value="' + list[i].TW_MEDICAL_PROCEDURE_ID + '" onclick="calculateTotal();">';
                                htm += '</td>';
                                htm += '<td style="padding-top:20px;">' + list[i].TITLE + '</td>';
                                htm += '<td style="padding-top:15px;"><div class="form-group">';
                                htm += '<input type="text" class="form-control input-sm" value="' + list[i].FEE + '" onblur="calculateTotal();">';
                                htm += '</div></td>';
                                htm += '</tr>';
                                $('#displayProceduredTbl').append(htm);
                            }
                        } else {
                            var htm = '<tr>';
                            htm += '<td colspan="2">No procdure added for doctor. Please add procedures first.';
                            htm += '</td>';
                            htm += '</tr>';
                            $('#displayProceduredTbl').append(htm);
                        }
                    }, 'json');
        }, printInvoice: function (id) {
            //$('#printPreviewDialog').modal('show');
            document.getElementById("formAppointment").action = 'report.htm?action=reportFeeReceipt&appointmentId=' + id;
            document.getElementById("formAppointment").target = '_blank';
            document.getElementById("formAppointment").submit();
        }, editInvoice: function (appointmentId) {
            $('#displayProceduredTblEdit').find('tbody').find('tr').remove();
            $.get('performa.htm?action=getProcedureFeeForAppointment', {doctorList: appointmentId},
                    function (list) {
                        if (list !== null && list.length > 0) {
                            for (var i = 0; i < list.length; i++) {
                                var htm = '<tr>';
                                htm += '<td style="padding-top:20px;">' + list[i].PROCEDURE_NME + '</td>';
                                htm += '<td style="padding-top:15px;"><div class="form-group">';
                                htm += '<input type="text" class="form-control input-sm" value="' + list[i].FEE_AMNT + '" readOnly="" >';
                                htm += '</div></td>';
                                htm += '<td style="padding-top:15px;">';
                                htm += '<i class="fa fa-trash" aria-hidden="true" onclick="Appintment.deleteProcedure(\'' + list[i].TW_APPOINTMENT_FEE_ID + '\')""></i>';
                                htm += '</td>';
                                htm += '</tr>';
                                $('#displayProceduredTblEdit').append(htm);
                            }
                        } else {
                            var htm = '<tr>';
                            htm += '<td colspan="2">No procdure added for doctor. Please add procedures first.';
                            htm += '</td>';
                            htm += '</tr>';
                            $('#displayProceduredTblEdit').append(htm);
                        }
                        $('#editFeeDialog').modal('show');
                    }, 'json');
        }, deleteProcedure: function (id) {
            bootbox.confirm({
                message: "Do you want to delete procedure?", buttons: {
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
                        $.post('performa.htm?action=deleteAppointmentProcedure', {id: id}, function (res) {
                            if (res.result === 'save_success') {
                                $.bootstrapGrowl("Record deleted successfully.", {
                                    ele: 'body',
                                    type: 'success',
                                    offset: {from: 'top', amount: 80},
                                    align: 'right',
                                    allow_dismiss: true,
                                    stackup_spacing: 10
                                });
                                $('#editFeeDialog').modal('hide');
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
        }, viewPatientFeeHistory: function (patientId, docId, clinicId) {
            $('#displayFeeHistoryTbl').find('tbody').find('tr').remove();
            $.get('performa.htm?action=getPatientFeeHistory', {patientId: patientId, doctorId: docId, clinicId: clinicId},
                    function (list) {
                        if (list !== null && list.length > 0) {
                            for (var i = 0; i < list.length; i++) {
                                var htm = '<tr>';
                                htm += '<td>' + list[i].APPOINTMENT_NO + '</td>';
                                htm += '<td>' + list[i].PREPARED_DTE + '</td>';
                                htm += '<td>' + list[i].FEE_AMNT + '</td>';
                                htm += '</tr>';
                                $('#displayFeeHistoryTbl').append(htm);
                            }
                        } else {
                            var htm = '<tr>';
                            htm += '<td colspan="3">No record available.';
                            htm += '</td>';
                            htm += '</tr>';
                            $('#displayFeeHistoryTbl').append(htm);
                        }
                        $('#feeHistoryDialog').modal('show');
                    }, 'json');
        }
    };
    function calculateTotal() {
        var total = 0;
        var tr = $('#displayProceduredTbl').find('tbody').find('tr');
        $.each(tr, function (i, o) {
            var td = $(o).find('td');
            var isChecked = false;
            $.each(td, function (ind, obj) {
                if (ind === 0) {
                    if ($(obj).find('input:checkbox').is(':checked')) {
                        isChecked = true;
                    }
                }
                if (ind === 2) {
                    if (isChecked) {
                        total += eval($(obj).find('input:text').val() !== '' ? $(obj).find('input:text').val() : 0);
                    }
                }
            });
        });
        $('#totalFee').val(total);
    }
    function saveData() {
        var selectedId = [];
        var fee = [];
        var tr = $('#displayProceduredTbl').find('tbody').find('tr');
        $.each(tr, function (i, o) {
            var td = $(o).find('td');
            var isChecked = false;
            $.each(td, function (ind, obj) {
                if (ind === 0) {
                    if ($(obj).find('input:checkbox').is(':checked')) {
                        selectedId.push($(obj).find('input:checkbox').val());
                        isChecked = true;
                    }
                }
                if (ind === 2) {
                    if (isChecked) {
                        fee.push($(obj).find('input:text').val());
                    }
                }
            });
        });
        $.post('performa.htm?action=saveAppointmentFee', {'selectedId[]': selectedId, 'feeArr[]': fee,
            appointmentId: $('#appointmentId').val(), companyId: $('#compId').val(),
            patientId: $('#patientId').val()}, function (obj) {
            if (obj.msg === 'saved') {
                //Appintment.printInvoice($('#appointmentId').val());
                $.bootstrapGrowl("Fee saved successfully.", {
                    ele: 'body',
                    type: 'success',
                    offset: {from: 'top', amount: 80},
                    align: 'right',
                    allow_dismiss: true,
                    stackup_spacing: 10
                });
                $('#addFeeDialog').modal('hide');
                displayData();
            } else {
                $.bootstrapGrowl("Error in saving data. Please try again later.", {
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
    function displayPanelCompany(doctorId) {
        $('#compId').find('option').remove();
        $('<option />', {value: '', text: 'General patient'}).appendTo($('#compId'));
        $.get('setup.htm?action=getPanelCompaniesForDoctors', {doctorId: doctorId},
                function (list) {
                    if (list !== null && list.length > 0) {
                        for (var i = 0; i < list.length; i++) {
                            $('<option />', {value: list[i].TW_COMPANY_ID, text: list[i].COMPANY_NME}).appendTo($('#compId'));

                        }
                    }
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
                //displayData();
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
    jQuery.fn.getCheckboxVal = function () {
        var vals = [];
        var i = 0;
        this.each(function () {
            vals[i++] = jQuery(this).val();
        });
        return vals;
    };
</script>
<input type="hidden" id="userType" value="${requestScope.refData.userType}">
<input type="hidden" id="collectedFee" value="">
<div class="page-head">
    <div class="page-title">
        <h1>Appointments Summary</h1>
    </div>
</div>
<div class="modal fade" id="addFeeDialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h3 class="modal-title">Add Procedures</h3>
            </div>
            <div class="modal-body">
                <input type="hidden" id="patientId" value="">
                <input type="hidden" id="appointmentId" value="">
                <input type="hidden" id="appointmentDocId" value="">
                <input type="hidden" id="panelCompanyId" value="">
                <div class="portlet box green">
                    <div class="portlet-body">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label>Company Name</label>
                                    <select id="compId" class="form-control">
                                    </select>
                                </div>
                            </div>
                        </div>
                        <table class="table table-striped table-condensed" id="displayProceduredTbl">
                            <thead>
                                <tr>
                                    <th>Select</th>
                                    <th>Procedure</th>
                                    <th>Fee</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label>Total Fee</label>
                                    <input type="text" class="form-control" id="totalFee" readonly="" >
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="saveData();">Apply Fee</button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="editFeeDialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h3 class="modal-title">Procedures</h3>
            </div>
            <div class="modal-body">
                <div class="portlet box green">
                    <div class="portlet-body">
                        <table class="table table-striped table-condensed" id="displayProceduredTblEdit">
                            <thead>
                                <tr>
                                    <th>Procedure</th>
                                    <th>Fee</th>
                                    <th>Delete</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="collectFeeDialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h3 class="modal-title">Collect Fee</h3>
            </div>
            <div class="modal-body">
                <div class="portlet box green">
                    <div class="portlet-body">
                        <input type="hidden" id="collectedFeeAppointId" value="">
                        <input type="hidden" id="collectedFeePatientId" value="">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label>Collected Fee</label>
                                    <input type="text" class="form-control" id="totalFeeCollected" onkeyup="onlyInteger(this);" >
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="Appintment.saveCollectedFee();">Save Fee</button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="feeHistoryDialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h3 class="modal-title">Fee History</h3>
            </div>
            <div class="modal-body">
                <div class="portlet box green">
                    <div class="portlet-body">
                        <table class="table table-striped table-condensed" id="displayFeeHistoryTbl">
                            <thead>
                                <tr>
                                    <th>Appointment#</th>
                                    <th>Date</th>
                                    <th>Total Fee</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
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
                                                    <c:if test="${i.count%3==0}">
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
        <div class="portlet box green">
            <div class="portlet-body">
                <form action="#" onsubmit="return false;" role="form" id="formAppointment" method="post">
                    <div class="form-body">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Appointment Date</label>
                                    <div class="input-group input-medium date date-picker">
                                        <input type="text" class="form-control" id="appointmentDate" readonly="">
                                        <span class="input-group-btn">
                                            <button class="btn default" type="button"><i class="fa fa-calendar"></i></button>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <c:choose>
                                <c:when test="${requestScope.refData.userType=='CLINIC'}">
                                    <div class="col-md-4">
                                        <div class="form-group">
                                            <label>Select Doctor</label>
                                            <select id="doctorId" class="select2_category form-control" data-placeholder="Choose a Doctor">
                                                <c:forEach items="${requestScope.refData.doctors}" var="obj" varStatus="i">
                                                    <option value="${obj.TW_DOCTOR_ID}">${obj.DOCTOR_NME}</option>
                                                </c:forEach>
                                            </select>

                                        </div>
                                    </div>
                                </c:when>
                            </c:choose>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div id="displayDiv">

                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div id="displayCompanyPatientsDiv">

                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<%@include file="../footer.jsp"%>
