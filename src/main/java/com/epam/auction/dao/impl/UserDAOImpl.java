package com.epam.auction.dao.impl;

import com.epam.auction.dao.TableConstant;
import com.epam.auction.dao.UserDAO;
import com.epam.auction.entity.User;
import com.epam.auction.exception.DAOException;
import com.epam.auction.exception.MethodNotSupportedException;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

/**
 * Provides the base model implementation for `user` table DAO.
 */
class UserDAOImpl extends GenericDAOImpl<User> implements UserDAO {

    /**
     * Constructs dao for `user` table.
     */
    UserDAOImpl() {
        super(TableConstant.USER_QUERY_FIND_ALL,
                TableConstant.USER_QUERY_FIND_BY_ID,
                null,
                TableConstant.USER_QUERY_CREATE,
                TableConstant.USER_QUERY_UPDATE);
    }

    @Override
    public void delete(long id) throws DAOException, MethodNotSupportedException {
        throw new MethodNotSupportedException();
    }

    @Override
    User extractEntity(ResultSet resultSet) throws SQLException {
        return new User(
                resultSet.getLong(TableConstant.USER_COLUMN_ID),
                resultSet.getString(TableConstant.USER_COLUMN_USERNAME),
                resultSet.getString(TableConstant.USER_COLUMN_PASSWORD),
                resultSet.getString(TableConstant.USER_COLUMN_LAST_NAME),
                resultSet.getString(TableConstant.USER_COLUMN_MIDDLE_NAME),
                resultSet.getString(TableConstant.USER_COLUMN_FIRST_NAME),
                resultSet.getString(TableConstant.USER_COLUMN_PHONE_NUMBER),
                resultSet.getString(TableConstant.USER_COLUMN_EMAIL),
                resultSet.getBoolean(TableConstant.USER_COLUMN_IS_BANNED),
                User.UserRole.define(resultSet.getInt(TableConstant.USER_COLUMN_USER_ROLE_ID)));
    }

    @Override
    void defineQueryAttributes(User entity, PreparedStatement statement) throws SQLException {
        statement.setString(1, entity.getUsername());
        statement.setString(2, entity.getPassword());
        statement.setString(3, entity.getLastName());
        statement.setString(4, entity.getMiddleName());
        statement.setString(5, entity.getFirstName());
        statement.setString(6, entity.getPhoneNumber());
        statement.setString(7, entity.getEmail());
        statement.setBoolean(8, entity.getIsBanned());
        statement.setInt(9, entity.getRole().ordinal());
    }

    @Override
    public boolean isExist(User user) throws DAOException {
        boolean result = false;
        try (PreparedStatement statement = connection.prepareStatement(TableConstant.USER_QUERY_IS_EXIST)) {
            statement.setString(1, user.getUsername());
            statement.setString(2, user.getPassword());

            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                user.setId(resultSet.getLong(TableConstant.USER_COLUMN_ID));
                user.setLastName(resultSet.getString(TableConstant.USER_COLUMN_LAST_NAME));
                user.setMiddleName(resultSet.getString(TableConstant.USER_COLUMN_MIDDLE_NAME));
                user.setFirstName(resultSet.getString(TableConstant.USER_COLUMN_FIRST_NAME));
                user.setPhoneNumber(resultSet.getString(TableConstant.USER_COLUMN_PHONE_NUMBER));
                user.setEmail(resultSet.getString(TableConstant.USER_COLUMN_EMAIL));
                user.setIsBanned(resultSet.getBoolean(TableConstant.USER_COLUMN_IS_BANNED));
                user.setRole(User.UserRole.define(resultSet.getInt(TableConstant.USER_COLUMN_USER_ROLE_ID)));

                result = true;
            }

        } catch (SQLException e) {
            throw new DAOException(e);
        }
        return result;
    }

    public boolean isUsernameAlreadyExist(String username) throws DAOException {
        return isAlreadyExist(username, TableConstant.USER_QUERY_IS_EXIST_USERNAME);
    }

    public boolean isEmailAlreadyExist(String email) throws DAOException {
        return isAlreadyExist(email, TableConstant.USER_QUERY_IS_EXIST_EMAIL);
    }

    @Override
    public int countRows() throws DAOException {
        return countRows(TableConstant.USER_QUERY_FIND_ROWS_COUNT_USERS, statement -> {
        });
    }

    @Override
    public List<User> findUsersWithLimit(int offset, int limit) throws DAOException {
        return findSpecificList(TableConstant.USER_QUERY_FIND_USERS, statement -> {
            statement.setInt(1, offset);
            statement.setInt(2, limit);
        });
    }

    @Override
    public void updateUserStatus(boolean isBanned, int userId) throws DAOException {
        executeUpdate(TableConstant.USER_QUERY_UPDATE_STATUS, statement -> {
            statement.setBoolean(1, isBanned);
            statement.setLong(2, userId);
        });
    }

    @Override
    public int countRows(String username) throws DAOException {
        return countRows(TableConstant.USER_QUERY_FIND_ROWS_COUNT_USERNAME, statement -> {
            statement.setString(1, "%" + username + "%");
        });
    }

    @Override
    public List<User> findByUsername(String username, int offset, int limit) throws DAOException {
        return findSpecificList(TableConstant.USER_QUERY_FIND_BY_USERNAME, statement -> {
            statement.setString(1, "%" + username + "%");
            statement.setInt(2, offset);
            statement.setInt(3, limit);
        });
    }

    /**
     * Returns <code>true</code> if user with parameter in database.
     *
     * @param parameter parameter
     * @param query     query to execute
     * @return <code>true</code> if user with parameter exists in database;
     * <code>false</code> otherwise
     * @throws DAOException if SQL exception occurred
     */
    private boolean isAlreadyExist(String parameter, String query) throws DAOException {
        boolean result = false;
        try (PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setString(1, parameter);

            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                result = resultSet.getBoolean(1);
            }
        } catch (SQLException e) {
            throw new DAOException(e);
        }
        return result;
    }

}