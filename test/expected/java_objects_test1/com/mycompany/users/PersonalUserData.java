/**
 * Copyright (c) 2014 by My Company
 * This file and its contents are Confidential.
 */
package com.mycompany.users;



/**
 * Generated by The Author from java_objects_test1.xml on 15/6/2015
 */
public class PersonalUserData implements android.os.Parcelable {
    /**
     * private fields 
     */
    private String mName;
    private String mOccupation;
    private int mAge;
    private java.util.ArrayList<org.joda.time.DateTime> mVisits;

    public PersonalUserData() {
    }

    public PersonalUserData(String name,
                            String occupation,
                            int age,
                            java.util.ArrayList<org.joda.time.DateTime> visits) {
        mName = name;
        mOccupation = occupation;
        mAge = age;
        mVisits = visits;
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

    @SuppressWarnings("unchecked")
    public PersonalUserData(android.os.Parcel in) {
        final org.joda.time.format.DateTimeFormatter ISO8601_JODA_DATE_FORMAT = org.joda.time.format.ISODateTimeFormat.dateTime();
        this.mName = in.readString();
        this.mOccupation = in.readString();
        this.mAge = in.readInt();
        this.mVisits = new java.util.ArrayList<org.joda.time.DateTime>();
        {
            java.util.ArrayList<String> tmpArray = new java.util.ArrayList<String>();
            in.readStringList(tmpArray);
            for (String date : tmpArray)
                this.mVisits.add(parseDate(date, ISO8601_JODA_DATE_FORMAT));
        };
    }

    @Override
    public void writeToParcel(android.os.Parcel out, int flags) {
        final org.joda.time.format.DateTimeFormatter ISO8601_JODA_DATE_FORMAT = org.joda.time.format.ISODateTimeFormat.dateTime();
        out.writeString(mName);
        out.writeString(mOccupation);
        out.writeInt(mAge);
        {
            java.util.ArrayList<String> tmpArray = new java.util.ArrayList<String>();
            for (org.joda.time.DateTime date : mVisits)
                tmpArray.add(ISO8601_JODA_DATE_FORMAT.print(date));
            out.writeStringList(tmpArray);
        };
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final android.os.Parcelable.Creator<PersonalUserData> CREATOR = new android.os.Parcelable.Creator<PersonalUserData>() {
        public PersonalUserData createFromParcel(android.os.Parcel in) {
            return new PersonalUserData(in);
        }
        public PersonalUserData[] newArray(int size) {
            return new PersonalUserData[size];
        }
    };

    /**
     * Parcelable interface implementation done 
     */

    /**
     * Getters 
     */

    /**
     * @return the value of the "name" field
     */
    public String getName() {
        return this.mName;
    }

    /**
     * @return the value of the "occupation" field
     */
    public String getOccupation() {
        return this.mOccupation;
    }

    /**
     * @return the value of the "age" field
     */
    public int getAge() {
        return this.mAge;
    }

    /**
     * @return the value of the "visits" field
     */
    public java.util.ArrayList<org.joda.time.DateTime> getVisits() {
        return this.mVisits;
    }

    /**
     * Setters 
     */

    /**
     * Sets the "name" field to the value supplied 
     * 
     * @param name the value to the set into the "name" field
     * @return reference to this object instance
     */
    public PersonalUserData setName(String name) {
        this.mName = name;
        return this;
    }

    /**
     * Sets the "occupation" field to the value supplied 
     * 
     * @param occupation the value to the set into the "occupation" field
     * @return reference to this object instance
     */
    public PersonalUserData setOccupation(String occupation) {
        this.mOccupation = occupation;
        return this;
    }

    /**
     * Sets the "age" field to the value supplied 
     * 
     * @param age the value to the set into the "age" field
     * @return reference to this object instance
     */
    public PersonalUserData setAge(int age) {
        this.mAge = age;
        return this;
    }

    /**
     * Sets the "visits" field to the value supplied 
     * 
     * @param visits the value to the set into the "visits" field
     * @return reference to this object instance
     */
    public PersonalUserData setVisits(java.util.ArrayList<org.joda.time.DateTime> visits) {
        this.mVisits = visits;
        return this;
    }

}
