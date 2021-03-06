package com.epam.auction.validator;

import com.epam.auction.entity.Item;
import com.epam.auction.util.DateFixer;

import java.math.BigDecimal;
import java.sql.Date;
import java.util.Calendar;
import java.util.regex.Pattern;

public class ItemValidator extends Validator {

    private static final String NAME_PATTERN = "['A-Za-zА-Яа-яЁё0-9_\\- ]{2,45}";

    private static final String DESCRIPTION_ANTI_PATTERN = "<[^>]*>";

    private static final BigDecimal MIN_PRICE = BigDecimal.ZERO;
    private static final BigDecimal MAX_PRICE = new BigDecimal(999999999999999999999.0);

    private final Date minStartDate;

    public ItemValidator() {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DATE, 2);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        this.minStartDate = new Date(calendar.getTimeInMillis());
    }

    public boolean validateItemParam(Item item) {
        return validateItemParam(item.getName(), item.getDescription(),
                item.getStartPrice(), item.getBlitzPrice(),
                item.getStartDate(), item.getCloseDate());
    }

    public boolean validateItemParam(String name, String description,
                                     BigDecimal startPrice, BigDecimal blitzPrice,
                                     Date startDate, Date closeDate) {
        return validateName(name) &&
                validateDescription(description) &&
                validatePrice(startPrice) &&
                validateBlitzPrice(blitzPrice, startPrice) &&
                validateStartDate(startDate) &&
                validateCloseDate(closeDate, startDate);
    }

    public boolean validateName(String name) {
        return validate(name, NAME_PATTERN);
    }

    public boolean validateDescription(String description) {
        if (Pattern.compile(DESCRIPTION_ANTI_PATTERN).matcher(description).find()) {
            setValidationMessage("No code allowed in item description.");
            return false;
        } else {
            return true;
        }
    }

    public boolean validatePrice(BigDecimal value) {
        if (MIN_PRICE.compareTo(value) <= -1 && MAX_PRICE.compareTo(value) >= 1) {
            return true;
        } else {
            setValidationMessage("Price can be in range from " + MIN_PRICE + " to " + MAX_PRICE + ". Value: [" + value + "].");
            return false;
        }
    }

    public boolean validateBlitzPrice(BigDecimal blitzPrice, BigDecimal startPrice) {
        if (validatePrice(blitzPrice)) {
            if (blitzPrice.compareTo(startPrice) >= 1) {
                return true;
            } else {
                setValidationMessage("Blitz price can't be less then start price. Blitz price: [" +
                        blitzPrice + "], start price: [" + startPrice + "].");
                return false;
            }
        }
        return true;
    }

    public boolean validateStartDate(Date startDate) {
        if (minStartDate.compareTo(startDate) <= 0) {
            return true;
        } else {
            setValidationMessage("Start date can begin from: " + minStartDate +
                    ". Entered start date: " + startDate);
            return false;
        }
    }

    public boolean validateCloseDate(Date closeDate, Date startDate) {
        if (closeDate.compareTo(DateFixer.addDays(startDate, 2)) >= 0) {
            return true;
        } else {
            setValidationMessage("Close date must be 2 days after start date: " + startDate +
                    ". Entered close date: " + closeDate);
            return false;
        }
    }

}