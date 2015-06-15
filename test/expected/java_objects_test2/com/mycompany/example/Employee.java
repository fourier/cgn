/**
 * Copyright (c) 2015 by My Company
 * This file and its contents are Confidential.
 */
package com.mycompany.example;


import UnknownType;

/**
 * Generated by John Doe from java_objects_test2.xml on 15/6/2015
 */
public class Employee implements android.os.Parcelable {
    /**
     * private fields 
     */
    private final int mId;
    private final UnknownType mUnknown;
    private final UserData mData;
    private final boolean mProbation;
    private final org.joda.time.DateTime mStarted;

    /**
     * Internal Builder class for the Employee
     */
    public static class Builder {

        private int mId;
        private UnknownType mUnknown;
        private UserData mData;
        private boolean mProbation;
        private org.joda.time.DateTime mStarted;

        public Builder() {
        }

        /**
         * Sets the "id" field to the value supplied 
         * 
         * @param id the value to the set into the "id" field
         * @return reference to this object instance
         */
        public Builder setId(int id) {
            this.mId = id;
            return this;
        }

        /**
         * Sets the "unknown" field to the value supplied 
         * 
         * @param unknown the value to the set into the "unknown" field
         * @return reference to this object instance
         */
        public Builder setUnknown(UnknownType unknown) {
            this.mUnknown = unknown;
            return this;
        }

        /**
         * Sets the "data" field to the value supplied 
         * 
         * @param data the value to the set into the "data" field
         * @return reference to this object instance
         */
        public Builder setData(UserData data) {
            this.mData = data;
            return this;
        }

        /**
         * Sets the "probation" field to the value supplied 
         * 
         * @param probation the value to the set into the "probation" field
         * @return reference to this object instance
         */
        public Builder setProbation(boolean probation) {
            this.mProbation = probation;
            return this;
        }

        /**
         * Sets the "started" field to the value supplied 
         * 
         * @param started the value to the set into the "started" field
         * @return reference to this object instance
         */
        public Builder setStarted(org.joda.time.DateTime started) {
            this.mStarted = started;
            return this;
        }

        /**
         * Creates the object instance 
         * @return created instance of the <code>Employee</code>
         */
        public Employee create() {
            return new Employee(this);
        }
    }

    /**
     * Constructor from the Builder 
     */
    protected Employee(Builder builder) {
        mId = builder.mId;
        mUnknown = builder.mUnknown;
        mData = builder.mData;
        mProbation = builder.mProbation;
        mStarted = builder.mStarted;
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
    public Employee(android.os.Parcel in) {
        final org.joda.time.format.DateTimeFormatter ISO8601_JODA_DATE_FORMAT = org.joda.time.format.ISODateTimeFormat.dateTime();
        this.mId = in.readInt();
        this.mUnknown = (UnknownType)in.readParcelable(UnknownType.class.getClassLoader());
        this.mData = (com.mycompany.example.UserData)in.readParcelable(com.mycompany.example.UserData.class.getClassLoader());
        this.mProbation = in.readByte() != 0;
        this.mStarted = parseDate(in.readString(), ISO8601_JODA_DATE_FORMAT);
    }

    @Override
    public void writeToParcel(android.os.Parcel out, int flags) {
        final org.joda.time.format.DateTimeFormatter ISO8601_JODA_DATE_FORMAT = org.joda.time.format.ISODateTimeFormat.dateTime();
        out.writeInt(mId);
        out.writeParcelable(mUnknown, flags);
        out.writeParcelable(mData, flags);
        out.writeByte((byte)(mProbation ? 1 : 0));
        out.writeString(ISO8601_JODA_DATE_FORMAT.print(mStarted));
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final android.os.Parcelable.Creator<Employee> CREATOR = new android.os.Parcelable.Creator<Employee>() {
        public Employee createFromParcel(android.os.Parcel in) {
            return new Employee(in);
        }
        public Employee[] newArray(int size) {
            return new Employee[size];
        }
    };

    /**
     * Parcelable interface implementation done 
     */

    /**
     * Getters 
     */

    /**
     * @return the value of the "id" field
     */
    public int getId() {
        return this.mId;
    }

    /**
     * @return the value of the "unknown" field
     */
    public UnknownType getUnknown() {
        return this.mUnknown;
    }

    /**
     * @return the value of the "data" field
     */
    public UserData getData() {
        return this.mData;
    }

    /**
     * @return the value of the "probation" field
     */
    public boolean getProbation() {
        return this.mProbation;
    }

    /**
     * @return the value of the "started" field
     */
    public org.joda.time.DateTime getStarted() {
        return this.mStarted;
    }

}