/**
 * Copyright (c) 2015 by My Company
 * This file and its contents are Confidential.
 */
package com.mycompany.example;



/**
 * Generated by John Doe from java_objects_test2.xml on 15/6/2015
 */
public class Buffer implements android.os.Parcelable {
    /**
     * private fields 
     */
    private final byte mTag;
    private final java.util.ArrayList<Byte> mMessage;
    private final java.util.ArrayList<java.util.Date> mDates;
    private final java.util.Date mDate;
    private final java.util.ArrayList<org.joda.time.DateTime> mJodaDates;
    private final org.joda.time.DateTime mJodaDate;
    private final java.util.ArrayList<String> mStrings;

    public Buffer(byte tag,
                  java.util.ArrayList<Byte> message,
                  java.util.ArrayList<java.util.Date> dates,
                  java.util.Date date,
                  java.util.ArrayList<org.joda.time.DateTime> jodaDates,
                  org.joda.time.DateTime jodaDate,
                  java.util.ArrayList<String> strings) {
        mTag = tag;
        mMessage = message;
        mDates = dates;
        mDate = date;
        mJodaDates = jodaDates;
        mJodaDate = jodaDate;
        mStrings = strings;
    }

    /**
     * Implementing Parcelable interface 
     */

    /**
     * Parses the string specified using supplied formatter
     *
     * @param dateString   string to parse
     * @param format       formatter used to parse the date string
     * @return             parsed DateTime object or DateTime epoch object in case of error
     */
    private static org.joda.time.DateTime parseDate(String dateString, org.joda.time.format.DateTimeFormatter format) {
        org.joda.time.DateTime result = new org.joda.time.DateTime(0);
        try {
            result = format.parseDateTime(dateString);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * Parses the string specified using supplied formatter
     *
     * @param dateString   string to parse
     * @param format       formatter used to parse the date string
     * @return             parsed Date object or Date epoch object in case of error
     */
    private static java.util.Date parseDate(String dateString, java.text.SimpleDateFormat format) {
        java.util.Date result = new java.util.Date(0);
        try {
            result = format.parse(dateString);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    @SuppressWarnings("unchecked")
    public Buffer(android.os.Parcel in) {
        final java.text.SimpleDateFormat ISO8601_JAVA_DATE_FORMAT = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
        final org.joda.time.format.DateTimeFormatter ISO8601_JODA_DATE_FORMAT = org.joda.time.format.ISODateTimeFormat.dateTime();
        this.mTag = in.readByte();
        this.mMessage = (java.util.ArrayList<Byte>)in.readSerializable();
        this.mDates = new java.util.ArrayList<java.util.Date>();
        {
            java.util.ArrayList<String> tmpArray = new java.util.ArrayList<String>();
            in.readStringList(tmpArray);
            for (String date : tmpArray)
                this.mDates.add(parseDate(date, ISO8601_JAVA_DATE_FORMAT));
        };
        this.mDate = parseDate(in.readString(), ISO8601_JAVA_DATE_FORMAT);
        this.mJodaDates = new java.util.ArrayList<org.joda.time.DateTime>();
        {
            java.util.ArrayList<String> tmpArray = new java.util.ArrayList<String>();
            in.readStringList(tmpArray);
            for (String date : tmpArray)
                this.mJodaDates.add(parseDate(date, ISO8601_JODA_DATE_FORMAT));
        };
        this.mJodaDate = parseDate(in.readString(), ISO8601_JODA_DATE_FORMAT);
        this.mStrings = new java.util.ArrayList<String>();in.readStringList(this.mStrings);
    }

    @Override
    public void writeToParcel(android.os.Parcel out, int flags) {
        final java.text.SimpleDateFormat ISO8601_JAVA_DATE_FORMAT = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
        final org.joda.time.format.DateTimeFormatter ISO8601_JODA_DATE_FORMAT = org.joda.time.format.ISODateTimeFormat.dateTime();
        out.writeByte(mTag);
        out.writeSerializable(mMessage);
        {
            java.util.ArrayList<String> tmpArray = new java.util.ArrayList<String>();
            for (java.util.Date date : mDates)
                tmpArray.add(ISO8601_JAVA_DATE_FORMAT.format(date));
            out.writeStringList(tmpArray);
        };
        out.writeString(ISO8601_JAVA_DATE_FORMAT.format(mDate));
        {
            java.util.ArrayList<String> tmpArray = new java.util.ArrayList<String>();
            for (org.joda.time.DateTime date : mJodaDates)
                tmpArray.add(ISO8601_JODA_DATE_FORMAT.print(date));
            out.writeStringList(tmpArray);
        };
        out.writeString(ISO8601_JODA_DATE_FORMAT.print(mJodaDate));
        out.writeStringList(this.mStrings);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final android.os.Parcelable.Creator<Buffer> CREATOR = new android.os.Parcelable.Creator<Buffer>() {
        public Buffer createFromParcel(android.os.Parcel in) {
            return new Buffer(in);
        }
        public Buffer[] newArray(int size) {
            return new Buffer[size];
        }
    };

    /**
     * Parcelable interface implementation done 
     */

    /**
     * Getters 
     */

    /**
     * @return the value of the "tag" field
     */
    public byte getTag() {
        return this.mTag;
    }

    /**
     * @return the value of the "message" field
     */
    public java.util.ArrayList<Byte> getMessage() {
        return this.mMessage;
    }

    /**
     * @return the value of the "dates" field
     */
    public java.util.ArrayList<java.util.Date> getDates() {
        return this.mDates;
    }

    /**
     * @return the value of the "date" field
     */
    public java.util.Date getDate() {
        return this.mDate;
    }

    /**
     * @return the value of the "joda-dates" field
     */
    public java.util.ArrayList<org.joda.time.DateTime> getJodaDates() {
        return this.mJodaDates;
    }

    /**
     * @return the value of the "joda-date" field
     */
    public org.joda.time.DateTime getJodaDate() {
        return this.mJodaDate;
    }

    /**
     * @return the value of the "strings" field
     */
    public java.util.ArrayList<String> getStrings() {
        return this.mStrings;
    }

}
