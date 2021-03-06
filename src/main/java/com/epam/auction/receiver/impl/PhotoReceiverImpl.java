package com.epam.auction.receiver.impl;

import com.epam.auction.controller.RequestContent;
import com.epam.auction.dao.impl.DAOFactory;
import com.epam.auction.dao.PhotoDAO;
import com.epam.auction.db.DAOManager;
import com.epam.auction.entity.Photo;
import com.epam.auction.exception.DAOException;
import com.epam.auction.exception.MethodNotSupportedException;
import com.epam.auction.exception.PhotoLoadingException;
import com.epam.auction.exception.ReceiverException;
import com.epam.auction.receiver.PhotoReceiver;
import com.epam.auction.receiver.RequestConstant;
import com.epam.auction.util.JSONConverter;
import com.epam.auction.util.PhotoLoader;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

class PhotoReceiverImpl implements PhotoReceiver {

    @Override
    public void loadPhoto(RequestContent requestContent) throws ReceiverException {
        int itemId = Integer.valueOf(requestContent.getRequestParameter(RequestConstant.ITEM_ID)[0]);

        PhotoDAO photoDAO = DAOFactory.getInstance().getPhotoDAO();
        Photo photo;

        try (DAOManager daoManager = new DAOManager(photoDAO)) {
            photo = photoDAO.findItemPhoto(itemId);
            if (photo != null) {
                PhotoLoader photoLoader = new PhotoLoader();
                requestContent.setAjaxResponse(photoLoader.loadPhotoAsString(photo.getId()));
            }
        } catch (DAOException | PhotoLoadingException e) {
            throw new ReceiverException(e);
        }
    }

    @Override
    public void loadAllPhotos(RequestContent requestContent) throws ReceiverException {
        int itemId = Integer.valueOf(requestContent.getRequestParameter(RequestConstant.ITEM_ID)[0]);

        PhotoDAO photoDAO = DAOFactory.getInstance().getPhotoDAO();
        List<String> photosFiles = new ArrayList<>();

        try (DAOManager daoManager = new DAOManager(photoDAO)) {
            PhotoLoader photoLoader = new PhotoLoader();
            List<Photo> photos = photoDAO.findAll(itemId);
            if (!photos.isEmpty()) {
                for (Photo photo : photos) {
                    photosFiles.add(photoLoader.loadPhotoAsString(photo.getId()));
                }
            }
            requestContent.setAjaxResponse(JSONConverter.objectAsJson(photosFiles));
        } catch (DAOException | PhotoLoadingException e) {
            throw new ReceiverException(e);
        }
    }

    @Override
    public void loadPhotosForDelete(RequestContent requestContent) throws ReceiverException {
        int itemId = Integer.valueOf(requestContent.getRequestParameter(RequestConstant.ITEM_ID)[0]);

        PhotoDAO photoDAO = DAOFactory.getInstance().getPhotoDAO();
        Map<Long, String> photos = new HashMap<>();

        try (DAOManager daoManager = new DAOManager(photoDAO)) {
            PhotoLoader photoLoader = new PhotoLoader();
            for (Photo photo : photoDAO.findAll(itemId)) {
                photos.put(photo.getId(), photoLoader.loadPhotoAsString(photo.getId()));
            }
            requestContent.setAjaxResponse(JSONConverter.objectAsJson(photos));
        } catch (DAOException | PhotoLoadingException e) {
            throw new ReceiverException(e);
        }
    }

    @Override
    public void deletePhotos(RequestContent requestContent) throws ReceiverException {
        String[] photosToDelete = requestContent.getRequestParameter(RequestConstant.PHOTO_ID);

        if (photosToDelete != null) {
            PhotoDAO photoDAO = DAOFactory.getInstance().getPhotoDAO();
            DAOManager daoManager = new DAOManager(true, photoDAO);

            daoManager.beginTransaction();

            PhotoLoader photoLoader = new PhotoLoader();
            try {
                for (String photoToDelete : photosToDelete) {
                    photoDAO.delete(Long.valueOf(photoToDelete));
                    photoLoader.deletePhoto(photoToDelete);
                }
                daoManager.commit();
            } catch (DAOException | PhotoLoadingException | MethodNotSupportedException e) {
                daoManager.rollback();
                throw new ReceiverException(e);
            } finally {
                daoManager.endTransaction();
            }
        }
    }

}