/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.alberta.model;

/**
 *
 * @author Cori 5
 */
public class DoctorClinic {
    
     private String doctorId;
     private String doctorClinicId;
     private String clinicId;
    private String timeFrom;
    private String consultancyFee;
    private String timeTo;
    private String maxAppointment;
    private String remarks;
    private String userName;
    private String[] weekdays;

    
    public String[] getWeekdays() {
        return weekdays;
    }

    public void setWeekdays(String[] weekdays) {
        this.weekdays = weekdays;
    }
    public String getMaxAppointment() {
        return maxAppointment;
    }

    public void setMaxAppointment(String maxAppointment) {
        this.maxAppointment = maxAppointment;
    }
    /**
     * @return the doctorId
     */
    public String getDoctorId() {
        return doctorId;
    }

    /**
     * @param doctorId the doctorId to set
     */
    public void setDoctorId(String doctorId) {
        this.doctorId = doctorId;
    }

    /**
     * @return the clinicId
     */
    public String getClinicId() {
        return clinicId;
    }

    /**
     * @param clinicId the clinicId to set
     */
    public void setClinicId(String clinicId) {
        this.clinicId = clinicId;
    }

    /**
     * @return the timeFrom
     */
    public String getTimeFrom() {
        return timeFrom;
    }

    /**
     * @param timeFrom the timeFrom to set
     */
    public void setTimeFrom(String timeFrom) {
        this.timeFrom = timeFrom;
    }

    /**
     * @return the timeTO
     */
    public String getTimeTo() {
        return timeTo;
    }

    /**
     * @param timeTO the timeTO to set
     */
    public void setTimeTo(String timeTo) {
        this.timeTo = timeTo;
    }

    /**
     * @return the remarks
     */
    public String getRemarks() {
        return remarks;
    }

    /**
     * @param remarks the remarks to set
     */
    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    /**
     * @return the userName
     */
    public String getUserName() {
        return userName;
    }

    /**
     * @param userName the userName to set
     */
    public void setUserName(String userName) {
        this.userName = userName;
    }

    /**
     * @return the doctorClinicId
     */
    public String getDoctorClinicId() {
        return doctorClinicId;
    }

    /**
     * @param doctorClinicId the doctorClinicId to set
     */
    public void setDoctorClinicId(String doctorClinicId) {
        this.doctorClinicId = doctorClinicId;
    }

    public String getConsultancyFee() {
        return consultancyFee;
    }

    public void setConsultancyFee(String consultancyFee) {
        this.consultancyFee = consultancyFee;
    }
    
   
}
