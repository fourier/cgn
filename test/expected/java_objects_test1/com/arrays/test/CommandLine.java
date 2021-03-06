/**
 * Copyright (c) 2015 by My Company
 * This file and its contents are Confidential.
 */
package com.arrays.test;



/**
 * Generated by John Doe from java_objects_test1.xml on 15/6/2015
 */
public class CommandLine {
    /**
     * private fields 
     */
    private String mExecutable;
    private java.util.ArrayList<String> mArguments;

    /**
     * Internal Builder class for the CommandLine
     */
    public static class Builder {

        private String mExecutable;
        private java.util.ArrayList<String> mArguments;

        public Builder() {
        }

        /**
         * Sets the "executable" field to the value supplied 
         * 
         * @param executable the value to the set into the "executable" field
         * @return reference to this object instance
         */
        public Builder setExecutable(String executable) {
            this.mExecutable = executable;
            return this;
        }

        /**
         * Sets the "arguments" field to the value supplied 
         * 
         * @param arguments the value to the set into the "arguments" field
         * @return reference to this object instance
         */
        public Builder setArguments(java.util.ArrayList<String> arguments) {
            this.mArguments = arguments;
            return this;
        }

        /**
         * Creates the object instance 
         * @return created instance of the <code>CommandLine</code>
         */
        public CommandLine create() {
            return new CommandLine(this);
        }
    }

    public CommandLine() {
    }

    public CommandLine(String executable,
                       java.util.ArrayList<String> arguments) {
        mExecutable = executable;
        mArguments = arguments;
    }

    /**
     * Constructor from the Builder 
     */
    protected CommandLine(Builder builder) {
        mExecutable = builder.mExecutable;
        mArguments = builder.mArguments;
    }

    /**
     * Getters 
     */

    /**
     * @return the value of the "executable" field
     */
    public String getExecutable() {
        return this.mExecutable;
    }

    /**
     * @return the value of the "arguments" field
     */
    public java.util.ArrayList<String> getArguments() {
        return this.mArguments;
    }

    /**
     * Setters 
     */

    /**
     * Sets the "executable" field to the value supplied 
     * 
     * @param executable the value to the set into the "executable" field
     * @return reference to this object instance
     */
    public CommandLine setExecutable(String executable) {
        this.mExecutable = executable;
        return this;
    }

    /**
     * Sets the "arguments" field to the value supplied 
     * 
     * @param arguments the value to the set into the "arguments" field
     * @return reference to this object instance
     */
    public CommandLine setArguments(java.util.ArrayList<String> arguments) {
        this.mArguments = arguments;
        return this;
    }

}
