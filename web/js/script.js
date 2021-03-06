/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
var Util = {
    validateUser: function (field) {
        if (field.value !== '') {
            $(field).addClass('spinner');
            $.get('ums.htm?action=validateUserName', {userName: field.value}, function (res) {
                $(field).removeClass('spinner');
                if (res.msg === 'invalid') {
                    field.value = '';
                    $(field).notify('Login Id is. already registered. Please enter a new Login Id.', 'error');
                    $(field).focus();
                }
            }, 'json');
        }
        return false;
    }, validatePatientNo: function (field) {
        if (field.value !== '') {
            $(field).addClass('spinner');
            $.get('setup.htm?action=validatePatientContact', {contactNo: field.value}, function (res) {
                $(field).removeClass('spinner');
                if (res.msg === 'invalid') {
                    field.value = '';
                    $(field).notify('Mobile no. is already registered. Please enter a new number.', 'error');
                    $(field).focus();
                }
            }, 'json');
        }
        return false;
    }, validateDoctorNo: function (field) {
        if (field.value !== '') {
            $(field).addClass('spinner');
            $.get('setup.htm?action=validateDoctorContact', {contactNo: field.value}, function (res) {
                $(field).removeClass('spinner');
                if (res.msg === 'invalid') {
                    field.value = '';
                    $(field).notify('Mobile no. is already in used.', 'error');
                    $(field).focus();
                }
            }, 'json');
        }
        return false;
    }, validateStudentNo: function (field) {
        if (field.value !== '') {
            $(field).addClass('spinner');
            $.get('setup.htm?action=validateStudentContact', {contactNo: field.value}, function (res) {
                $(field).removeClass('spinner');
                if (res.msg === 'invalid') {
                    field.value = '';
                    $(field).notify('Mobile no. is already in used.', 'error');
                    $(field).focus();
                }
            }, 'json');
        }
        return false;
    }, validateDoctorLoginId: function (field) {
        if (field.value !== '') {
            $(field).addClass('spinner');
            $.get('ums.htm?action=validateUserName', {userName: field.value}, function (res) {
                $(field).removeClass('spinner');
                if (res.msg === 'invalid') {
                    field.value = '';
                    $(field).notify('Login ID already taken. please enter new ID.', 'error');
                    $(field).focus();
                }
            }, 'json');
        }
        return false;
    }, validatePharmacyStoreLoginId: function (field) {
        if (field.value !== '') {
            $(field).addClass('spinner');
            $.get('ums.htm?action=validateUserName', {userName: field.value}, function (res) {
                $(field).removeClass('spinner');
                if (res.msg === 'invalid') {
                    field.value = '';
                    $(field).notify('Login ID already taken. please enter new ID.', 'error');
                    $(field).focus();
                }
            }, 'json');
        }
        return false;
    }
    , validateCollectionCenterLoginId: function (field) {
        if (field.value !== '') {
            $(field).addClass('spinner');
            $.get('ums.htm?action=validateUserName', {userName: field.value}, function (res) {
                $(field).removeClass('spinner');
                if (res.msg === 'invalid') {
                    field.value = '';
                    $(field).notify('Login ID already taken. please enter new ID.', 'error');
                    $(field).focus();
                }
            }, 'json');
        }
        return false;
    }
};
function onlyInteger(obj) {
    var str1 = obj.value;
    str1 = str1.replace(/[^\d]/g, '');
    obj.value = str1;
}
//Function to check only Double
function onlyDouble(field) {
    field.value = field.value.replace(/[^\.\d]/g, "");
}
function onlyDoubleWithMinus(field) {
    field.value = field.value.replace(/[^\-\.\d]/g, "");
}
function onlyIntegerWithSpecialChar(obj) {
    var str1 = obj.value;
    str1 = str1.replace(/[^\d\.\*,$,%]/g, '');
    obj.value = str1;
}

function onlyChar(field) {
    field.value = field.value.replace(/[^\a-z,A-Z]/g, "");
}

function onlyCharWithSpace(field) {
    field.value = field.value.replace(/[^\ \a-z,A-Z]/g, "");
}

function onlyCharWithDot(field) {
    field.value = field.value.replace(/[^\.\a-z,A-Z]/g, "");
}

function onlyCharWithPlusSign(field) {
    field.value = field.value.replace(/[^\+\a-z,A-Z]/g, "");
}

function onlyCharWithSpecialCharacter(field) {
    field.value = field.value.replace(/[^\.\ \-\a-z,A-Z]/g, "");
}
function onlyCharForLoginId(field) {
    field.value = field.value.replace(/[^\a-z,A-Z,\-,.,_,\d\/]/g, "");
}
function alphaNumeric(field) {
    field.value = field.value.replace(/[^\a-z,A-Z,\-,., ,_,\d\/]/g, "");
}
function addCommas(nStr) {
    nStr += '';
    x = nStr.split('.');
    x1 = x[0];
    x2 = x.length > 1 ? '.' + x[1] : '';
    var rgx = /(\d+)(\d{3})/;
    while (rgx.test(x1)) {
        x1 = x1.replace(rgx, '$1' + ',' + '$2');
    }
    return x1 + x2;
}

