/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.alberta.ums;

import com.alberta.dao.DAO;
import com.alberta.model.BusinessUnit;
import com.alberta.model.Rights;
import com.alberta.model.Role;
import com.alberta.model.SpecialRights;
import com.alberta.model.User;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Faraz
 */
public interface UmsService {

    DAO getDao();

    void setDao(DAO dao);

    boolean editUser(User user);

    List<Map> getAllUsers(String activeInd);

    User getUserById(String id);

    boolean saveRole(Role role, String companyId, String moduleId);

    List<Map> getAllRoles();

    Role getRoleById(String id);

    List<Rights> getAllRights(String userName, String moduleId);

    boolean assignRights(String selectedUser, List<Rights> rightIds, String userName);

    boolean assignUserRole(String userId, String[] role, String userName, String moduleId);

    boolean hasRightsOn(String userName, String url);

    List<Role> getRolesByUserId(String userId, String moduleId);

    List<Rights> getRightsByRoleId(String roleId, String userName, String moduleId);

    List getAllChildRights(String userName);

    boolean deleteUser(String userId);

    boolean deleteRole(String roleId);

    List<SpecialRights> getAllSpecialRights(String userName, String moduleId, String companyId);

    public List<SpecialRights> getAllSpecialRightsByUser(String userName, String moduleId, String companyId);

    boolean assignSpecialRights(String userId, String[] rights, String moduleId, String userName, String companyId);

    boolean hasSpecialRightOn(String userName, String specialRightName);

    boolean hasRightOn(String userName, String rightName, String action);

    boolean isUserExists(String userName, String companyId);

    boolean isRoleExists(String roleName, String companyId);

    List getAllSitesByUser(String userName, String companyId);

    boolean assignUserSites(String userId, String[] sites, String userName);

    boolean assignUserVoucherSubTypes(String userId, String[] rights, String userName, String companyId);

    List getAllVoucherSubTypesByUser(String userName, String companyId);

    List<Rights> getAllParentRights(String moduleId);

    List<BusinessUnit> getBusinessUnitByUserId(String userId, String companyId);

    boolean assignUserBusinessUnit(String user, String[] units, String userName);

    Map getUserRights(String userName, String rightName);

    List<Rights> getRightsByUser(String userName, String moduleId, String companyId);

    boolean hasSpecialRightOn(String userName, String specialRightName, String moduleId);

    boolean saveUsers(User u);

    Map getUsersById(String userId);

    List<Map> getUserForDoctor(String doctorId);

    List<Rights> getRightsForAdmin();

    List<Rights> getRightsForNonAdminUsers(String userName);

    List<Rights> getParentRightsForAdmin();

    List<Rights> getParentRightsForNonAdmin(String userName);

    boolean updatePassword(User u);

    boolean updateUserStatus(String userName, String activeInd);

    List<Rights> getRightsByRole(String roleId);

    boolean assignRoleRights(String roleId, List<Rights> rightIds, String userName);

    List<Map> getUserForPharma(String pharmaId);

    List<Map> getUserForLab(String detailId);

    List<Map> getUserForPharmacy(String pharmacyId);

    List<Map> getUserForClinic(String clinicId);

    List<Map> getAllMobileRights();

    List<Map> getUserMobileRights(String userName);

    boolean assignMobileRights(String selectedUser, String[] rightIds, String userName);
}
