/**
 * Copyright (c) 2015 by My Company
 * This file and its contents are Confidential.
 */
package com.mycompany.messages;



/**
 * Generated by John Doe from java_objects_test2.xml on 15/6/2015
 */
public class Conversation {
    /**
     * private fields 
     */
    private final String mTitle;
    private final java.util.ArrayList<Integer> mParticipantIds;
    private final java.util.ArrayList<String> mMessages;

    /**
     * Internal Builder class for the Conversation
     */
    public static class Builder {

        private String mTitle;
        private java.util.ArrayList<Integer> mParticipantIds;
        private java.util.ArrayList<String> mMessages;

        public Builder() {
        }

        /**
         * Sets the "title" field to the value supplied 
         * 
         * @param title the value to the set into the "title" field
         * @return reference to this object instance
         */
        public Builder setTitle(String title) {
            this.mTitle = title;
            return this;
        }

        /**
         * Sets the "participant-ids" field to the value supplied 
         * 
         * @param participantIds the value to the set into the "participant-ids" field
         * @return reference to this object instance
         */
        public Builder setParticipantIds(java.util.ArrayList<Integer> participantIds) {
            this.mParticipantIds = participantIds;
            return this;
        }

        /**
         * Sets the "messages" field to the value supplied 
         * 
         * @param messages the value to the set into the "messages" field
         * @return reference to this object instance
         */
        public Builder setMessages(java.util.ArrayList<String> messages) {
            this.mMessages = messages;
            return this;
        }

        /**
         * Creates the object instance 
         * @return created instance of the <code>Conversation</code>
         */
        public Conversation create() {
            return new Conversation(this);
        }
    }

    /**
     * Constructor from the Builder 
     */
    protected Conversation(Builder builder) {
        mTitle = builder.mTitle;
        mParticipantIds = builder.mParticipantIds;
        mMessages = builder.mMessages;
    }

    /**
     * Getters 
     */

    /**
     * @return the value of the "title" field
     */
    public String getTitle() {
        return this.mTitle;
    }

    /**
     * @return the value of the "participant-ids" field
     */
    public java.util.ArrayList<Integer> getParticipantIds() {
        return this.mParticipantIds;
    }

    /**
     * @return the value of the "messages" field
     */
    public java.util.ArrayList<String> getMessages() {
        return this.mMessages;
    }

}
