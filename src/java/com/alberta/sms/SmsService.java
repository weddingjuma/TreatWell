/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.alberta.sms;

import com.alberta.dao.DAO;
import com.alberta.email.EmailService;

/**
 *
 * @author farazahmad
 */
public interface SmsService {

    /**
     * @return the dao
     */
    DAO getDao();

    /**
     * @param dao the dao to set
     */
    void setDao(DAO dao);

    boolean sendAppointmentMessage(String appointmentId);

    EmailService getEmailService();

    void setEmailService(EmailService emailService);

    boolean sendAppointmentCancelMessage(String appointmentId);
}
