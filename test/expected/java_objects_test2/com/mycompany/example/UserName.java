/**
 * Copyright (c) 2015 by My Company
 * This file and its contents are Confidential.
 */
package com.mycompany.example;



/**
 * Generated by John Doe from java_objects_test2.xml on 15/6/2015
 */
public class UserName {
    /**
     * private fields 
     */
    private final String mUserName;

    /**
     * Internal Builder class for the UserName
     */
    public static class Builder {

        private String mUserName;

        public Builder() {
        }

        /**
         * Sets the "user-name" field to the value supplied 
         * 
         * @param userName the value to the set into the "user-name" field
         * @return reference to this object instance
         */
        public Builder setUserName(String userName) {
            this.mUserName = userName;
            return this;
        }

        /**
         * Creates the object instance 
         * @return created instance of the <code>UserName</code>
         */
        public UserName create() {
            return new UserName(this);
        }
    }

    /**
     * Constructor from the Builder 
     */
    protected UserName(Builder builder) {
        mUserName = builder.mUserName;
    }

    /**
     * Getters 
     */

    /**
     * @return the value of the "user-name" field
     */
    public String getUserName() {
        return this.mUserName;
    }

}